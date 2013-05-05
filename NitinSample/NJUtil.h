//
//  NJUtil.h
//  NitinSample
//
//  Created by NITIN JOHN on 5/4/13.
//  Copyright (c) 2013 NITIN JOHN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NJUtil : NSObject

+(NSString*) sha1:(NSString*)input;
+(NSString*) sha1OfFile:(NSString *)path;

@end
