//
//  MainViewController.h
//  NitinSample
//
//  Created by NITIN JOHN on 5/4/13.
//  Copyright (c) 2013 NITIN JOHN. All rights reserved.
//

#import "NJMediaViewController.h"

@interface NJLoginController : UIViewController <FlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end
