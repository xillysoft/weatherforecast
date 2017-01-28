//
//  ZZCircleView.m
//  weather_forecast
//
//  Created by zhaoxiaojian on 11/4/16.
//  Copyright © 2016 Zhao Xiaojian. All rights reserved.
//

#import "ZZCircleView.h"

@implementation ZZCircleView

+(Class)layerClass
{
    return [CAShapeLayer class];
}

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
    self.layer.opaque = NO;
    [self setColor:[UIColor grayColor]]; //default circle color

}

//-(void)setBackgroundColor:(UIColor *)backgroundColor
//{
//    [super setBackgroundColor:[UIColor clearColor]];
//}

-(void)setColor:(UIColor *)color
{
    _color = color;
    CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
    shapeLayer.strokeColor = [color CGColor];
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
}

-(void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    CGRect bounds = layer.bounds;
    CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
    shapeLayer.path = ({
        CGFloat d = MIN(bounds.size.width, bounds.size.height);
        [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, d, d)] CGPath];

    });
    const CGFloat lineWidth = bounds.size.width > 60 ? 6 : 4;
    shapeLayer.lineWidth = lineWidth;
}

@end
