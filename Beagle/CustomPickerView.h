//
//  CustomPickerView.h
//  Beagle
//
//  Created by Kanav Gupta on 10/03/14.
//  Copyright (c) 2014 soclivity. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomPickerViewDelegate;
@interface CustomPickerView : UIView
@property (nonatomic, assign) id<CustomPickerViewDelegate> delegate;
-(void)buildTheLogic;
@end
@protocol CustomPickerViewDelegate
@optional
-(void) filterIndex:(NSInteger) index;


@end