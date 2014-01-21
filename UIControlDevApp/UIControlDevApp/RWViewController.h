//
//  RWViewController.h
//  KnobControl
//
//  Created by Sam Davies on 14/11/2013.
//  Copyright (c) 2013 RayWenderlich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RWViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *knobPlaceholder;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UISlider *valueSlider;
@property (weak, nonatomic) IBOutlet UISwitch *animateSwitch;

- (IBAction)handleValueChanged:(id)sender;
- (IBAction)handleRandomButtonPressed:(id)sender;

@end
