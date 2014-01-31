//
//  RWViewController.m
//  ImageViewer
//
//  Created by Sam Davies on 21/01/2014.
//  Copyright (c) 2014 RayWenderlich. All rights reserved.
//

#import "RWViewController.h"
#import <RWUIControls/RWUIControls.h>

@interface RWViewController ()
    
@property (nonatomic, strong) RWRibbonView *imageContainer;
@property (nonatomic, strong) RWKnobControl *rotationKnob;

@end

@implementation RWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGRect frame = self.view.bounds;
    frame.size.height *= 2/3.0;
    self.imageContainer = [[RWRibbonView alloc] initWithFrame:CGRectInset(frame, 20, 20)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.imageContainer.bounds];
    imageView.image = [UIImage imageNamed:@"sampleImage.jpg"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.imageContainer addSubview:imageView];
    [self.view addSubview:self.imageContainer];
    
    frame.origin.y += frame.size.height;
    frame.size.height /= 2;
    frame.size.width  = frame.size.height;
    
    self.rotationKnob = [[RWKnobControl alloc] initWithFrame:CGRectInset(frame, 10, 10)];
    
    CGPoint center = self.rotationKnob.center;
    center.x = CGRectGetMidX(self.view.bounds);
    self.rotationKnob.center = center;
    
    self.rotationKnob.minimumValue = -M_PI_4;
    self.rotationKnob.maximumValue = M_PI_4;
    [self.rotationKnob addTarget:self
                          action:@selector(rotationAngleChanged:)
                forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.rotationKnob];
}

- (void)rotationAngleChanged:(id)sender
{
    self.imageContainer.transform = CGAffineTransformMakeRotation(self.rotationKnob.value);
}
    
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
    
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
