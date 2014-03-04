//
//  BGFlickrManager.h
//  Beagle
//
//  Created by Kanav Gupta on 4/03/14.
//  Copyright (c) 2014 soclivity. All rights reserved.
//

#import "ObjectiveFlickr.h"
#import "BGPhotos.h"

@interface FlickrRequestInfo : NSObject

@property(nonatomic, strong) BGPhotos *photos;
@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) NSString *photoId;
@property(nonatomic, strong) NSString *userInfo;
@property(nonatomic, strong) NSURL *userPhotoWebPageURL;

@end

@interface BGFlickrManager : NSObject<OFFlickrAPIRequestDelegate>

@property(nonatomic, copy) void (^completionBlock)(FlickrRequestInfo *, NSError *);

@property(nonatomic, assign) bool isRunning;
@property(nonatomic, strong) OFFlickrAPIContext *flickrContext;
@property(nonatomic, strong) OFFlickrAPIRequest *flickrRequest;
@property(nonatomic, strong) FlickrRequestInfo *flickrRequestInfo;

@property(nonatomic, strong) NSDate *searchInvalidateCacheTimeout;
@property(nonatomic, strong) NSDate *searchQuitTimeout;


+ (BGFlickrManager *) sharedManager;
- (void) randomPhotoRequest: (void (^)(FlickrRequestInfo *, NSError *)) completion;

@end

typedef enum {
    FlickrAPIRequestPhotoSearch = 1,
    FlickrAPIRequestPhotoSizes = 2,
    FlickrAPIRequestPhotoOwner = 3,
} FlickrAPIRequestType;

@interface FlickrAPIRequestSessionInfo : NSObject

@property(nonatomic, assign) FlickrAPIRequestType flickrAPIRequestType;

@end

