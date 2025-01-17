//
// OFXMLMapper.h
//

#import <Foundation/Foundation.h>

extern NSString *const OFXMLTextContentKey;

#if (MAC_OS_X_VERSION_10_6 && MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_6) || (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_2_0)
@interface OFXMLMapper : NSObject <NSXMLParserDelegate>
#else
@interface OFXMLMapper : NSObject
#endif
{
    NSMutableDictionary *resultantDictionary;
	
	NSMutableArray *elementStack;
	NSMutableDictionary *currentDictionary;
	NSString *currentElementName;
}
+ (NSDictionary *)dictionaryMappedFromXMLData:(NSData *)inData;
@end

@interface NSDictionary (OFXMLMapperExtension)
- (NSString *)textContent;

#if MAC_OS_X_VERSION_MAX_ALLOWED > MAC_OS_X_VERSION_10_4
@property (nonatomic, readonly) NSString *textContent;
#endif
@end
