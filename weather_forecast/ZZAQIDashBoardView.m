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

//default: 0, 500
@property CGFloat minAQI;
@property CGFloat maxAQI;

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
    _aqi = [NSNumber numberWithInt:400]; //TODO: test only, remove it.
    _quality = @"轻度污染";
    
    //set default values
    self.minAQI = 0;
    self.maxAQI = 500;
    self.width = 40.0;
    self.angle = 90.0;
    self.margin = 5;
    self.indicatorSize = 10;
    self.colors = ({
        UIColor *good = [UIColor greenColor];
        UIColor *moderate = [UIColor yellowColor];
        UIColor *unhealthyForSensitiveGroups = [UIColor orangeColor];
        UIColor *unhealthy = [UIColor redColor];
        UIColor *veryUnhealthy = [UIColor colorWithRed:0.6 green:0.0 blue:0.3 alpha:1.0]; //[UIColor purpleColor]
        UIColor *hazardous = [UIColor colorWithRed:0.5 green:0 blue:0 alpha:1.0];
     
        @[good, moderate, unhealthyForSensitiveGroups, unhealthy, veryUnhealthy, veryUnhealthy
          , hazardous, hazardous, hazardous, hazardous];
    });
}

//test only, remove it
-(void)setAqiValue:(CGFloat)aqiValue
{
    _aqi = @(aqiValue);
    [self setNeedsDisplay];
}

/*!
 * Set AQI value, quality text, pm25 value, pm10 value.
 */
-(void)setAQI:(NSNumber *)aqi quality:(NSString *)quality pm25:(NSNumber *)pm25 pm10:(NSNumber *)pm10
{
    _aqi = aqi;
    _quality = quality;
    _pm25 = pm25;
    _pm10 = pm10;
    
    [self setNeedsDisplay];
}

-(void)setAngle:(CGFloat)angle
{
    _angle = angle;
    
    [self setNeedsDisplay];
}


-(void)setWidth:(CGFloat)width
{
    _width = width;
    
    [self invalidateIntrinsicContentSize];
    [self setNeedsDisplay];
}

-(void)setIndicatorSize:(CGFloat)indicatorSize
{
    _indicatorSize = indicatorSize;
    
    [self invalidateIntrinsicContentSize];
    [self setNeedsDisplay];
}

-(void)setMargin:(CGFloat)margin
{
    _margin = margin;
    
    [self invalidateIntrinsicContentSize];
    [self setNeedsDisplay];
}

-(void)setColors:(NSArray<UIColor *> *)colors
{
    _colors = colors;
    
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    const CGFloat minAQI = self.minAQI;
    const CGFloat maxAQI = self.maxAQI;
    
    const CGSize size = self.bounds.size;
    const CGFloat margin = self.margin;
    const CGFloat indicatorSize = self.indicatorSize;
    const CGFloat R0 = MAX(0, MIN(size.width, size.height)/2 - margin - indicatorSize); //outer radius
    const CGFloat R1 = MAX(0, R0 - self.width); //inner radius
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, size.width/2, size.height/2); //move center to: (width/2, height/2)
    CGContextScaleCTM(context, 1, -1); //flip y- axis

    const CGFloat x0 = 0; //center point
    const CGFloat y0 = 0;
    const CGFloat angle = self.angle * M_PI/180; //in radians
    const CGFloat halfAngle = angle / 2;
    const CGFloat remainingAngle = 2*M_PI - angle;
    const NSUInteger numColorSegments = [self.colors count];
    
    const CGFloat angle0 = (1.5*M_PI - halfAngle); //270-angle/2
    CGFloat segmentAngle0 = angle0;
    CGFloat segmentAngleStep = remainingAngle / numColorSegments;
    
    // Draw colors segments
    CGContextSetLineWidth(context, 1);
    for(int i=0; i<numColorSegments; i++){
        CGFloat segmentAngle1 = segmentAngle0 - segmentAngleStep;
        CGContextAddArc(context, x0, y0, R0, segmentAngle0, segmentAngle1, true); //clockwise
        CGContextAddArc(context, x0, y0, R1, segmentAngle1, segmentAngle0, false); //anti-closewise
        CGContextClosePath(context);
        UIColor *color = [self.colors objectAtIndex:i];
        CGContextSetStrokeColorWithColor(context, [color CGColor]);
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        const BOOL drawUnitsAroundCircle = NO;
        if(drawUnitsAroundCircle && i != 0){
            CGContextSaveGState(context);
            const CGFloat aqiStep = (maxAQI-minAQI) / numColorSegments;
            NSString *unitString = [@(minAQI + aqiStep * i) stringValue];
            
            CGContextRotateCTM(context, segmentAngle0);
            CGContextScaleCTM(context, 1, -1);
            NSDictionary *unitAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName: [UIColor grayColor]};
            [unitString drawAtPoint:CGPointMake(R0, 0) withAttributes:unitAttributes];
            CGContextRestoreGState(context);
        }
        segmentAngle0 -= segmentAngleStep;
    }
    
    // Draw AQI value
    if(_aqi != nil){
        const CGFloat a = 0.707*R1; //inner rectange inside the inner circle
        
        const NSString *aqiString = [_aqi stringValue];
        const CGFloat desiredAQIFontSize = 48;
        const CGFloat minAQIFontSize = 7;
        //adjust font size so that: fontSize.width < 2*a && fontSize.height < 2*a
        CGFloat fontSize = desiredAQIFontSize;
        CGSize textSizeAQI;
        NSDictionary *attributesAQI;
        do{
            attributesAQI = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:fontSize]};
            textSizeAQI = [aqiString sizeWithAttributes:attributesAQI];
            fontSize -= 1.0;
        }while(fontSize>minAQIFontSize && (textSizeAQI.width>2*a || textSizeAQI.height>2*a));
        
        CGContextScaleCTM(context, 1, -1); //y- flip text
        const UIColor *textColor = ({ //find color within which AQI is in.
            const CGFloat aqiStep = (maxAQI-minAQI) / numColorSegments;
            NSInteger segmentOfAQI = MIN([_aqi intValue]/aqiStep, numColorSegments-1);
            self.colors[segmentOfAQI];
        });
        
        [aqiString drawAtPoint:CGPointMake(x0-textSizeAQI.width/2, y0-textSizeAQI.height/2) withAttributes:
         @{NSFontAttributeName: [UIFont boldSystemFontOfSize:fontSize], NSForegroundColorAttributeName: textColor}];

        if(_quality != nil){
            NSDictionary *attributesQuality = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName: [UIColor lightGrayColor]};
            CGSize textSizeQuality = [_quality sizeWithAttributes:attributesQuality];
            CGFloat vPadding = 0;
            [_quality drawAtPoint:CGPointMake(x0-textSizeQuality.width/2, y0+textSizeAQI.height/2+textSizeQuality.height/2+vPadding) withAttributes:attributesQuality];
        }
        
        //draw indicator around outer circle
        {
            CGFloat aqi = MIN(MAX(minAQI, [_aqi floatValue]), maxAQI); //clamp to [minAQI, maxAQI]
            CGFloat A0 = (1.5*M_PI - halfAngle);
            CGFloat A1 = (-M_PI/2 + halfAngle);
            CGFloat indicatorAngleForAQI = (aqi - minAQI)/(maxAQI - minAQI) * (A1-A0) + A0;
            CGContextScaleCTM(context, 1, -1);
            CGContextRotateCTM(context, indicatorAngleForAQI);
            
            CGContextSetFillColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
            CGContextMoveToPoint(context, R0, 0);
            CGContextAddLineToPoint(context, R0 + indicatorSize, indicatorSize);
            CGContextAddLineToPoint(context, R0 + indicatorSize, -indicatorSize);
            CGContextClosePath(context);
            CGContextFillPath(context);
            
            CGContextMoveToPoint(context, R1, 0);
            CGContextAddLineToPoint(context, R1 - indicatorSize, indicatorSize);
            CGContextAddLineToPoint(context, R1 - indicatorSize, -indicatorSize);
            CGContextClosePath(context);
            CGContextFillPath(context);
        }
    }
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
