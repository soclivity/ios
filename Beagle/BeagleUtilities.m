//
//  BeagleUtilities.m
//  Beagle
//
//  Created by Kanav Gupta on 04/03/14.
//  Copyright (c) 2014 soclivity. All rights reserved.
//

#import "BeagleUtilities.h"

@implementation BeagleUtilities
+ (int) getRandomIntBetweenLow:(int) low andHigh:(int) high {
	return ((arc4random() % (high - low + 1)) + low);
}
// Function to auto-crop the image if user does not
+(UIImage*) autoCrop:(UIImage*)image{
    
    CGSize dimensions = {0,0};
    float x=0.0,y=0.0;
    
    // Check to see if the image layout is landscape or portrait
    if(image.size.width > image.size.height)
    {
        // if landscape
        x = (image.size.width - image.size.height)/2;
        dimensions.width = image.size.height;
        dimensions.height = image.size.height;
        
    }
    else
    {
        // if portrait
        y = (image.size.height - image.size.width)/2;
        dimensions.height = image.size.width;
        dimensions.width = image.size.width;
        
    }
    
    // Create the mask
    CGRect imageRect = CGRectMake(x,y,dimensions.width,dimensions.height);
    
    // Create the image based on the mask created above
    CGImageRef  imageRef = CGImageCreateWithImageInRect([image CGImage], imageRect);
    image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
	return image;
}

// Function to compress a large image
+(UIImage*) compressImage:(UIImage *)image size:(CGSize)size{
    
    UIGraphicsBeginImageContext(size);
    CGRect imageRect = CGRectMake(0.0, 0.0, size.width, size.height);
    [image drawInRect:imageRect];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage*) getSubImageFrom: (UIImage*) img rect: (CGRect) rect {
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // translated rectangle for drawing sub image
    CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, img.size.width, img.size.height);
    
    // clip to the bounds of the image context
    // not strictly necessary as it will get clipped anyway?
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
    
    // draw image
    [img drawInRect:drawRect];
    
    // grab image
    UIImage* subImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return subImage;
}
+ (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)aperture withOrientation:(UIImageOrientation)orientation {
    
    // convert y coordinate to origin bottom-left
    CGFloat orgY = aperture.origin.y + aperture.size.height - imageToCrop.size.height,
    orgX = -aperture.origin.x,
    scaleX = 1.0,
    scaleY = 1.0,
    rot = 0.0;
    CGSize size;
    
    switch (orientation) {
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            size = CGSizeMake(aperture.size.height, aperture.size.width);
            break;
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            size = aperture.size;
            break;
        default:
            assert(NO);
            return nil;
    }
    
    
    switch (orientation) {
        case UIImageOrientationRight:
            rot = 1.0 * M_PI / 2.0;
            orgY -= aperture.size.height;
            break;
        case UIImageOrientationRightMirrored:
            rot = 1.0 * M_PI / 2.0;
            scaleY = -1.0;
            break;
        case UIImageOrientationDown:
            scaleX = scaleY = -1.0;
            orgX -= aperture.size.width;
            orgY -= aperture.size.height;
            break;
        case UIImageOrientationDownMirrored:
            orgY -= aperture.size.height;
            scaleY = -1.0;
            break;
        case UIImageOrientationLeft:
            rot = 3.0 * M_PI / 2.0;
            orgX -= aperture.size.height;
            break;
        case UIImageOrientationLeftMirrored:
            rot = 3.0 * M_PI / 2.0;
            orgY -= aperture.size.height;
            orgX -= aperture.size.width;
            scaleY = -1.0;
            break;
        case UIImageOrientationUp:
            break;
        case UIImageOrientationUpMirrored:
            orgX -= aperture.size.width;
            scaleX = -1.0;
            break;
    }
    
    // set the draw rect to pan the image to the right spot
    CGRect drawRect = CGRectMake(orgX, orgY, imageToCrop.size.width, imageToCrop.size.height);
    
    // create a context for the new image
    UIGraphicsBeginImageContextWithOptions(size, NO, imageToCrop.scale);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    // apply rotation and scaling
    CGContextRotateCTM(gc, rot);
    CGContextScaleCTM(gc, scaleX, scaleY);
    
    // draw the image to our clipped context using the offset rect
    CGContextDrawImage(gc, drawRect, imageToCrop.CGImage);
    
    // pull the image from our cropped context
    UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();
    
    // pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    // Note: this is autoreleased
    return cropped;
}

+ (UIImage*)circularScaleNCrop:(UIImage*)image rect:(CGRect) rect{
    // This function returns a newImage, based on image, that has been:
    // - scaled to fit in (CGRect) rect
    // - and cropped within a circle of radius: rectWidth/2
    
    //Create the bitmap graphics context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(rect.size.width, rect.size.height), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Get the width and heights
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat rectWidth = rect.size.width;
    CGFloat rectHeight = rect.size.height;
    
    //Calculate the scale factor
    CGFloat scaleFactorX = rectWidth/imageWidth;
    CGFloat scaleFactorY = rectHeight/imageHeight;
    
    //Calculate the centre of the circle
    CGFloat imageCentreX = rectWidth/2;
    CGFloat imageCentreY = rectHeight/2;
    
    // Create and CLIP to a CIRCULAR Path
    // (This could be replaced with any closed path if you want a different shaped clip)
    CGFloat radius = rectWidth/2;
    CGContextBeginPath (context);
    CGContextAddArc (context, imageCentreX, imageCentreY, radius, 0, 2*M_PI, 0);
    CGContextClosePath (context);
    CGContextClip (context);
    
    //Set the SCALE factor for the graphics context
    //All future draw calls will be scaled by this factor
    CGContextScaleCTM (context, scaleFactorX, scaleFactorY);
    
    // Draw the IMAGE
    CGRect myRect = CGRectMake(0, 0, imageWidth, imageHeight);
    [image drawInRect:myRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
+(NSString*)activityTime:(NSString*)startDate endate:(NSString*)endDate{
    
    NSCalendar *gregorian = [[NSCalendar alloc]        initWithCalendarIdentifier:NSGregorianCalendar];

    NSDateComponents *components = [gregorian components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];

    
    
    [components setHour:00];
    [components setMinute:00];
    [components setSecond:01];
    NSDate *startOfDay=[gregorian dateFromComponents:components];
    NSLog(@"startOfDay=%@",startOfDay);
    
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    
    NSDate *endOfDay=[gregorian dateFromComponents:components];
    NSLog(@"endOfDay=%@",endOfDay);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    NSDate *startActivityDate = [dateFormatter dateFromString:startDate];
    NSDate *endActivityDate = [dateFormatter dateFromString:endDate];
    NSArray *array = [NSArray arrayWithObjects:startActivityDate,[NSDate date],endActivityDate, nil];
    
    array = [array sortedArrayUsingComparator: ^(NSDate *s1, NSDate *s2){
        
        return [s1 compare:s2];
    }];
    
    NSUInteger indexOfDay1 = [array indexOfObject:startActivityDate];
    NSUInteger indexOfDay2 = [array indexOfObject:[NSDate date]];
    NSUInteger indexOfDay3 = [array indexOfObject:endActivityDate];
    
    if (((indexOfDay1 <= indexOfDay2 ) && (indexOfDay2 < indexOfDay3)) ||
        ((indexOfDay1 >= indexOfDay2 ) && (indexOfDay2 > indexOfDay3))) {
        NSLog(@"YES");
        NSDateComponents *nowComponents = [gregorian components:NSYearCalendarUnit | NSWeekCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
        
        [nowComponents setWeekday:7];
        
        [nowComponents setHour:0];
        [nowComponents setMinute:0];
        [nowComponents setSecond:01];
        
        NSDate *satMorning=[gregorian dateFromComponents:nowComponents];
        
        [nowComponents setWeekday:0];
        
        [nowComponents setHour:23];
        [nowComponents setMinute:59];
        [nowComponents setSecond:59];
        
        NSDate *sundayEvening=[gregorian dateFromComponents:nowComponents];

        if([[NSDate date] timeIntervalSinceDate:startActivityDate]<0 && (0<[endActivityDate timeIntervalSinceDate:[NSDate date]]<24))
                 return @"Later Today";
        else if([[NSDate date] timeIntervalSinceDate:startActivityDate]>0 && (0<[endActivityDate timeIntervalSinceDate:[NSDate date]]<48))
            return @"Tomorrow";
        else if(48<[endActivityDate timeIntervalSinceDate:[NSDate date]]<120)
            return @"This week";
            
        else if(0<=[startActivityDate timeIntervalSinceDate:satMorning]<1 && 0<=[endActivityDate timeIntervalSinceDate:sundayEvening]<1){
                return @"This weekend";
            }

        }
     else {
        NSLog(@"NO");
    }
    
    
    

    return nil;
}
@end