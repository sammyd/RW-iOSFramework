//
//  RWViewController.m
//  KnobControl
//
//  Created by Sam Davies on 14/11/2013.
//  Copyright (c) 2013 RayWenderlich. All rights reserved.
//

#import "RWViewController.h"
#import <RWUIControls/RWUIControls.h>

@interface RWViewController () {
    RWKnobControl *_knobControl;
    RWRibbonView  *_ribbonView;
}

@end

@implementation RWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _knobControl = [[RWKnobControl alloc] initWithFrame:self.knobPlaceholder.bounds];
    [self.knobPlaceholder addSubview:_knobControl];
    
    _knobControl.lineWidth = 4.0;
    _knobControl.pointerLength = 8.0;
    self.view.tintColor = [UIColor redColor];
    
    [_knobControl addObserver:self forKeyPath:@"value" options:0 context:NULL];
    
    // Hooks up the knob control
    [_knobControl addTarget:self
                     action:@selector(handleValueChanged:)
           forControlEvents:UIControlEventValueChanged];
    
    // Creates a sample ribbon view
    _ribbonView = [[RWRibbonView alloc] initWithFrame:self.ribbonViewContainer.bounds];
    [self.ribbonViewContainer addSubview:_ribbonView];
    // Need to check that it actually works :)
    UIView *sampleView = [[UIView alloc] initWithFrame:_ribbonView.bounds];
    sampleView.backgroundColor = [UIColor lightGrayColor];
    [_ribbonView addSubview:sampleView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleValueChanged:(id)sender {
    if(sender == self.valueSlider) {
        _knobControl.value = self.valueSlider.value;
    } else if(sender == _knobControl) {
        self.valueSlider.value = _knobControl.value;
    }
}

- (IBAction)handleRandomButtonPressed:(id)sender {
    // Generate random value
    CGFloat randomValue = (arc4random() % 101) / 100.f;
    // Then set it on the two controls
    [_knobControl setValue:randomValue animated:self.animateSwitch.on];
    [self.valueSlider setValue:randomValue animated:self.animateSwitch.on];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(object == _knobControl && [keyPath isEqualToString:@"value"]) {
        self.valueLabel.text = [NSString stringWithFormat:@"%0.2f", _knobControl.value];
    }
}
@end
