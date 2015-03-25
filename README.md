## DGTriangleGraphView
Custom UI for iOS application which allows you to show graph with triangles.

## Requirements
* Xcode 6 or higher
* Apple LLVM compiler
* iOS 8.0 or higher (May work on previous versions, just did not testit. Feel free to edit it).
* ARC

## Demo

Build and run the DGTriangleGraphViewExample project in Xcode to see DGTriangleGraphView in action.

## Installation

### Cocoapods

In progress...

### Manual install

All you need to do is drop DGTriangleGraphView files into your project, and add #include "DGTriangleGraphView.h" to the top of classes that will use it.

## Example usage

``` objective-c
// Create triangleGraphView
DGTriangleGraphView *triangleGraphView = [[DGTriangleGraphView alloc] init];
triangleGraphView.overlapPercentage = 0.25f;
triangleGraphView.triangleAnimationDuration = 0.2f;
triangleGraphView.titlesFont = [UIFont systemFontOfSize:13.0f];
triangleGraphView.titlesHeight = 25.0f;
triangleGraphView.sort = DGTriangleGraphViewSortHighToLow;
triangleGraphView.frame = CGRectMake(20, 50, self.view.bounds.size.width - 40, 200);
[self.view addSubview:triangleGraphView];
    
// Initializing random content and animating it
// If you want to test it or used it on viewDidLoad method
// Use a dispatch_after, etc
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
```

## Contact

Danil Gontovnik

- https://github.com/gontovnik
- gontovnik.danil@gmail.com


## License

The MIT License (MIT)

Copyright (c) 2015 Danil Gontovnik

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
