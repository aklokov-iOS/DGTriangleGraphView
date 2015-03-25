//
//  DGTriangleGraphView.m
//  DGTriangleGraphView
//
//  Created by Danil Gontovnik on 3/25/15.
//  Copyright (c) 2015 Danil Gontovnik. All rights reserved.
//

#import "DGTriangleGraphView.h"

#import "DGTriangle.h"

static NSString *kValue = @"value";
static const NSString *kColor = @"color";
static const NSString *kTitle = @"title";

@interface DGTriangleGraphView () {
    NSMutableArray *triangleLayers;
    NSMutableArray *titleLayers;
}

@end

@implementation DGTriangleGraphView

#pragma mark -
#pragma mark Constructors

- (id)initWithValues:(NSArray *)values colors:(NSArray *)colors {
    self = [super init];
    if (self) {
        _values = [self validateValueArray:values];
        _colors = colors;
        [self setup];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark -
#pragma mark Setup

- (void)setup {
    triangleLayers = [NSMutableArray array];
    titleLayers = [NSMutableArray array];
    
    _triangleAnimationDuration = 0.3f;
    _overlapPercentage = 0.3f;
    _sort = DGTriangleGraphViewSortLowToHigh;
    _titlesFont = [UIFont systemFontOfSize:15.0f];
}

#pragma mark -
#pragma mark Methods

- (void)sortValues {
    if (self.sort == DGTriangleGraphViewSortNone) {
        return;
    }
    
    // Create array of dictionaries with values, colors and titles (if titles exit)
    NSMutableArray *dictionaries = [NSMutableArray arrayWithCapacity:self.values.count];
    [self.values enumerateObjectsUsingBlock:^(NSNumber *value, NSUInteger idx, BOOL *stop) {
        UIColor *color = [self colorForIndex:idx];
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:3];
        [dictionary setObject:color forKey:kColor];
        [dictionary setObject:value forKey:kValue];
        
        if ([self titleAvailableAtIndex:idx]) {
            NSString *title = self.titles[idx];
            [dictionary setObject:title forKey:kTitle];
        }
        
        [dictionaries addObject:dictionary];
    }];
    
    // Sort array
    BOOL ascending = (self.sort == DGTriangleGraphViewSortLowToHigh);
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:kValue ascending:ascending];
    NSArray *sortedArray = [dictionaries sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    // Filling arrays from dictionaries
    NSMutableArray *sortedValues = [NSMutableArray arrayWithCapacity:self.values.count];
    NSMutableArray *sortedColors = [NSMutableArray arrayWithCapacity:self.values.count];
    NSMutableArray *sortedTitles = [NSMutableArray arrayWithCapacity:self.values.count];
    [sortedArray enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger idx, BOOL *stop) {
        [sortedValues addObject:dictionary[kValue]];
        [sortedColors addObject:dictionary[kColor]];
        
        if (dictionary[kTitle]) {
            [sortedTitles addObject:dictionary[kTitle]];
        }
    }];
    
    self.values = sortedValues;
    
    if (sortedTitles.count > 0) {
        self.titles = sortedTitles;
    }
    
    if (self.shouldSortColorsWithValues) {
        self.colors = sortedColors;
    }
}

- (void)animateIn {
    // If there is no values then return
    if (!self.values || self.values.count == 0) {
        return;
    }
    
    // Removing all triangles from superlayer
    [triangleLayers enumerateObjectsUsingBlock:^(DGTriangle *triangle, NSUInteger idx, BOOL *stop) {
        [triangle removeFromSuperlayer];
    }];
    
    // Removing all objects from array
    [triangleLayers removeAllObjects];
    
    // Same logic for titles
    [titleLayers enumerateObjectsUsingBlock:^(CATextLayer *textLayer, NSUInteger idx, BOOL *stop) {
        [textLayer removeFromSuperlayer];
    }];
    
    [titleLayers removeAllObjects];
    
    // Sort values low to high
    [self sortValues];
    
    // Calculating vars
    CGFloat triangleWidth = self.bounds.size.width / (self.values.count - self.overlapPercentage * (self.values.count - 1));
    CGFloat overlappingWidth = triangleWidth * self.overlapPercentage;
    
    CGFloat groundOriginY = self.bounds.size.height;
    
    // Calculate text layer and change groundOriginY
    // Only if text is available
    CGFloat textLayerHeight = 0.0f;
    if ([self titleAvailableAtIndex:0]) {
        textLayerHeight = [@" " sizeWithAttributes:@{NSFontAttributeName : self.titlesFont}].height;
        
        if (self.titlesHeight <= 0.0f) {
            self.titlesHeight = textLayerHeight;
        }
        groundOriginY -= self.titlesHeight;
    }
    
    // Cast to integer, so it does not have decimals
    groundOriginY = (int)groundOriginY;
    
    CGFloat heightPerUnit = groundOriginY / [[self maxValue] doubleValue];
    
    // Preparing initial bezier path
    UIBezierPath *initialBezierPath = [UIBezierPath bezierPath];
    [initialBezierPath moveToPoint:CGPointMake(0, groundOriginY)];
    [initialBezierPath addLineToPoint:CGPointMake(triangleWidth / 2.0f, groundOriginY)];
    [initialBezierPath addLineToPoint:CGPointMake(triangleWidth, groundOriginY)];
    [initialBezierPath addLineToPoint:CGPointMake(0, groundOriginY)];
    [initialBezierPath closePath];

    // Enumerating values array and setting app shape layers
    for (NSUInteger idx = 0; idx < self.values.count; idx++) {
        DGTriangle *triangle = [self setupTriangleWithIndex:idx
                                              triangleWidth:triangleWidth
                                              groundOriginY:groundOriginY
                                                initialPath:initialBezierPath.CGPath
                                              heightPerUnit:heightPerUnit
                                           overlappingWidth:overlappingWidth];
        
        // Adding triangle to array, so in the future we can access it
        [triangleLayers addObject:triangle];
        
        // Setup title only if it is available
        if ([self titleAvailableAtIndex:idx]) {
            CATextLayer *titleTextLayer = [self setupTitleLayerWithIndex:idx
                                                         textLayerHeight:textLayerHeight
                                                           triangleWidth:triangleWidth
                                                           groundOriginY:groundOriginY
                                                        overlappingWidth:overlappingWidth];
            [titleLayers addObject:titleTextLayer];
        }
    }
    
    [triangleLayers enumerateObjectsUsingBlock:^(DGTriangle *triangle, NSUInteger idx, BOOL *stop) {
        CGFloat delay = self.triangleAnimationDuration / 2 * idx;
        [triangle animateFinalPathWithDuration:self.triangleAnimationDuration afterDelay:delay];
    }];
}

#pragma mark -
#pragma mark Setters

- (void)setValues:(NSArray *)values {
    if (![_values isEqualToArray:values]) {
        _values = [self validateValueArray:values];
    }
}

#pragma mark -
#pragma mark Getters

- (DGTriangle *)setupTriangleWithIndex:(NSUInteger)idx triangleWidth:(CGFloat)triangleWidth groundOriginY:(CGFloat)groundOriginY initialPath:(CGPathRef)initialPath heightPerUnit:(CGFloat)heightPerUnit overlappingWidth:(CGFloat)overlappingWidth {
    
    NSNumber *value = self.values[idx];
    UIColor *color = [self colorForIndex:idx];
    
    CGRect frame = CGRectMake(triangleWidth * idx - overlappingWidth * idx,
                              0,
                              triangleWidth,
                              groundOriginY);
    
    CGFloat height = heightPerUnit * [value doubleValue];
    
    // Creating bezier path
    UIBezierPath *triangleBezierPath = [self triangleBezierPathWithWidth:triangleWidth groundOriginY:groundOriginY height:height];
    
    // Initializing triangle
    DGTriangle *triangle = [[DGTriangle alloc] initWithFrame:frame initialPath:initialPath finalPath:triangleBezierPath.CGPath];
    triangle.fillColor = color.CGColor;
    [self.layer addSublayer:triangle];
    
    return triangle;
}

- (CATextLayer *)setupTitleLayerWithIndex:(NSUInteger)idx textLayerHeight:(CGFloat)textLayerHeight triangleWidth:(CGFloat)triangleWidth groundOriginY:(CGFloat)groundOriginY overlappingWidth:(CGFloat)overlappingWidth {
    
    CGRect frame = CGRectMake(triangleWidth * idx - overlappingWidth * idx,
                              groundOriginY + (self.titlesHeight - textLayerHeight) / 2.0f,
                              triangleWidth,
                              textLayerHeight);
    
    CATextLayer *textLayer = [[CATextLayer alloc] init];
    textLayer.font = (__bridge CFTypeRef)(self.titlesFont);
    textLayer.fontSize = self.titlesFont.pointSize;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.frame = frame;
    textLayer.string = self.titles[idx];
    textLayer.alignmentMode = kCAAlignmentCenter;
    [self.layer addSublayer:textLayer];
    
    return textLayer;
}

- (BOOL)titleAvailableAtIndex:(NSUInteger)idx {
    return self.titles && self.titles.count > idx;
}

- (UIColor *)colorForIndex:(NSInteger)idx {
    UIColor *color;
    if (self.colors.count > idx) {
        color = self.colors[idx];
    } else {
        color = [DGTriangleGraphView randomColor];
    }
    return color;
}

- (UIBezierPath *)triangleBezierPathWithWidth:(CGFloat)triangleWidth groundOriginY:(CGFloat)groundOriginY height:(CGFloat)height {
    UIBezierPath *triangleBezierPath = [UIBezierPath bezierPath];
    [triangleBezierPath moveToPoint:CGPointMake(0, groundOriginY)];
    [triangleBezierPath addLineToPoint:CGPointMake(triangleWidth / 2.0f, groundOriginY - height)];
    [triangleBezierPath addLineToPoint:CGPointMake(triangleWidth, groundOriginY)];
    [triangleBezierPath addLineToPoint:CGPointMake(0, groundOriginY)];
    [triangleBezierPath closePath];
    return triangleBezierPath;
}

/**
 *  Use this for setters, so we do not have to check kindOfClass in future usage of self.values
 *
 *  @return array if it is only NSNumbers, or nil, if it contained different class inside
 */
- (NSArray *)validateValueArray:(NSArray *)array {
    
    // If it is not a NSNumber then return nil array
    for (id value in array) {
        BOOL notNumber = ![value isKindOfClass:[NSNumber class]];
        BOOL negative = [value compare:@(0)] == NSOrderedAscending;
        if (notNumber || negative) {
            return nil;
        }
    }
    return array;
}

- (NSNumber *)maxValue {
    if (!self.values || self.values.count == 0) {
        return @(0);
    }
    
    NSNumber *maxValue;
    for (NSNumber *value in self.values) {
        // If maxValue is nil or value bigger than maxValue, then maxValue = value
        if (!maxValue || [value compare:maxValue] == NSOrderedDescending) {
            maxValue = value;
        }
    }
    return maxValue;
}

+ (UIColor *)randomColor {
    return [UIColor colorWithRed:arc4random()%256 / 255.0f green:arc4random()%256 / 255.0f blue:arc4random()%256 / 255.0f alpha:1.0f];
}

@end
