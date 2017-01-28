//
//  ZZGradientColoredView.m
//  weather_forecast
//
//  Created by zhaoxiaojian on 11/7/16.
//  Copyright © 2016 Zhao Xiaojian. All rights reserved.
//

#import "ZZGradientColoredView.h"

@implementation ZZGradientColoredView

+(Class)layerClass
{
    return [CAGradientLayer class];
}

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
    self.direction = ZZGradientColoredViewDirectionVertical; //default direction
    self.colorStart = [UIColor redColor]; //default start and end color
    self.colorEnd = [UIColor blueColor];
}

-(void)setDirection:(ZZGradientColoredViewDirection)direction
{
    _direction = direction;
    
    if(direction == ZZGradientColoredViewDirectionAutomatical){
        CGRect bounds = self.layer.bounds;
        direction = bounds.size.width > bounds.size.height ? ZZGradientColoredViewDirectionHorizontal : ZZGradientColoredViewDirectionVertical;
    }
    CAGradientLayer *gradient = (CAGradientLayer *)[self layer];
    if(direction == ZZGradientColoredViewDirectionVertical){
        gradient.startPoint = CGPointMake(0.5, 0.0);
        gradient.endPoint = CGPointMake(0.5, 1.0);
    }else{
        gradient.startPoint = CGPointMake(0.0, 0.5);
        gradient.endPoint = CGPointMake(1.0, 0.5);
    }
}

-(void)setColorStart:(UIColor *)colorStart
{
    _colorStart = colorStart;
    
    CAGradientLayer *gradient = (CAGradientLayer *)[self layer];
    if(self.colorStart && self.colorEnd){
        gradient.colors = @[(id)[self.colorStart CGColor], (id)[self.colorEnd CGColor]];
    }
}
-(void)setColorEnd:(UIColor *)colorEnd
{
    _colorEnd = colorEnd;
    
    CAGradientLayer *gradient = (CAGradientLayer *)[self layer];
    if(self.colorStart && self.colorEnd){
        gradient.colors = @[(id)[self.colorStart CGColor], (id)[self.colorEnd CGColor]];
    }
}

/*
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
    
    ZZGradientColoredViewDirection direction;
    if(self.direction == ZZGradientColoredViewDirectionAutomatical){
        direction = bounds.size.width > bounds.size.height ? ZZGradientColoredViewDirectionHorizontal : ZZGradientColoredViewDirectionVertical;
    }else{
        direction = self.direction;
    }
    
    if(direction == ZZGradientColoredViewDirectionHorizontal){
        x1 = bounds.origin.x + bounds.size.width;
        y1 = y0;
    }else{
        x1 = x0;
        y1 = bounds.origin.y + bounds.size.height;
    }
    CGContextDrawLinearGradient(context, gradient, CGPointMake(x0, y0), CGPointMake(x1, y1), kCGGradientDrawsBeforeStartLocation|kCGGradientDrawsAfterEndLocation);
    
    CGGradientRelease(gradient);
    CFRelease(colors);
    CGColorSpaceRelease(colorSpace);
    
}
*/

@end
