//
//  NJImageFileReadWrite.h
//  NitinSample
//
//  Created by NITIN JOHN on 5/4/13.
//  Copyright (c) 2013 NITIN JOHN. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompletionBlock)(id object, BOOL fileExists);
typedef void (^LoadCompletionBlock)(UIImage *image);
typedef void (^BackgroundBlock)(NSValue *weakOpValue);

@interface NJImageFileReadWrite : NSObject

+ (NJImageFileReadWrite *)singleton;

- (void) executeBlock:(void (^)())block;

- (void)saveImage:(UIImage *)image WithCompletionBlock:(CompletionBlock)completionBlock;
- (void)loadImageForKey:(NSString *)key WithCompletionBlock:(LoadCompletionBlock)completionBlock;
- (void)loadThumbForKey:(NSString *)key WithCompletionBlock:(LoadCompletionBlock)completionBlock;

@end
