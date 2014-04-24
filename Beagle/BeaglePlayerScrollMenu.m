//
//  BeaglePlayerScrollMenu.m
//  Beagle
//
//  Created by Kanav Gupta on 19/04/14.
//  Copyright (c) 2014 soclivity. All rights reserved.
//

#import "BeaglePlayerScrollMenu.h"
#import <QuartzCore/QuartzCore.h>
@implementation BeaglePlayerScrollMenu



# pragma mark -
# pragma mark Initialization
# pragma mark -


- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
	}
	return self;
}

- (id)initPlayerScrollMenuWithFrame:(CGRect)frame menuItems:(NSArray *)menuItems {
	self = [super initWithFrame:frame];
	if (!self) {
		return nil;
	}

	if (menuItems.count == 0) {
		return nil;
	}
    
	[self setUpPlayerScrollMenu:menuItems];
    
	return self;
}

- (void)setUpPlayerScrollMenu:(NSArray *)menuItems {
	if (menuItems.count == 0) {
		return;
	}
    playerItemsDictionary = [[NSMutableDictionary alloc] init];

    
	NSInteger menuItemsArrayCount = menuItems.count;
    
	// Setting ScrollView
	_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	PlayerProfileItem *menuItem = menuItems[0];
	_scrollView.contentSize = CGSizeMake(menuItem.frame.size.width * menuItemsArrayCount, self.frame.size.height);
    
	// Do not show scrollIndicator
	_scrollView.showsHorizontalScrollIndicator = NO;
	_scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate=self;
	_scrollView.backgroundColor = [UIColor clearColor];
	[_scrollView setUserInteractionEnabled:YES];
	[self addSubview:_scrollView];
    
	self.menuArray = menuItems;
	[self setMenu];
    
    
	_animationType = PlayerZoomOut;
}

- (void)setMenu {
	int i = 0;
	for (PlayerProfileItem *menuItem in _menuArray) {
        
        if([playerItemsDictionary valueForKey:[NSString stringWithFormat:@"%li",(long)menuItem.playerId]])
        {
            menuItem.iconImage.image = [playerItemsDictionary valueForKey:[NSString stringWithFormat:@"%li",(long)menuItem.playerId]];
        }
        else
        {
             menuItem.iconImage.image  = [BeagleUtilities imageCircularBySize:[UIImage imageNamed:@"picbox"] sqr:35.0f];

            if(!isDragging && !isDecelerating && !menuItem.isInitialized)
            {
                
                NSLog(@"in test");
                NSOperationQueue *queue = [NSOperationQueue new];
                NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                                    initWithTarget:self
                                                    selector:@selector(downloadProfileImage:)
                                                    object:menuItem];
                [queue addOperation:operation];
                 menuItem.isInitialized=YES;

            }
        }

		menuItem.tag = 1000 + i;
//		menuItem.center = CGPointMake((menuItem.frame.size.width * i)/2, self.frame.size.height / 2);
        menuItem.frame=CGRectMake(67*i, 0, 67, 55);
            
		menuItem.delegate = self;
		[_scrollView addSubview:menuItem];
        
		i++;
	}
}

# pragma mark -
# pragma mark Delegate Methods
# pragma mark -

- (void)itemTouchesBegan:(PlayerProfileItem *)item {
}

- (void)itemTouchesEnd:(PlayerProfileItem *)item {
    
	[self startAnimation:item];
    
    if(item.block) {
        item.block(item);
    }
	if ([_delegate respondsToSelector:@selector(scrollMenu:didSelectIndex:)]) {
		[_delegate scrollMenu:(id)self didSelectIndex:item.tag - 1000];
	}
}

# pragma mark -
# pragma mark Animation & behaviour
# pragma mark -

- (void)startAnimation:(PlayerProfileItem *)item {
    
	switch (_animationType) {
		case PlayerFadeZoomIn: {
			[UIView animateWithDuration:0.25f animations: ^{
			    CGAffineTransform scaleUpAnimation = CGAffineTransformMakeScale(1.9f, 1.9f);
			    item.transform = scaleUpAnimation;
			    item.alpha = 0.2;
			} completion: ^(BOOL finished) {
			    [UIView animateWithDuration:0.25f animations: ^{
			        item.transform = CGAffineTransformIdentity;
			        item.alpha = 1.0f;
				} completion: ^(BOOL finished) {
				}];
			}];
			break;
		}
            
		case PlayerFadeZoomOut: {
			[UIView animateWithDuration:0.1f animations: ^{
			    CGAffineTransform scaleDownAnimation = CGAffineTransformMakeScale(0.9f, 0.9f);
			    item.transform = scaleDownAnimation;
			    item.alpha = 0.2;
			} completion: ^(BOOL finished) {
			    [UIView animateWithDuration:0.1f animations: ^{
			        item.transform = CGAffineTransformIdentity;
			        item.alpha = 1.0f;
				} completion: ^(BOOL finished) {
				}];
			}];
			break;
		}
            
		case PlayerZoomOut: {
			[UIView animateWithDuration:0.1f animations: ^{
			    CGAffineTransform scaleDownAnimation = CGAffineTransformMakeScale(0.9f, 0.9f);
			    item.transform = scaleDownAnimation;
			} completion: ^(BOOL finished) {
			    [UIView animateWithDuration:0.1f animations: ^{
			        item.transform = CGAffineTransformIdentity;
				} completion: ^(BOOL finished) {
				}];
			}];
			break;
		}
            
		default: {
			[UIView animateWithDuration:0.25f animations: ^{
			    CGAffineTransform scaleUpAnimation = CGAffineTransformMakeScale(1.9f, 1.9f);
			    item.transform = scaleUpAnimation;
			    item.alpha = 0.2;
			} completion: ^(BOOL finished) {
			    [UIView animateWithDuration:0.25f animations: ^{
			        item.transform = CGAffineTransformIdentity;
			        item.alpha = 1.0f;
				} completion: ^(BOOL finished) {
				}];
			}];
			break;
		}
	}
}



# pragma mark -
# pragma mark Extra configuration
# pragma mark -

-(void)downloadProfileImage:(PlayerProfileItem *)itemPath
{
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:itemPath.profileImageUrl]]];
    image=[BeagleUtilities imageCircularBySize:image sqr:35.0f];
    
    if(image)
    {
        [playerItemsDictionary setObject:image forKey:[NSString stringWithFormat:@"%li",(long)itemPath.playerId]];
    }
    [self performSelectorOnMainThread:@selector(setMenu) withObject:nil waitUntilDone:NO];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    isDragging = FALSE;
    [self setMenu];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    isDecelerating = FALSE;
    [self setMenu];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    isDragging = TRUE;
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    isDecelerating = TRUE;
}
@end
