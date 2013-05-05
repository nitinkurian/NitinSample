//
//  MainViewController.m
//  NitinSample
//
//  Created by NITIN JOHN on 5/4/13.
//  Copyright (c) 2013 NITIN JOHN. All rights reserved.
//

#import "NJLoginController.h"
#import <QuartzCore/QuartzCore.h>
#import "NJUser.h"
#import "NJUtil.h"

@interface NJLoginController ()

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NJUser *curUser;

@end

@implementation NJLoginController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"NJUser" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (array != nil) {
        NSUInteger count = [array count];
        
        if (count == 0) {
            NJUser *user = [NSEntityDescription insertNewObjectForEntityForName:@"NJUser"
                                                         inManagedObjectContext:self.managedObjectContext];
            
            user.email = @"demo";
            user.password = [NJUtil sha1:@"demo"];
            
            
            NSError *saveError = nil;
            [self.managedObjectContext save:&saveError];
            
            NSArray *myarray = [NSArray arrayWithObject:user];
            array = myarray;
        }
        
        self.users = array;
    }
    else {
        // Deal with error.
        NSLog(@"Alert: Something happened while fetching data. The reason is probably: %@", error.localizedDescription);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //Using gradient layer due to lack of image graphics
    CAGradientLayer *gradientContainer = [CAGradientLayer layer];
    gradientContainer.frame = self.containerView.bounds;
    gradientContainer.colors = [NSArray arrayWithObjects:
                                (id)[[UIColor colorWithRed:.402
                                                     green:.421
                                                      blue:.478
                                                     alpha:1] CGColor],
                                
                                (id)[[UIColor colorWithRed:.02
                                                     green:.02
                                                      blue:.03
                                                     alpha:1] CGColor],
                                nil];
    [self.containerView.layer insertSublayer:gradientContainer atIndex:0];
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(NJMediaViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        NJMediaViewController *destController = [segue destinationViewController];
        [destController setDelegate:self];
        destController.curUser = self.curUser;
        destController.thisManagedObjectContext = self.managedObjectContext;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
}

- (IBAction)togglePopover:(id)sender
{
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}

- (IBAction)loginClicked:(id)sender
{
    NSString *password = @"";
    self.curUser = nil;
    if (self.users && self.users.count>0) {
        
        password = [NJUtil sha1:self.password.text];

        
        for (NJUser *user in self.users) {
            BOOL isEmailOk = [user.email isEqualToString:self.email.text];
            BOOL isPasswordOk = [user.password isEqualToString:password];
            if (isEmailOk && isPasswordOk) {
                self.curUser = user;
                break;
            }
        }
        
        if (self.curUser) {
            [self performSegueWithIdentifier:@"showAlternate" sender:self];
        }
    }
    
}

@end
