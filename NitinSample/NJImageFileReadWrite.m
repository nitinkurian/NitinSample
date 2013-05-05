//
//  NJImageFileReadWrite.m
//  NitinSample
//
//  Created by NITIN JOHN on 5/4/13.
//  Copyright (c) 2013 NITIN JOHN. All rights reserved.
//

#import "NJImageFileReadWrite.h"
#import "UIImage+Resize.h"
#include <CommonCrypto/CommonDigest.h>
#import "AppDelegate.h"

#define THUMB_SIZE 40


// There are no class level properties in objective-C so we have to use a plain old
// C global variable. Make it static so only this file can see it.
static NJImageFileReadWrite *singleton = nil;

@implementation NJImageFileReadWrite

/**
 * Get the shared instance, creating it if necessary. Note this is not thread safe.
 */
+ (NJImageFileReadWrite *)singleton {
    if (singleton == nil) {
        singleton = [[self alloc] init];
    }
    return singleton;
}

- (void) executeBlock:(void (^)())block
{
    block();
}


- (NSString *)imagePath:(NSString *)key
{
    NSURL *documentDirectoryUrl = [(AppDelegate *)([UIApplication sharedApplication].delegate) applicationDocumentsDirectory];
    return [NSString stringWithFormat:@"%@/%@.jpg",documentDirectoryUrl.path,key];
}

- (NSString *)thumbPath:(NSString *)key
{
    NSURL *documentDirectoryUrl = [(AppDelegate *)([UIApplication sharedApplication].delegate) applicationDocumentsDirectory];
    return [NSString stringWithFormat:@"%@/%@.thumb.jpg",documentDirectoryUrl.path,key];
}

/**
 * Save an image captured from camera roll
 * Note that there are two versions of the images being saved
 * - original image
 * - thumbnail image
 * They are saved using the sha1 as the file name. Thumbnail as an additional '.thumb' in their name
 * If the file already exists we dont save it
 */
- (void)saveImage:(UIImage *)image WithCompletionBlock:(CompletionBlock)completionBlock
{    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        BOOL fileExists = NO;
        NSMutableString* key = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
        
        // Make an auto release pool to free up any memory used in generating the jpg
        // as well as the NSData itself before making the thumbnail
        @autoreleasepool
        {
            // Convert the image to a jpg and get the bytes
            NSData *jpgData = UIImageJPEGRepresentation(image,0.8);
            unsigned char digest[CC_SHA1_DIGEST_LENGTH];
            
            // generate a digest for it for use as a unique id
            CC_SHA1([jpgData bytes], [jpgData length], digest);
            
            // Convert the digest to a string
            for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
                [key appendFormat:@"%02x", digest[i]];
            
            
            // Build a property specific path to make it easier to identify all images
            // asociated with a property at once without search the DB for them
            NSString  *jpgPath = [self imagePath:key];
            
            //We do not need to save the image if the file exists
            if ([[NSFileManager defaultManager] fileExistsAtPath:jpgPath]) {
                fileExists = YES;
            }
            else {
                // Save the full size image
                [jpgData writeToFile:jpgPath atomically:YES];
            }
        }
        
        
        // Autorelease the thumb nail resources
        @autoreleasepool
        {
            // generate a thumbnail image using medium interpolation quality. We size
            // the thumb so th elargest dimension equals maxSide
            int width = THUMB_SIZE;
            int height = THUMB_SIZE;
            if ( image.size.width > image.size.height )
                height = image.size.height * THUMB_SIZE / image.size.width;
            else
                width = image.size.width * THUMB_SIZE / image.size.height;
            
            UIImage *thumb = [image resizedImage:CGSizeMake(width, height) interpolationQuality:kCGInterpolationMedium];
            
            // Convert it to jpg
            NSData *thumbData = UIImageJPEGRepresentation(thumb,0.8);
            
            // Build a property specific path to make it easier to identify all images
            // asociated with a property at once without search the DB for them
            if (!fileExists) {
                NSString  *jpgPath = [self thumbPath:key];
                
                // Save the full size image
                [thumbData writeToFile:jpgPath atomically:YES];
            }
            
        }
        
        void (^noArgBlock)(void) = ^{
            completionBlock(key,fileExists);
        };
        [self performSelectorOnMainThread:@selector(executeBlock:)
                               withObject:[noArgBlock copy]
                            waitUntilDone:NO];
    }];
    
    [((AppDelegate *)(UIApplication.sharedApplication.delegate)).backgroundQueue addOperation:operation];
    
    
}

/**
 * Load an image in the original format using the key specified.
 * Note that all images are saved using their sha1 as file name
 */
- (void)loadImageForKey:(NSString *)key WithCompletionBlock:(LoadCompletionBlock)completionBlock
{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSString  *jpgPath = [self imagePath:key];
        UIImage *image = [UIImage imageWithContentsOfFile:jpgPath];
        
        void (^noArgBlock)(void) = ^{
            completionBlock(image);
        };
        [self performSelectorOnMainThread:@selector(executeBlock:)
                               withObject:[noArgBlock copy]
                            waitUntilDone:NO];
    }];
    
    [((AppDelegate *)(UIApplication.sharedApplication.delegate)).backgroundQueue addOperation:operation];
}

/**
 * Load a thumbnail image in the original format using the key specified.
 * Note that all images are saved using their sha1 as file name
 */
- (void)loadThumbForKey:(NSString *)key WithCompletionBlock:(LoadCompletionBlock)completionBlock
{    
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        
        UIImage *thumbImage;
        NSString  *jpgPath = [self thumbPath:key];
        NSFileManager *fm = [NSFileManager defaultManager];
        //If the file doesnt exists create a thumb nail
        if (![fm fileExistsAtPath:jpgPath]) {
            NSString  *imagePath = [self imagePath:key];
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            
            // Autorelease the thumb nail resources
            @autoreleasepool
            {
                // generate a thumbnail image using medium interpolation quality. We size
                // the thumb so th elargest dimension equals maxSide
                int maxSide = THUMB_SIZE;
                int width = THUMB_SIZE;
                int height = THUMB_SIZE;
                if ( image.size.width > image.size.height )
                    height = image.size.height * maxSide / image.size.width;
                else
                    width = image.size.width * maxSide / image.size.height;
                UIImage *thumb = [image thumbnailImage:THUMB_SIZE transparentBorder:2.0 cornerRadius:5.0 interpolationQuality:kCGInterpolationMedium];
                // Convert it to jpg
                NSData *thumbData = UIImageJPEGRepresentation(thumb,0.8);
                
                // Build a property specific path to make it easier to identify all images
                // asociated with a property at once without search the DB for them
                NSString  *jpgPath = [self thumbPath:key];
                
                // Save the full size image
                [thumbData writeToFile:jpgPath atomically:YES];
            }
             thumbImage = [UIImage imageWithContentsOfFile:jpgPath];            
        }
        else {
            thumbImage = [UIImage imageWithContentsOfFile:jpgPath];
        }
        
        void (^noArgBlock)(void) = ^{
            completionBlock(thumbImage);
        };
        [self performSelectorOnMainThread:@selector(executeBlock:)
                               withObject:[noArgBlock copy]
                            waitUntilDone:NO];
    }];
    
    [((AppDelegate *)(UIApplication.sharedApplication.delegate)).backgroundQueue addOperation:operation];
    
}

@end
