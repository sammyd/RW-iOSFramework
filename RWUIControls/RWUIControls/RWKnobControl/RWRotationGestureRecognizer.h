//
//  RWRotationGestureRecognizer.h
//  KnobControl
//
//  Created by Sam Davies on 26/11/2013.
//  Copyright (c) 2013 RayWenderlich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RWRotationGestureRecognizer : UIPanGestureRecognizer

@property (nonatomic, assign) CGFloat touchAngle;

@end
