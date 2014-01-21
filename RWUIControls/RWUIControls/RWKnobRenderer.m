//
//  RWKnobRenderer.m
//  KnobControl
//
//  Created by Sam Davies on 16/11/2013.
//  Copyright (c) 2013 RayWenderlich. All rights reserved.
//

#import "RWKnobRenderer.h"

@implementation RWKnobRenderer

- (id)init
{
    self = [super init];
    if (self) {
        _trackLayer = [CAShapeLayer layer];
        _trackLayer.fillColor = [UIColor clearColor].CGColor;
        _pointerLayer = [CAShapeLayer layer];
        _pointerLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return self;
}

#pragma mark - Drawing Methods
- (void)updateTrackShape
{
    CGPoint center = CGPointMake(CGRectGetWidth(self.trackLayer.bounds)/2,
                                 CGRectGetHeight(self.trackLayer.bounds)/2);
    CGFloat offset = MAX(self.pointerLength, self.lineWidth / 2.f);
    CGFloat radius = MIN(CGRectGetHeight(self.trackLayer.bounds),
                         CGRectGetWidth(self.trackLayer.bounds)) / 2 - offset;
    UIBezierPath *ring = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:self.startAngle
                                                      endAngle:self.endAngle
                                                     clockwise:YES];
    self.trackLayer.path = [ring CGPath];
}

- (void)updatePointerShape
{
    UIBezierPath *pointer = [UIBezierPath bezierPath];
    [pointer moveToPoint:CGPointMake(CGRectGetWidth(self.pointerLayer.bounds) - self.pointerLength - self.lineWidth/2.f,
                                     CGRectGetHeight(self.pointerLayer.bounds) / 2.f)];
    [pointer addLineToPoint:CGPointMake(CGRectGetWidth(self.pointerLayer.bounds),
                                        CGRectGetHeight(self.pointerLayer.bounds) / 2.f)];
    self.pointerLayer.path = [pointer CGPath];
}

#pragma mark - Property overrides
- (void)setPointerLength:(CGFloat)pointerLength
{
    if(pointerLength != _pointerLength) {
        _pointerLength = pointerLength;
        [self updateTrackShape];
        [self updatePointerShape];
    }
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    if(lineWidth != _lineWidth)
    {
        _lineWidth = lineWidth;
        self.trackLayer.lineWidth = lineWidth;
        self.pointerLayer.lineWidth = lineWidth;
        [self updateTrackShape];
        [self updatePointerShape];
    }
}

- (void)setStartAngle:(CGFloat)startAngle
{
    if(startAngle != _startAngle) {
        _startAngle = startAngle;
        [self updateTrackShape];
    }
}

- (void)setEndAngle:(CGFloat)endAngle
{
    if(endAngle != _endAngle) {
        _endAngle = endAngle;
        [self updateTrackShape];
    }
}

- (void)setColor:(UIColor *)color
{
    if(color != _color) {
        _color = color;
        self.trackLayer.strokeColor = color.CGColor;
        self.pointerLayer.strokeColor = color.CGColor;
    }
}

- (void)updateWithBounds:(CGRect)bounds
{
    self.trackLayer.bounds = bounds;
    self.trackLayer.position = CGPointMake(CGRectGetWidth(bounds)/2.0, CGRectGetHeight(bounds)/2.0);
    [self updateTrackShape];
    
    self.pointerLayer.bounds = self.trackLayer.bounds;
    self.pointerLayer.position = self.trackLayer.position;
    [self updatePointerShape];
}

- (void)setPointerAngle:(CGFloat)pointerAngle
{
    [self setPointerAngle:pointerAngle animated:NO];
}

- (void)setPointerAngle:(CGFloat)pointerAngle animated:(BOOL)animated
{
    [CATransaction new];
    [CATransaction setDisableActions:YES];
    self.pointerLayer.transform = CATransform3DMakeRotation(pointerAngle, 0, 0, 1);
    if(animated) {
        // Provide an animation
        // Key-frame animation to ensure rotates in correct direction
        CGFloat midAngle = (MAX(pointerAngle, _pointerAngle) -
                            MIN(pointerAngle, _pointerAngle) ) / 2.f +
        MIN(pointerAngle, _pointerAngle);
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.duration = 3.f;
        animation.values = @[@(_pointerAngle), @(midAngle), @(pointerAngle)];
        animation.keyTimes = @[@(0), @(0.5), @(1.0)];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.pointerLayer addAnimation:animation forKey:nil];
    }
    [CATransaction commit];
    _pointerAngle = pointerAngle;
}

@end
