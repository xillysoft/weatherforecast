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
    [self _initView];
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self _initView];
    return self;
}

-(void)_initView
{
    self.color = [UIColor grayColor]; //default color
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
    CGSize size = rect.size;
    const CGFloat lineWidth = size.width > 60 ? 6 : 4;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat r = MIN(size.width, size.height)/2;
    CGContextAddArc(context, r, r, r-lineWidth/2, 0, 2*M_PI, 0);
    CGContextSetStrokeColorWithColor(context, [self.color CGColor]);
    CGContextSetLineWidth(context, lineWidth);
    CGContextStrokePath(context);
}

@end
