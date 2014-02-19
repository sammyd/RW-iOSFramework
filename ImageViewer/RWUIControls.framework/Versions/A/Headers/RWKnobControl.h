//
//  RWKnobControl.h
//  KnobControl
//
//  Created by Sam Davies on 15/11/2013.
//  Copyright (c) 2013 RayWenderlich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RWKnobControl : UIControl

#pragma mark - Knob value
/**
 Contains the current value
 */
@property (nonatomic, assign) CGFloat value;


/**
 Sets the value the knob should represented, with optional animation of the change.
 */
- (void)setValue:(CGFloat)value animated:(BOOL)animated;


#pragma mark - Value Limits
/**
 The minimum value of the knob. Defaults to 0.
 */
@property (nonatomic, assign) CGFloat minimumValue;

/**
 The maximum value of the knob. Defaults to 1.
 */
@property (nonatomic, assign) CGFloat maximumValue;


#pragma mark - Knob Behavior
/**
 Contains a Boolean value indicating whether changes in the value of the knob
 generate continuous update events. The default value is `YES`.
 */
@property (nonatomic, assign, getter = isContinuous) BOOL continuous;


#pragma mark - Control appearance
/**
 Specifies the angle of the start of the knob control track. Defaults to -11π/8
 */
@property (nonatomic, assign) CGFloat startAngle;

/**
 Specifies the end angle of the knob control track. Defaults to 3π/8
 */
@property (nonatomic, assign) CGFloat endAngle;

/**
 Specifies the width in points of the knob control track. Defaults to 2.0
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 Specifies the length in points of the pointer on the knob. Defaults to 6.0
 */
@property (nonatomic, assign) CGFloat pointerLength;

@end
