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
    _aqi = [NSNumber numberWithInt:400];
    _quality = @"轻度污染";
    
    //set default values
    self.width = 40.0;
    self.angle = 90.0;
    self.margin = 5;
    self.indicatorSize = 10;
    self.colors = ({
        UIColor *good = [UIColor greenColor];
        UIColor *moderate = [UIColor yellowColor];
        UIColor *unhealthyForSensitiveGroups = [UIColor orangeColor];
        UIColor *unhealthy = [UIColor redColor];
        UIColor *veryUnhealthy = [UIColor purpleColor];
        UIColor *hazardous = [UIColor colorWithRed:0.5 green:0 blue:0 alpha:1.0];
        
        @[good, moderate, unhealthyForSensitiveGroups, unhealthy, veryUnhealthy, veryUnhealthy
          , hazardous, hazardous, hazardous, hazardous];
    });
}

-(void)setAqiValue:(CGFloat)aqiValue
{
    _aqi = @(aqiValue);
    [self setNeedsDisplay];
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
    const CGFloat minAQI = 0;
    const CGFloat maxAQI = 500;
    
    CGSize size = rect.size;
    CGFloat margin = self.margin;
    CGFloat indicatorSize = self.indicatorSize;
    CGFloat radiusOuter = MIN(size.width, size.height)/2 - margin - indicatorSize; //outer radius
    CGFloat radiusInner = radiusOuter - self.width; //inner radius
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, radiusOuter+margin+indicatorSize, radiusOuter+margin+indicatorSize);
    CGContextScaleCTM(context, 1, -1);

    CGFloat x0 = 0;
    CGFloat y0 = 0;
    CGFloat angle = self.angle;
    CGFloat remainingAngle = 360 - angle;
    NSUInteger steps = [self.colors count];
    
    CGFloat deltaAngle = remainingAngle / steps * M_PI/180;
    CGFloat angle0 = (270-angle/2)*M_PI/180;
    CGContextSetStrokeColorWithColor(context, [[UIColor darkGrayColor] CGColor]);
    CGContextSetLineWidth(context, 4);
    //draw colors segments and units
    for(int i=0; i<steps; i++){
        CGFloat angle1 = angle0 - deltaAngle;
        CGContextAddArc(context, x0, y0, radiusOuter, angle0, angle1, true); //clockwise
        CGContextAddArc(context, x0, y0, radiusInner, angle1, angle0, false); //anti-closewise
        CGContextClosePath(context);
        UIColor *color = [self.colors objectAtIndex:i];
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextSetLineWidth(context, 0);
        CGContextDrawPath(context, kCGPathFill);
        
        BOOL drawUnitsAroundCircle = NO;
        if(drawUnitsAroundCircle && i != 0){
            CGContextSaveGState(context);
            NSInteger numAQISegments = [self.colors count];
            const CGFloat aqiStep = (maxAQI-minAQI) / numAQISegments;
            NSString *unitString = [@(minAQI + aqiStep * i) stringValue];
            
            CGContextRotateCTM(context, angle0);
            CGContextScaleCTM(context, 1, -1);
            NSDictionary *unitAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName: [UIColor grayColor]};
            [unitString drawAtPoint:CGPointMake(radiusOuter, 0) withAttributes:unitAttributes];
            CGContextRestoreGState(context);
        }
        angle0 -= deltaAngle;
    }
    
    if(_aqi != nil){
        CGFloat a = 0.707*radiusInner; //inner rectange inside a circle (with radiusInner)
        
        NSString *aqiString = [_aqi stringValue];
        const CGFloat desiredAQIFontSize = 48;
        //adjust font size so that: fontSize.width < 2*a && fontSize.height < 2*a
        CGFloat fontSize = desiredAQIFontSize;
        CGSize textSizeAQI;
        NSDictionary *attributesAQI;
        do{
            attributesAQI = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:fontSize]};
            textSizeAQI = [aqiString sizeWithAttributes:attributesAQI];
            fontSize -= 1.0;
        }while(fontSize>7 && (textSizeAQI.width>2*a || textSizeAQI.height>2*a));
        
        CGContextScaleCTM(context, 1, -1); //y- flip text
        NSInteger numAQISegments = [self.colors count];
        const CGFloat aqiStep = (maxAQI-minAQI) / numAQISegments;
        NSInteger segmentOfAQI = MIN([_aqi intValue]/aqiStep, numAQISegments-1);
        UIColor *textColor = [UIColor greenColor]; //TODO: if aqi!=nil, use colors[aqi]
        textColor = self.colors[segmentOfAQI];
        
        [aqiString drawAtPoint:CGPointMake(x0-textSizeAQI.width/2, y0-textSizeAQI.height/2) withAttributes:
         @{NSFontAttributeName: [UIFont boldSystemFontOfSize:fontSize], NSForegroundColorAttributeName: textColor}];
        
        if(_quality != nil){
            NSDictionary *attributesQuality = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName: [UIColor lightGrayColor]};
            CGSize textSizeQuality = [_quality sizeWithAttributes:attributesQuality];
            CGFloat padding = 0;
            [_quality drawAtPoint:CGPointMake(x0-textSizeQuality.width/2, y0+textSizeAQI.height/2+textSizeQuality.height/2+padding) withAttributes:attributesQuality];
        }
        
        //draw indicator around outer circle
        {
            CGFloat aqi = MIN(MAX(minAQI, [_aqi floatValue]), maxAQI); //clamp to [minAQI, maxAQI]
            CGFloat A0 = (270 - angle/2)*M_PI/180;
            CGFloat A1 = (-90 + angle/2)*M_PI/180;
            CGFloat indicatorAngle = (aqi - minAQI)/(maxAQI - minAQI) * (A1-A0) + A0;
            CGContextScaleCTM(context, 1, -1);
            CGContextRotateCTM(context, indicatorAngle);
            
            CGContextSetFillColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
            CGContextMoveToPoint(context, radiusOuter, 0);
            CGContextAddLineToPoint(context, radiusOuter + indicatorSize, indicatorSize);
            CGContextAddLineToPoint(context, radiusOuter + indicatorSize, -indicatorSize);
            CGContextClosePath(context);
            CGContextFillPath(context);
            
            CGContextMoveToPoint(context, radiusInner, 0);
            CGContextAddLineToPoint(context, radiusInner - indicatorSize, indicatorSize);
            CGContextAddLineToPoint(context, radiusInner - indicatorSize, -indicatorSize);
            CGContextClosePath(context);
            CGContextFillPath(context);
        }
    }
}

-(void)setWidth:(CGFloat)width
{
    _width = width;
    [self invalidateIntrinsicContentSize];
    [self setNeedsDisplay];
}

-(void)setMargin:(CGFloat)margin
{
    _margin = margin;
    [self invalidateIntrinsicContentSize];
    [self setNeedsDisplay];
}

-(void)setIndicatorSize:(CGFloat)indicatorSize
{
    _indicatorSize = indicatorSize;
    [self invalidateIntrinsicContentSize];
    [self setNeedsDisplay];
}
-(void)setColors:(NSArray<UIColor *> *)colors
{
    _colors = colors;
    [self setNeedsDisplay];
}

-(CGSize)intrinsicContentSize
{
    CGFloat intrinsicInnerCircleRadius = 80;
    CGFloat size = (intrinsicInnerCircleRadius + self.width + self.indicatorSize+ self.margin) * 2;
    return CGSizeMake(size, size);
//    return CGSizeMake(250, 250);
//    return CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric);
}

@end
