//
//  NJMedia.h
//  NitinSample
//
//  Created by NITIN JOHN on 5/4/13.
//  Copyright (c) 2013 NITIN JOHN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NJUser;

@interface NJMedia : NSManagedObject

@property (nonatomic, retain) NSString * mediaHash;
@property (nonatomic, retain) NSString * mediaPath;
@property (nonatomic, retain) NJUser *user;

@end
