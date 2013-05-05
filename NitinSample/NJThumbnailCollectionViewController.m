//
//  NJThumbnailCollectionViewController.m
//  NitinSample
//
//  Created by NITIN JOHN on 5/4/13.
//  Copyright (c) 2013 NITIN JOHN. All rights reserved.
//

#import "NJThumbnailCollectionViewController.h"
#import "AppDelegate.h"
#import "NJThumbnailCell.h"
#import "NJImageFileReadWrite.h"
#import "NJMedia.h"

@interface NJThumbnailCollectionViewController ()

@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation NJThumbnailCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.images = [[NSMutableArray alloc] init];
    
   
	// Do any additional setup after loading the view.
}

//Doing this so that everytime media is set we can load all the images
- (void)setMedias:(NSArray *)medias
{
    _medias = medias;
    for (NJMedia *media in self.medias) {
        [NJImageFileReadWrite.singleton loadThumbForKey:media.mediaHash
                                    WithCompletionBlock:^(UIImage *image) {
                                        
                                        [self.images addObject:image];
                                        if (self.images.count == self.medias.count) {
                                            [self.collectionView reloadData];
                                        }
                                    }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addImage:(UIImage *)image
{
    [self.images addObject:image];
}

#pragma mark -
#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Thumbnail";
        
    NJThumbnailCell *cell = (NJThumbnailCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (self.images && self.images.count > 0) {
        cell.imageView.image = [self.images objectAtIndex:indexPath.row];
    }

    return cell;
}


#pragma mark -
#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NJMedia *media = [self.medias objectAtIndex:indexPath.row];
    [self.delegate collectionView:collectionView  selectedImageWithKey:media.mediaHash];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}


@end
