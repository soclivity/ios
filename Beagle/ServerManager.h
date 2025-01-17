//
//  ServerManager.h
//  Beagle
//
//  Created by Kanav Gupta on 20/02/14.
//  Copyright (c) 2014 soclivity. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kServerCallUserRegisteration,
    kServerCallCreateActivity,
    kServerCallGetActivities,
    kServerCallGetDetailedInterest,
    kServerCallLeaveInterest,
    kServerCallParticipateInterest,
    kServerCallPostComment,
    kServerCallDeleteActivity,
    kServerCallEditActivity,
    kServerCallUpdateFbTicker,
    kServerCallGetNotifications,
    kServerCallInAppNotification,
    kServerCallInAppNotificationForPosts,
    kServerCallGetBackgroundChats,
    kServerInAppChatDetail,
    kServerCallRequestForOfflineNotification,
    kServerCallInAppForOfflinePost,
    kServerCallRequestForSilentNotification,
    kServerCallGetProfileMutualFriends,
    kServerCallGetDOS1Friends,
    kServerPostAPrivateMessageOnFacebook,
    kServerCallgetNearbyAndWorldWideFriends,
    kServerCallSuggestedPostMembership,
    kServerGetSignInInfo,
    kServerPostAnEmailInvite
} ServerCallType;

@class ServerManager;
@class BeagleUserClass;
@class BeagleActivityClass;
@class InterestChatClass;
@protocol ServerManagerDelegate <NSObject>

@optional

- (void)serverManagerDidFinishWithResponse:(NSDictionary *)response forRequest:(ServerCallType)serverRequest;
- (void)serverManagerDidFailWithError:(NSError *)error response:(NSDictionary *)response forRequest:(ServerCallType)serverRequest;
- (void)serverManagerDidFailDueToInternetConnectivityForRequest:(ServerCallType)serverRequest;

@end


@interface ServerManager : NSObject

@property (nonatomic,assign) id<ServerManagerDelegate> delegate;

-(void)releaseServerManager;
//*************************** API calls ***************************
-(void)registerPlayerOnBeagle:(BeagleUserClass*)data;
-(void)createActivityOnBeagle:(BeagleActivityClass*)data;
-(void)getActivities;
-(void)getDetailedInterest:(NSInteger)activityId;
-(void)removeMembership:(NSInteger)activityId playerid:(NSInteger)playerId;
-(void)participateMembership:(NSInteger)activityId playerid:(NSInteger)playerId;
-(void)postAComment:(NSInteger)activityId desc:(NSString*)desc;
-(void)deleteAnInterest:(NSInteger)activityId;
-(void)updateActivityOnBeagle:(BeagleActivityClass*)data;
-(void)updateFacebookTickerStatus:(BOOL)status;
-(void)getNotifications;
-(void)requestInAppNotificationForPosts:(NSInteger)chatId notifType:(NSInteger)notifType;
-(void)requestInAppNotification:(NSInteger)notificationId notifType:(NSInteger)notifType;
-(void)getMoreBackgroundPostsForAnInterest:(InterestChatClass*)lastChatPost activId:(NSInteger)activId;
-(void)getNewBackgroundPostsForAnInterest:(NSInteger)activityId;
-(void)getPostDetail:(NSInteger)chatId;
-(void)getMutualFriendsNetwork:(NSInteger)friendId;
-(void)getDOS1Friends;
-(void)sendingAPostMessageOnFacebook:(NSNumber*)fbuid;
-(void)getNearbyAndWorldWideFriends;
-(void)updateSuggestedPostMembership:(NSInteger)activityId;
-(void)userInfoOnBeagle:(NSString*)email;
-(void)sendingAnEmailInvite:(NSNumber*)fbuid;
@end
