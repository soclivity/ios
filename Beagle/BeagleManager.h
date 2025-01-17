//
//  BeagleManager.h
//  Beagle
//
//  Created by Kanav Gupta on 20/03/14.
//  Copyright (c) 2014 soclivity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@class BeagleUserClass;
@interface BeagleManager : NSObject{
   
    BeagleUserClass *beaglePlayer;
}
@property (nonatomic,strong)UIColor *lightDominantColor;
@property (nonatomic,strong)UIColor *mediumDominantColor;
@property (nonatomic,strong)UIColor *darkDominantColor;
@property (nonatomic,strong)CLLocation *currentLocation;
@property(nonatomic,strong)BeagleUserClass*beaglePlayer;
@property(nonatomic,strong)CLPlacemark *placemark;
@property(nonatomic,strong)NSString *weatherCondition;
@property(nonatomic,strong)NSString *timeOfDay;
@property(nonatomic,strong)NSString*photoId;
@property(nonatomic,assign)BOOL activityDeleted;
@property(nonatomic,assign)NSInteger badgeCount;
+ (id)SharedInstance;
-(void)userProfileDataUpdate;
-(void)getUserObjectInAutoSignInMode;
- (void)processFacebookProfilePictureData:(NSData *)newProfilePictureData;
@end
