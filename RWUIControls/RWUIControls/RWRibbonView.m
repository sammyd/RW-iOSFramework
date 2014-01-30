//
//  RWRibbonView.m
//  RWUIControls
//
//  Created by Sam Davies on 29/01/2014.
//  Copyright (c) 2014 RayWenderlich. All rights reserved.
//

#import "RWRibbonView.h"

@interface RWRibbonView ()

@property (nonatomic, strong) UIImageView *ribbonView;

@end


@implementation RWRibbonView


#pragma mark - Constructor overrides
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addRibbonView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addRibbonView];
    }
    return self;
}
    
    
- (void)addSubview:(UIView *)view
{
    [super addSubview:view];
    // Make sure that the ribbon is on top
    [self bringSubviewToFront:self.ribbonView];
}



#pragma mark - Util method
- (void)addRibbonView
{
    UIImage *image = [UIImage imageNamed:@"RWUIControls.bundle/RWRibbon"];
    self.ribbonView = [[UIImageView alloc] initWithImage:image];
    self.ribbonView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    CGRect frame = self.ribbonView.frame;
    frame.origin.y = -7;
    frame.origin.x = CGRectGetWidth(self.bounds) - CGRectGetWidth(frame) - 5;
    self.ribbonView.frame = frame;
    [self addSubview:self.ribbonView];
}

@end
