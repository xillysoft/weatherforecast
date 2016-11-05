//
//  ZZCircleView.m
//  weather_forecast
//
//  Created by zhaoxiaojian on 11/4/16.
//  Copyright © 2016 Zhao Xiaojian. All rights reserved.
//

#import "ZZCircleView.h"

@implementation ZZCircleView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self _clearBackgroundColor];
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self _clearBackgroundColor];
    return self;
}

-(void)_clearBackgroundColor
{
    self.opaque = NO; //imporant: set either .opaque or .self.clearsContextBeforeDrawing property to NO.
    //    self.clearsContextBeforeDrawing = NO;
    //    self.backgroundColor = [UIColor clearColor];
}

//-(void)setBackgroundColor:(UIColor *)backgroundColor
//{
//    [super setBackgroundColor:[UIColor clearColor]];
//}

-(void)drawRect:(CGRect)rect
{
    const CGFloat lineWidth = 4;
    
    CGSize size = rect.size;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat r = MIN(size.width, size.height)/2;
    CGContextAddArc(context, r, r, r-lineWidth/2, 0, 2*M_PI, 0);
    UIColor *color = [UIColor grayColor];
    CGContextSetStrokeColorWithColor(context, [color CGColor]);
    CGContextSetLineWidth(context, lineWidth);
    CGContextStrokePath(context);
}

@end
