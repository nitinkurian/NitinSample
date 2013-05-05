//
//  FlipsideViewController.h
//  NitinSample
//
//  Created by NITIN JOHN on 5/4/13.
//  Copyright (c) 2013 NITIN JOHN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJUser.h"
#import "NJThumbnailCollectionViewController.h"

@class NJMediaViewController;

@protocol FlipsideViewControllerDelegate

- (void)flipsideViewControllerDidFinish:(NJMediaViewController *)controller;

@end

@interface NJMediaViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, NJThumbnailCollectionViewControllerDelegate>

@property (strong, nonatomic) NJUser *curUser;
@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;
@property (strong, nonatomic) NSManagedObjectContext *thisManagedObjectContext;

- (IBAction)done:(id)sender;
- (IBAction)importMedia:(id)sender;

@end
