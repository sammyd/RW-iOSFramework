//
//  RWViewController.m
//  ImageViewer
//
//  Created by Sam Davies on 19/02/2014.
//  Copyright (c) 2014 RayWenderlich. All rights reserved.
//

#import "RWViewController.h"
#import <RWUIControls/RWUIControls.h>

@interface RWViewController ()
    @property (nonatomic, strong) UIImageView *imageView;
    @property (nonatomic, strong) RWKnobControl *rotationKnob;
    @end

@implementation RWViewController
    
- (void)viewDidLoad
    {
        [super viewDidLoad];
        // Create UIImageView
        CGRect frame = self.view.bounds;
        frame.size.height *= 2/3.0;
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectInset(frame, 0, 20)];
        self.imageView.image = [UIImage imageNamed:@"sampleImage.jpg"];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:self.imageView];
        
        // Create RWKnobControl
        frame.origin.y += frame.size.height;
        frame.size.height /= 2;
        frame.size.width  = frame.size.height;
        self.rotationKnob = [[RWKnobControl alloc] initWithFrame:CGRectInset(frame, 10, 10)];
        CGPoint center = self.rotationKnob.center;
        center.x = CGRectGetMidX(self.view.bounds);
        self.rotationKnob.center = center;
        [self.view addSubview:self.rotationKnob];
        
        // Set up config on RWKnobControl
        self.rotationKnob.minimumValue = -M_PI_4;
        self.rotationKnob.maximumValue = M_PI_4;
        [self.rotationKnob addTarget:self
                              action:@selector(rotationAngleChanged:)
                    forControlEvents:UIControlEventValueChanged];
    }
    
- (void)rotationAngleChanged:(id)sender
    {
        self.imageView.transform = CGAffineTransformMakeRotation(self.rotationKnob.value);
    }
    
- (NSUInteger)supportedInterfaceOrientations
    {
        return UIInterfaceOrientationMaskPortrait;
    }
    
    @end