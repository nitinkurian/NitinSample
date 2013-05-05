//
//  FlipsideViewController.m
//  NitinSample
//
//  Created by NITIN JOHN on 5/4/13.
//  Copyright (c) 2013 NITIN JOHN. All rights reserved.
//

#import "NJMediaViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "NJImageFileReadWrite.h"
#import "NJMedia.h"
#import "NJImageView.h"
#import "AppDelegate.h"

@interface NJMediaViewController ()

@property (nonatomic, strong) UIImagePickerController *importPictureController;
@property (nonatomic, strong) NJThumbnailCollectionViewController *thumbnailController;
@property (nonatomic, strong) UIViewController *imageController;

@end

@implementation NJMediaViewController

@synthesize importPictureController = importPictureController;


- (UIImagePickerController *)importPictureController
{
    if (!importPictureController) {
        importPictureController = [[UIImagePickerController alloc] init];
        importPictureController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        importPictureController.delegate = self;
    }
    
    return importPictureController;
}

#pragma mark - View Lifecycle

- (void)awakeFromNib
{
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 480.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Save the child view controllers as  properties
    for (UIViewController *controller in self.childViewControllers) {
        if ([controller isMemberOfClass:[NJThumbnailCollectionViewController class]]) {
            self.thumbnailController = (NJThumbnailCollectionViewController *)controller;
            self.thumbnailController.delegate = self;
        }
        else if ([controller isMemberOfClass:[UIViewController class]]) {
            self.imageController = controller;
        }
    } 

    //Assign the media to the thumbnail controller
    self.thumbnailController.medias = self.curUser.medias.allObjects;
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated

{
    [super viewWillAppear:animated];
    
    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark Actions

- (IBAction)done:(id)sender
{
    self.curUser = nil;
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (IBAction)importMedia:(id)sender
{
    self.importPictureController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    // Displays saved pictures , if both are available, from the
    // Camera Roll album.
    self.importPictureController.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    self.importPictureController.allowsEditing = NO;
    
    
    [self presentViewController:self.importPictureController animated:YES completion:^{
        
    }];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

/**
 * Once the image is selected to save
 * - We save the image file in the original size as a jpg as well as a thumbnail to the documents direectory
 * - Save the key to the persistent store
 * - Load the thumbnail
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    void (^completionBlock)(void) = ^{
        [NJImageFileReadWrite.singleton saveImage:image WithCompletionBlock:^(NSString *key, BOOL fileExists){
            
            if (!fileExists) {
                NJMedia *imageMedia = (NJMedia *)[NSEntityDescription insertNewObjectForEntityForName:@"NJMedia" inManagedObjectContext:self.thisManagedObjectContext];
                imageMedia.mediaHash = key;
                imageMedia.user = self.curUser;
                
                [self.curUser addMediasObject:imageMedia];
                NSError *saveError = nil;
                [self.thisManagedObjectContext save:&saveError];
                
                [NJImageFileReadWrite.singleton loadThumbForKey:key
                                            WithCompletionBlock:^(UIImage *image) {
                                                self.thumbnailController.medias = self.curUser.medias.allObjects;
                                                [self.thumbnailController addImage:image];
                                                [self.thumbnailController.collectionView reloadData];
                                            }];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                                message:@"Image Exist!!!"
                                                               delegate:self
                                                      cancelButtonTitle:@"Dismiss"
                                                      otherButtonTitles:nil, nil];
                
                [alert show];
            }
            
            
            
            
        }];
    };
    [self dismissViewControllerAnimated:YES completion:completionBlock];
    
}

#pragma mark -
#pragma mark NJThumbnailCollectionViewControllerDelegate

/**
 * We do not want the child controller to handle displaying of the main image
 * So we get this delegate call to tell the parent controller that a image has been picked.
 * Dispay the picked image into the single image display view
 */
- (void)collectionView:(UICollectionView *)view selectedImageWithKey:(NSString *)key
{    
    [NJImageFileReadWrite.singleton loadImageForKey:key WithCompletionBlock:^(UIImage *image) {
         NJImageView *view = (NJImageView *)self.imageController.view;
        view.imageView.image = image;
    }];
}

@end
