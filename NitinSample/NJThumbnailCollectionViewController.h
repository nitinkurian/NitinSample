//
//  NJThumbnailCollectionViewController.h
//  NitinSample
//
//  Created by NITIN JOHN on 5/4/13.
//  Copyright (c) 2013 NITIN JOHN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJUser.h"

@protocol NJThumbnailCollectionViewControllerDelegate;

@interface NJThumbnailCollectionViewController : UICollectionViewController

@property (nonatomic, strong) NSArray *medias;
@property (strong, nonatomic) NSManagedObjectContext *thisManagedObjectContext;
@property (weak, nonatomic) id<NJThumbnailCollectionViewControllerDelegate> delegate;

- (void)addImage:(UIImage *)image;

@end

@protocol NJThumbnailCollectionViewControllerDelegate <NSObject>

- (void)collectionView:(UICollectionView *)view selectedImageWithKey:(NSString *)hash;

@end
