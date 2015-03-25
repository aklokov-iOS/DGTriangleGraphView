//
//  DGTriangle.m
//  DGGraphView
//
//  Created by Danil Gontovnik on 3/25/15.
//  Copyright (c) 2015 Danil Gontovnik. All rights reserved.
//

#import "DGTriangle.h"

@interface DGTriangle () {
    CGPathRef _initialPath;
    CGPathRef _finalPath;
}
@end

@implementation DGTriangle

#pragma mark -
#pragma mark Constructors

- (id)initWithFrame:(CGRect)frame initialPath:(CGPathRef)initialPath finalPath:(CGPathRef)finalPath {
    self = [super init];
    if (self) {
        self.frame = frame;
        _initialPath = CGPathCreateCopy(initialPath);
        self.path = _initialPath;
        
        _finalPath = CGPathCreateCopy(finalPath);
    }
    return self;
}

#pragma mark -
#pragma mark Dealoc

- (void)dealloc {
    CGPathRelease(_initialPath);
    CGPathRelease(_finalPath);
}

#pragma mark -
#pragma mark Methods

- (void)animateFinalPathWithDuration:(CGFloat)duration afterDelay:(CGFloat)delay {
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.beginTime = CACurrentMediaTime() + delay;
    pathAnimation.duration = duration;
    pathAnimation.fromValue = (id)self.path;
    pathAnimation.toValue = (__bridge id)_finalPath;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
    [self addAnimation:pathAnimation forKey:@"kPathAnimation"];
}

@end
