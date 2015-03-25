//
//  ViewController.m
//  DGTriangleGraphViewExample
//
//  Created by Danil Gontovnik on 3/25/15.
//  Copyright (c) 2015 Danil Gontovnik. All rights reserved.
//

#import "ViewController.h"
#import "DGTriangleGraphView.h"

@interface ViewController () {
    DGTriangleGraphView *triangleGraphView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.view.backgroundColor = [UIColor colorWithRed:20/255.0f green:15/255.0f blue:10/255.0f alpha:1.0f];
    
    triangleGraphView = [[DGTriangleGraphView alloc] init];
    triangleGraphView.overlapPercentage = 0.25f;
    triangleGraphView.triangleAnimationDuration = 0.2f;
    triangleGraphView.titlesFont = [UIFont systemFontOfSize:13.0f];
    triangleGraphView.titlesHeight = 25.0f;
    triangleGraphView.sort = DGTriangleGraphViewSortHighToLow;
    triangleGraphView.frame = CGRectMake(20, 50, self.view.bounds.size.width - 40, 200);
    [self.view addSubview:triangleGraphView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self randomizeWithTitlesPressed];
    });
    
    UIButton *animateIn = [UIButton buttonWithType:UIButtonTypeSystem];
    animateIn.frame = CGRectMake(triangleGraphView.frame.origin.x,
                                 triangleGraphView.frame.origin.y + triangleGraphView.bounds.size.height + 20,
                                 triangleGraphView.bounds.size.width,
                                 50);
    [animateIn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [animateIn setTitle:@"Animate" forState:UIControlStateNormal];
    [animateIn addTarget:self action:@selector(animateInPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:animateIn];
    
    UIButton *randomizeWithTitles = [UIButton buttonWithType:UIButtonTypeSystem];
    randomizeWithTitles.frame = CGRectMake(animateIn.frame.origin.x,
                                 animateIn.frame.origin.y + animateIn.bounds.size.height,
                                 animateIn.bounds.size.width,
                                 animateIn.bounds.size.height);
    [randomizeWithTitles setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [randomizeWithTitles setTitle:@"Randomize with titles" forState:UIControlStateNormal];
    [randomizeWithTitles addTarget:self action:@selector(randomizeWithTitlesPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:randomizeWithTitles];
    
    UIButton *randomizeWithoutTitles = [UIButton buttonWithType:UIButtonTypeSystem];
    randomizeWithoutTitles.frame = CGRectMake(randomizeWithTitles.frame.origin.x,
                                              randomizeWithTitles.frame.origin.y + randomizeWithTitles.bounds.size.height,
                                              randomizeWithTitles.bounds.size.width,
                                              randomizeWithTitles.bounds.size.height);
    [randomizeWithoutTitles setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [randomizeWithoutTitles setTitle:@"Randomize without titles" forState:UIControlStateNormal];
    [randomizeWithoutTitles addTarget:self action:@selector(randomizeWithoutTitlesPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:randomizeWithoutTitles];
}

#pragma mark -
#pragma mark Methods

- (void)animateInPressed {
    [triangleGraphView animateIn];
}

- (void)randomizeWithTitlesPressed {
    uint16_t random = arc4random()%6 + 2;
    
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:random];
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:random];
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:random];
    
    for (uint16_t i = 0; i < random; i++) {
        NSNumber *randomValue = @(arc4random()%50 + 1);
        [values addObject:randomValue];
        [colors addObject:[DGTriangleGraphView randomColor]];
        [titles addObject:[NSString stringWithFormat:@"%@", randomValue]];
    }
    triangleGraphView.colors = colors;
    triangleGraphView.values = values;
    triangleGraphView.titles = titles;
    [triangleGraphView animateIn];
}

- (void)randomizeWithoutTitlesPressed {
    uint16_t random = arc4random()%6 + 2;
    
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:random];
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:random];
    
    for (uint16_t i = 0; i < random; i++) {
        NSNumber *randomValue = @(arc4random()%50 + 1);
        [values addObject:randomValue];
        [colors addObject:[DGTriangleGraphView randomColor]];
    }
    triangleGraphView.colors = colors;
    triangleGraphView.values = values;
    triangleGraphView.titles = nil;
    [triangleGraphView animateIn];
}

@end
