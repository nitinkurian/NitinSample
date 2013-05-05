//
//  NJLoginView.m
//  NitinSample
//
//  Created by NITIN JOHN on 5/4/13.
//  Copyright (c) 2013 NITIN JOHN. All rights reserved.
//

#import "NJLoginView.h"
#import <QuartzCore/QuartzCore.h>

@implementation NJLoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    self.containerView.layer.cornerRadius = 5.0;
    self.containerView.layer.borderColor = [UIColor blackColor].CGColor;
    self.containerView.layer.borderWidth = 2.0;
    self.containerView.layer.masksToBounds = YES;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
