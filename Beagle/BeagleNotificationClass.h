//
//  BeagleNotificationClass.h
//  Beagle
//
//  Created by Kanav Gupta on 20/05/14.
//  Copyright (c) 2014 soclivity. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BeagleActivityClass;
@interface BeagleNotificationClass : NSObject
@property (nonatomic,strong)NSString *notificationString;
@property (nonatomic,strong)NSString *date;
@property (nonatomic,strong)UIImage *profileImage;
@property (nonatomic,assign)NSInteger type;
@property (nonatomic,assign)NSString *count;
@property (nonatomic,assign)NSInteger notificationId;
@property (nonatomic,strong)NSString *userId;
@property (nonatomic,strong)NSString*expirationDate;
@property (nonatomic,strong)NSString*photoUrl;
@property(nonatomic,strong)NSString *latitude;
@property(nonatomic,strong)NSString *longitude;
@property(nonatomic,assign)NSInteger notificationType;
@property (nonatomic,assign)BOOL isRead;
@property(nonatomic,assign)CGFloat rowHeight;
@property(nonatomic,strong)NSString*timeOfNotification;
@property(nonatomic,assign)NSInteger referredId;
@property (nonatomic,assign)BOOL backgroundTap;
@property(nonatomic,assign)NSInteger playerId;
@property(nonatomic,strong)NSString*postDesc;
@property(nonatomic,strong)NSString*playerName;
@property(nonatomic,assign)NSInteger postChatId;
@property(nonatomic,assign)NSInteger activityOwnerId;
@property(nonatomic,assign)NSInteger activityType;
@property(nonatomic,assign)NSInteger notifType;
@property(nonatomic,strong)BeagleActivityClass*activity;
-(id) initWithDictionary:(NSDictionary *)dictionary;
@end
