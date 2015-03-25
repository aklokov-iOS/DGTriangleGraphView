//
//  DGTriangle.h
//  DGGraphView
//
//  Created by Danil Gontovnik on 3/25/15.
//  Copyright (c) 2015 Danil Gontovnik. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface DGTriangle : CAShapeLayer

- (id)initWithFrame:(CGRect)frame initialPath:(CGPathRef)initialPath finalPath:(CGPathRef)finalPath;

- (void)animateFinalPathWithDuration:(CGFloat)duration afterDelay:(CGFloat)delay;

@end
