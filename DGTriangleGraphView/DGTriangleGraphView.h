//
//  DGTriangleGraphView.h
//  DGTriangleGraphView
//
//  Created by Danil Gontovnik on 3/25/15.
//  Copyright (c) 2015 Danil Gontovnik. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DGTriangleGraphViewSort) {
    DGTriangleGraphViewSortNone,
    DGTriangleGraphViewSortLowToHigh,
    DGTriangleGraphViewSortHighToLow
};

@interface DGTriangleGraphView : UIView

/**
 *  Initialization method
 *
 *  @param values (ref to @property values)
 *  @param colors (ref to @property colors)
 *
 *  @return initialized graph with values and colors provided
 */
- (id)initWithValues:(NSArray *)values colors:(NSArray *)colors;

/**
 *  Expects array of NSNumbers, can be only positive
 *  It will be sorted lower to higher
 */
@property (nonatomic, strong) NSArray *values;

/**
 *  Expects array of UIColors if values.count > colors.count or colors = nil, 
 *  then colors will be generated automatically
 */
@property (nonatomic, strong) NSArray *colors;

/**
 *  Expets array of NSString
 *  If titles == nil or titles.count == 0 no title will be displayed
 */
@property (nonatomic, strong) NSArray *titles; // TODO: add sortage

/**
 *  Defines whether we should sort low to high
 *  Default value is DGTriangleGraphViewSortLowToHigh;
 */
@property (nonatomic) DGTriangleGraphViewSort sort;

/**
 *  Defines whether colors should be realted to a value. 
 *  Default value is NO;
 */
@property (nonatomic) BOOL shouldSortColorsWithValues;

/**
 *  Animation duration for each triangle. 
 *  Default value is 0.3f
 */
@property (nonatomic) CGFloat triangleAnimationDuration;

/**
 *  Defines how triangle will overlap previous one. Expected range is from 0.0f to 1.0f;
 *  0.0f means no overlap. 1.0f means it will overlap full triangle (not recommended to use).
 *  Default value is 0.3f
 */
@property (nonatomic) CGFloat overlapPercentage;

/**
 *  Defines the height of each titles (if titles.count > 0)
 *  No default value. If it is 0.0f then will be calculated automatically and will be equal lineHeight
 */
@property (nonatomic) CGFloat titlesHeight;

/**
 *  Defines font which will be used to display titles
 *  Default font is [UIFont systemFontOfSize:15.0f]
 */
@property (nonatomic, strong) UIFont *titlesFont;

/**
 *  Call this function to animate graph in. Can be used in viewDidLoad, on buttons press, whenever you want
 *  Graph is drawn and animated only after this method is called
 */
- (void)animateIn;

/**
 *  Returns random generated color
 */
+ (UIColor *)randomColor;

@end
