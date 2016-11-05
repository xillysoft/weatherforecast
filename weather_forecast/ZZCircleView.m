//
//  ZZCircleView.m
//  weather_forecast
//
//  Created by zhaoxiaojian on 11/4/16.
//  Copyright © 2016 Zhao Xiaojian. All rights reserved.
//

#import "ZZCircleView.h"

@implementation ZZCircleView

-(void)drawRect:(CGRect)rect
{
    CGSize size = rect.size;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat r = MIN(size.width, size.height);
    CGContextAddArc(context, r, r, r, 0, 2*M_PI, 0);
    UIColor *color = [UIColor lightGrayColor];
    CGContextSetStrokeColorWithColor(context, [color CGColor]);
    CGContextSetLineWidth(context, 10);
    CGContextStrokePath(context);
}

@end
