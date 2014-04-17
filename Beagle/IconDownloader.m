
//
//  IconDownloader.m
//  Beagle
//
//  Created by Kanav Gupta on 25/03/14.
//  Copyright (c) 2014 soclivity. All rights reserved.
//
#import "IconDownloader.h"
#import "BeagleActivityClass.h"
#define kIconHeight 56
#define kIconWidth 56

@implementation IconDownloader

@synthesize appRecord;
@synthesize indexPathInTableView;
@synthesize delegate;
@synthesize activeDownload;
@synthesize imageConnection;
@synthesize tagkey;
#pragma mark


- (void)startDownload:(NSInteger)uniqueKey
{
    self.activeDownload = [NSMutableData data];
    tagkey=uniqueKey;
    
    switch (tagkey){
        case kParticipantInActivity:
        {
            if(appRecord.photoUrl != nil)
            {
                
                NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                                         [NSURLRequest requestWithURL:
                                          [NSURL URLWithString:appRecord.photoUrl]] delegate:self];
                self.imageConnection = conn;
            }
            
        }
            break;
            


    }
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}


#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    
    if(image.size.height != image.size.width)
        image = [BeagleUtilities autoCrop:image];
    
    // If the image needs to be compressed
    if(image.size.height > kIconHeight || image.size.width > kIconHeight)
        image = [BeagleUtilities compressImage:image size:CGSizeMake(kIconHeight,kIconHeight)];

       switch (tagkey) {
            case kParticipantInActivity:
            {
                self.appRecord.profilePhotoImage = image;
                
            }
                break;
                
        }

     self.activeDownload = nil;

    
    // Release the connection now that it's finished
    self.imageConnection = nil;
        
    // call our delegate and tell it that our icon is ready for display
        [delegate appImageDidLoad:self.indexPathInTableView];
}

@end
