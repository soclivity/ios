//
// ObjectiveFlickr.h

#import "LFWebAPIKit.h"
#import "OFUtilities.h"
#import "OFXMLMapper.h"

extern NSString *const OFFlickrSmallSquareSize;		// "s" - 75x75
extern NSString *const OFFlickrThumbnailSize;		// "t" - 100 on longest side
extern NSString *const OFFlickrSmallSize;			// "m" - 240 on longest side
extern NSString *const OFFlickrMediumSize;			// (no size modifier) - 500 on longest side

extern NSString *const OFFlickrMedium640Size;		// "z" - 640
extern NSString *const OFFlickrMedium800Size;		// "c" - 800
extern NSString *const OFFlickrSmall320Size;			// "n" - 320 on longest side
extern NSString *const OFFlickrLargeSize;			// "b" - 1024 on longest side

extern NSString *const OFFlickrReadPermission;
extern NSString *const OFFlickrWritePermission;
extern NSString *const OFFlickrDeletePermission;

@interface OFFlickrAPIContext : NSObject
{
    NSString *key;
    NSString *sharedSecret;
    NSString *authToken;
    
    NSString *RESTAPIEndpoint;
	NSString *photoSource;
	NSString *photoWebPageSource;
	NSString *authEndpoint;
    NSString *uploadEndpoint;
    
    NSString *oauthToken;
    NSString *oauthTokenSecret;
}
- (id)initWithAPIKey:(NSString *)inKey sharedSecret:(NSString *)inSharedSecret;

// OAuth URL
- (NSURL *)userAuthorizationURLWithRequestToken:(NSString *)inRequestToken requestedPermission:(NSString *)inPermission;

// URL provisioning
- (NSURL *)photoSourceURLFromDictionary:(NSDictionary *)inDictionary size:(NSString *)inSizeModifier;
- (NSURL *)photoWebPageURLFromDictionary:(NSDictionary *)inDictionary;
- (NSURL *)loginURLFromFrobDictionary:(NSDictionary *)inFrob requestedPermission:(NSString *)inPermission;

// API endpoints

#if MAC_OS_X_VERSION_MAX_ALLOWED > MAC_OS_X_VERSION_10_4
@property (nonatomic, readonly) NSString *key;
@property (nonatomic, readonly) NSString *sharedSecret;
@property (nonatomic, retain) NSString *authToken;

@property (nonatomic, retain) NSString *RESTAPIEndpoint;
@property (nonatomic, retain) NSString *photoSource;
@property (nonatomic, retain) NSString *photoWebPageSource;
@property (nonatomic, retain) NSString *authEndpoint;
@property (nonatomic, retain) NSString *uploadEndpoint;

@property (nonatomic, retain) NSString *OAuthToken;
@property (nonatomic, retain) NSString *OAuthTokenSecret;
#else

- (void)setAuthToken:(NSString *)inAuthToken;
- (NSString *)authToken;

- (void)setRESTAPIEndpoint:(NSString *)inEndpoint;
- (NSString *)RESTAPIEndpoint;

- (void)setPhotoSource:(NSString *)inSource;
- (NSString *)photoSource;

- (void)setAuthEndpoint:(NSString *)inEndpoint;
- (NSString *)authEndpoint;

- (void)setUploadEndpoint:(NSString *)inEndpoint;
- (NSString *)uploadEndpoint;

- (void)setOAuthToken:(NSString *)inToken;
- (NSString *)OAuthToken;

- (void)setOAuthTokenSecret:(NSString *)inTokenSecret;
- (NSString *)OAuthTokenSecret;


#endif
@end

extern NSString *const OFFlickrAPIReturnedErrorDomain;
extern NSString *const OFFlickrAPIRequestErrorDomain;

enum {
	// refer to Flickr API document for Flickr's own error codes
    OFFlickrAPIRequestConnectionError = 0x7fff0001,
    OFFlickrAPIRequestTimeoutError = 0x7fff0002,    
	OFFlickrAPIRequestFaultyXMLResponseError = 0x7fff0003,
    OFFlickrAPIRequestOAuthError = 0x7fff0004,
    OFFlickrAPIRequestUnknownError = 0x7fff0042    
};

extern NSString *const OFFlickrAPIRequestOAuthErrorUserInfoKey;

extern NSString *const OFFetchOAuthRequestTokenSession;
extern NSString *const OFFetchOAuthAccessTokenSession;

@class OFFlickrAPIRequest;

#if MAC_OS_X_VERSION_MAX_ALLOWED > MAC_OS_X_VERSION_10_4
@protocol OFFlickrAPIRequestDelegate <NSObject>
@optional
#else
@interface NSObject (OFFlickrAPIRequestDelegateCategory)
#endif
- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary;
- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError;
#if MAC_OS_X_VERSION_MAX_ALLOWED > MAC_OS_X_VERSION_10_4                
- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest imageUploadSentBytes:(NSUInteger)inSentBytes totalBytes:(NSUInteger)inTotalBytes;
#else
- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest imageUploadSentBytes:(unsigned int)inSentBytes totalBytes:(unsigned int)inTotalBytes;
#endif

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didObtainOAuthRequestToken:(NSString *)inRequestToken secret:(NSString *)inSecret;
- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didObtainOAuthAccessToken:(NSString *)inAccessToken secret:(NSString *)inSecret userFullName:(NSString *)inFullName userName:(NSString *)inUserName userNSID:(NSString *)inNSID;

@end

#if MAC_OS_X_VERSION_MAX_ALLOWED > MAC_OS_X_VERSION_10_4
typedef id<OFFlickrAPIRequestDelegate> OFFlickrAPIRequestDelegateType;
#else
typedef id OFFlickrAPIRequestDelegateType;
#endif

@interface OFFlickrAPIRequest : NSObject
{
    OFFlickrAPIContext *context;
    LFHTTPRequest *HTTPRequest;
    
    OFFlickrAPIRequestDelegateType delegate;
    id sessionInfo;
    
    NSString *uploadTempFilename;
    
    id oauthState;
}
- (id)initWithAPIContext:(OFFlickrAPIContext *)inContext;
- (OFFlickrAPIContext *)context;


- (NSTimeInterval)requestTimeoutInterval;
- (void)setRequestTimeoutInterval:(NSTimeInterval)inTimeInterval;
- (BOOL)isRunning;
- (void)cancel;

// oauth methods
- (BOOL)fetchOAuthRequestTokenWithCallbackURL:(NSURL *)inCallbackURL;
- (BOOL)fetchOAuthAccessTokenWithRequestToken:(NSString *)inRequestToken verifier:(NSString *)inVerifier;

// elementary methods
- (BOOL)callAPIMethodWithGET:(NSString *)inMethodName arguments:(NSDictionary *)inArguments tag:(NSInteger)tag;
- (BOOL)callAPIMethodWithPOST:(NSString *)inMethodName arguments:(NSDictionary *)inArguments;

// image upload—we use NSInputStream here because we want to have flexibity; with this you can upload either a file or NSData from NSImage
- (BOOL)uploadImageStream:(NSInputStream *)inImageStream suggestedFilename:(NSString *)inFilename MIMEType:(NSString *)inType arguments:(NSDictionary *)inArguments;

#if MAC_OS_X_VERSION_MAX_ALLOWED > MAC_OS_X_VERSION_10_4
@property (nonatomic, readonly) OFFlickrAPIContext *context;
@property (nonatomic, assign) OFFlickrAPIRequestDelegateType delegate;
@property (nonatomic, retain) id sessionInfo;
@property (nonatomic, assign) NSTimeInterval requestTimeoutInterval;
#else

- (OFFlickrAPIRequestDelegateType)delegate;
- (void)setDelegate:(OFFlickrAPIRequestDelegateType)inDelegate;

- (id)sessionInfo;
- (void)setSessionInfo:(id)inInfo;

#endif

@end
