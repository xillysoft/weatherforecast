//
//  ZZAQIView.m
//  weather_forecast
//
//  Created by zhaoxiaojian on 11/10/16.
//  Copyright © 2016 Zhao Xiaojian. All rights reserved.
//

#import "ZZAQIDashBoardView.h"

@interface ZZAQIDashBoardView(){
    NSNumber *_aqi;
    NSString *_quality;
    NSNumber *_pm25;
    NSNumber *_pm10;
}

@end

@implementation ZZAQIDashBoardView

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
    //set default values
    self.width = 20.0;
    self.angle = 90.0;
    self.margin = 10;
    self.colors = ({
        UIColor *good = [UIColor greenColor];
        UIColor *moderate = [UIColor yellowColor];
        UIColor *unhealthyForSensitiveGroups = [UIColor orangeColor];
        UIColor *unhealthy = [UIColor redColor];
        UIColor *veryUnhealthy = [UIColor purpleColor];
        UIColor *hazardous = [UIColor colorWithRed:0x80 green:0 blue:0 alpha:1.0];
        
        @[good, moderate, unhealthyForSensitiveGroups, unhealthy, veryUnhealthy
          , hazardous, hazardous, hazardous, hazardous];
    });
}

-(void)setAQI:(NSNumber *)aqi quality:(NSString *)quality pm25:(NSNumber *)pm25 pm10:(NSNumber *)pm10
{
    _aqi = aqi;
    _quality = quality;
    _pm25 = pm25;
    _pm10 = pm10;
    
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    CGSize size = rect.size;
    CGFloat margin = self.margin;
    CGFloat radiusOuter = MIN(size.width, size.height)/2 - margin; //outer radius
    CGFloat radiusInner = radiusOuter - self.width; //inner radius
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, radiusOuter+margin, radiusOuter+margin);
//    CGContextScaleCTM(context, 1, -1);

    CGFloat x0 = 0;
    CGFloat y0 = 0;
    CGFloat angle = self.angle;
    CGFloat remainingAngle = 360 - angle;
    NSUInteger steps = [self.colors count];
    
    CGFloat deltaAngle = remainingAngle / steps * M_PI/180;
//    CGFloat angle0 = -(90-angle/2)*M_PI/180;
    CGFloat angle0 = (270-angle/2 - 180)*M_PI/180;
    CGContextSetStrokeColorWithColor(context, [[UIColor darkGrayColor] CGColor]);
    CGContextSetLineWidth(context, 4);
    for(int i=0; i<steps; i++){
        CGFloat angle1 = angle0 - deltaAngle;
//        NSLog(@"\tangle: %f-%f", angle0, angle1);
        CGContextAddArc(context, x0, y0, radiusOuter, angle0, angle1, true); //anti-clockwise
        CGContextAddArc(context, x0, y0, radiusInner, angle1, angle0, false); //closewise
        CGContextClosePath(context);
        
//        CGContextFillPath(context);
        UIColor *color = [self.colors objectAtIndex:i];
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextDrawPath(context, kCGPathFill);
        angle0 -= deltaAngle;
    }
    
    NSString *aqiString = [_aqi stringValue];
    aqiString = @"1234"; //TEST ONLY, REMOVE it
    CGFloat a = 0.707*radiusInner; //inner rectange inside a circle with radius=radiusInner
//    [aqiString drawInRect:CGRectMake(x0-a, y0-a, a*2, a*2) withAttributes:nil];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraph, NSFontAttributeName: [UIFont boldSystemFontOfSize:48], NSForegroundColorAttributeName: [UIColor greenColor]};
    CGSize fontSize = [aqiString sizeWithAttributes:attributes];
//    [aqiString drawAtPoint:CGPointMake(x0, y0) withAttributes:attributes];
//    [aqiString drawInRect:CGRectMake(x0-a, y0-a + (2*a-size.height)/2, 2*a, 2*a) withAttributes:attributes];
    [aqiString drawAtPoint:CGPointMake(x0-fontSize.width/2, y0-fontSize.height/2) withAttributes:attributes];
}

-(CGSize)intrinsicContentSize
{
//    return CGSizeMake(250, 250);
    return CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric);
}

@end
