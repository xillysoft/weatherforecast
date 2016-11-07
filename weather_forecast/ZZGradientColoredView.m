//
//  ZZGradientColoredView.m
//  weather_forecast
//
//  Created by zhaoxiaojian on 11/7/16.
//  Copyright © 2016 Zhao Xiaojian. All rights reserved.
//

#import "ZZGradientColoredView.h"

@implementation ZZGradientColoredView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self _setupView];
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self _setupView];
    return self;
}

-(void)_setupView
{
    self.direction = ZZGradientColoredViewDirectionHorizontal;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CFMutableArrayRef colors = CFArrayCreateMutable(NULL, 2, NULL);
    CFArrayAppendValue(colors, [self.colorStart CGColor]);
    CFArrayAppendValue(colors, [self.colorEnd CGColor]);
    
    const CGFloat locations[] = {0.0, 1.0};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colors, locations);
    
    CGRect bounds = self.bounds;
    CGFloat x0, y0;
    CGFloat x1, y1;
    x0 = bounds.origin.x, y0 = bounds.origin.y;
    if(self.direction == ZZGradientColoredViewDirectionHorizontal){
        x1 = bounds.origin.x + bounds.size.width;
        y1 = y0;
    }else{
        x1 = x0;
        y1 = bounds.origin.y + bounds.size.height;
    }
    CGContextDrawLinearGradient(context, gradient, CGPointMake(x0, y0), CGPointMake(x1, y1), kCGGradientDrawsBeforeStartLocation|kCGGradientDrawsAfterEndLocation);
    
    CGGradientRelease(gradient);
    CFRelease(colorSpace);
    CGColorSpaceRelease(colorSpace);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
