//
//  DismissiveTextView.m
//  Beagle
//
//  Created by Kanav Gupta on 9/17/14.
//  Copyright (c) 2014 soclivity. All rights reserved.
//

#import "DismissiveTextView.h"

@interface DismissiveTextView ()

@property (strong, nonatomic) UIView *keyboardView;
@property (assign, nonatomic) CGFloat previousKeyboardY;

- (void)handleKeyboardWillShowHideNotification:(NSNotification *)notification;
- (void)handlePanGesture:(UIPanGestureRecognizer *)pan;
@end

@implementation DismissiveTextView
#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        self.editable = YES;
        self.backgroundColor=[UIColor clearColor];
        self.inputAccessoryView = [[UIView alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleKeyboardWillShowHideNotification:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleKeyboardWillShowHideNotification:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleKeyboardWillShowHideNotification:)
                                                     name:UIKeyboardDidHideNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_dismissivePanGestureRecognizer removeTarget:self action:@selector(handlePanGesture:)];
    _dismissivePanGestureRecognizer = nil;
    _keyboardDelegate = nil;
    _keyboardView = nil;
}
#pragma mark - Setters

- (void)setDismissivePanGestureRecognizer:(UIPanGestureRecognizer *)pan
{
    _dismissivePanGestureRecognizer = pan;
    [_dismissivePanGestureRecognizer addTarget:self action:@selector(handlePanGesture:)];
}


#pragma mark - Notifications

- (void)handleKeyboardWillShowHideNotification:(NSNotification *)notification
{
    if([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        self.keyboardView.hidden = NO;
    }
    else if([notification.name isEqualToString:UIKeyboardDidShowNotification]) {
        self.keyboardView = self.inputAccessoryView.superview;
        self.keyboardView.hidden = NO;
        
        if(self.keyboardDelegate && [self.keyboardDelegate respondsToSelector:@selector(keyboardDidShow)])
            [self.keyboardDelegate keyboardDidShow];
    }
    else if([notification.name isEqualToString:UIKeyboardDidHideNotification]) {
        self.keyboardView.hidden = NO;
        [self resignFirstResponder];
    }
}

#pragma mark - Gestures

- (void)handlePanGesture:(UIPanGestureRecognizer *)pan
{
    if(!self.keyboardView || self.keyboardView.hidden)
        return;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    UIWindow *panWindow = [[UIApplication sharedApplication] keyWindow];
    CGPoint location = [pan locationInView:panWindow];
    CGPoint velocity = [pan velocityInView:panWindow];
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            self.previousKeyboardY = self.keyboardView.frame.origin.y;
            break;
        case UIGestureRecognizerStateEnded:
            if(velocity.y > 0 && self.keyboardView.frame.origin.y > self.previousKeyboardY) {
                
                [UIView animateWithDuration:0.3
                                      delay:0
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     self.keyboardView.frame = CGRectMake(0.0f,
                                                                          screenHeight,
                                                                          self.keyboardView.frame.size.width,
                                                                          self.keyboardView.frame.size.height);
                                     
                                     if(self.keyboardDelegate && [self.keyboardDelegate respondsToSelector:@selector(keyboardWillBeDismissed)])
                                         [self.keyboardDelegate keyboardWillBeDismissed];
                                 }
                                 completion:^(BOOL finished) {
                                     self.keyboardView.hidden = YES;
                                     self.keyboardView.frame = CGRectMake(0.0f,
                                                                          self.previousKeyboardY,
                                                                          self.keyboardView.frame.size.width,
                                                                          self.keyboardView.frame.size.height);
                                     [self resignFirstResponder];
                                 }];
            }
            else { // gesture ended with no flick or a flick upwards, snap keyboard back to original position
                [UIView animateWithDuration:0.2
                                      delay:0
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     if(self.keyboardDelegate && [self.keyboardDelegate respondsToSelector:@selector(keyboardWillSnapBackToPoint:)]) {
                                         [self.keyboardDelegate keyboardWillSnapBackToPoint:CGPointMake(0.0f, self.previousKeyboardY)];
                                     }
                                     
                                     self.keyboardView.frame = CGRectMake(0.0f,
                                                                          self.previousKeyboardY,
                                                                          self.keyboardView.frame.size.width,
                                                                          self.keyboardView.frame.size.height);
                                 }
                                 completion:^(BOOL finished){
                                 }];
            }
            break;
            
            // gesture is currently panning, match keyboard y to touch y
        default:
            if(location.y > self.keyboardView.frame.origin.y || self.keyboardView.frame.origin.y != self.previousKeyboardY) {
                
                CGFloat newKeyboardY = self.previousKeyboardY + (location.y - self.previousKeyboardY);
                newKeyboardY = newKeyboardY < self.previousKeyboardY ? self.previousKeyboardY : newKeyboardY;
                newKeyboardY = newKeyboardY > screenHeight ? screenHeight : newKeyboardY;
                
                self.keyboardView.frame = CGRectMake(0.0f,
                                                     newKeyboardY,
                                                     self.keyboardView.frame.size.width,
                                                     self.keyboardView.frame.size.height);
                
                if(self.keyboardDelegate && [self.keyboardDelegate respondsToSelector:@selector(keyboardDidScrollToPoint:)])
                    [self.keyboardDelegate keyboardDidScrollToPoint:CGPointMake(0.0f, newKeyboardY)];
            }
            break;
    }
}

@end
