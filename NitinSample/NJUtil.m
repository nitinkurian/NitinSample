//
//  NJUtil.m
//  NitinSample
//
//  Created by NITIN JOHN on 5/4/13.
//  Copyright (c) 2013 NITIN JOHN. All rights reserved.
//

#import "NJUtil.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NJUtil

/*
 * Using Apple's CommonCrypto's CommonDigest libray to generate the SHA1
 * This method is used here for generating SHA1 of the login password
 * which is sent over the wire
 */
+(NSString*) sha1:(NSString*)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}

/*
 * Using Apple's CommonCrypto's CommonDigest libray to generate the SHA1
 * This method is used here for generating SHA1 of the image files we are generating
 */
+(NSString*) sha1OfFile:(NSString *)path
{
    // TODO: Don;t read the entire file into memory
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}
@end
