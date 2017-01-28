//
//  ZZAQIDashBoardView2.m
//  weather_forecast
//
//  Created by zhaoxiaojian on 1/16/17.
//  Copyright © 2017 Zhao Xiaojian. All rights reserved.
//

#import "ZZAQIDashBoardView.h"
#import <CoreText/CoreText.h>

@interface ZZAQIDashBoardView() {
    CGFloat _minAQIValue;
    CGFloat _maxAQIValue;
}
@property NSArray<UIColor *> *colors;
@property CALayer *coloredSegmentLayer;

@property CAShapeLayer *aqiMarkLayer;
@property CATextLayer *aqiTextLayer;
@property CATextLayer *aqiQualityLayer;

@end


@implementation ZZAQIDashBoardView2

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self _initView];
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self _initView];
    return self;
}

-(void)_initView
{
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
    _circleWidth = 40.0; //initial circle width
    _blankAngle = M_PI/2; //initial blank angle (90 degrees)
    
    
    _minAQIValue = 0.0;
    _maxAQIValue = 500.0;
    _aqiMarkSize = _circleWidth / 3; //initial aqi mark size
    
//    self.layer.borderColor = [[UIColor grayColor] CGColor];
//    self.layer.borderWidth = 1.0;
    self.backgroundColor = [UIColor lightGrayColor];
    
    {//create coloredSegmentLayer
        self.coloredSegmentLayer = [CALayer layer];
        [self.layer addSublayer:self.coloredSegmentLayer];
        self.coloredSegmentLayer.shadowOpacity = 0.5;
        self.coloredSegmentLayer.shadowOffset = CGSizeMake(5, 5);
        self.coloredSegmentLayer.shadowRadius = 8;
//        self.coloredSegmentLayer.borderColor = [[UIColor blueColor] CGColor];
//        self.coloredSegmentLayer.borderWidth = 1.0;
        for(UIColor *color in self.colors){
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            [self.coloredSegmentLayer addSublayer:shapeLayer];
            shapeLayer.fillColor = [[UIColor clearColor] CGColor];
            shapeLayer.strokeColor = [color CGColor];
            shapeLayer.lineWidth = self.circleWidth;
//            shapeLayer.lineCap = kCALineCapRound;
            shapeLayer.contentsScale = [[UIScreen mainScreen] scale];

        }
    }

    {//create aqiMarkLayer
        self.aqiMarkLayer = [CAShapeLayer layer];
        [self.layer addSublayer:self.aqiMarkLayer];
        self.aqiMarkLayer.contentsScale = [[UIScreen mainScreen] scale];
        self.aqiMarkLayer.fillColor = [[UIColor darkGrayColor] CGColor];
//        self.aqiMarkLayer.borderColor = [[UIColor magentaColor] CGColor];
//        self.aqiMarkLayer.borderWidth = 1.5;
    }
    
    {//create aqiTextLayer
        self.aqiTextLayer = [CATextLayer layer];
        [self.layer addSublayer:self.aqiTextLayer];
        self.aqiTextLayer.alignmentMode = kCAAlignmentCenter;
        self.aqiTextLayer.contentsScale = [[UIScreen mainScreen] scale];
        CGFontRef font = CGFontCreateWithFontName((__bridge CFStringRef)[UIFont boldSystemFontOfSize:32].fontName);
        self.aqiTextLayer.font = font;
        self.aqiTextLayer.fontSize = 24;
        self.aqiTextLayer.foregroundColor = [[UIColor blueColor] CGColor];
        self.aqiTextLayer.borderColor = [[UIColor redColor] CGColor];
        self.aqiTextLayer.borderWidth = 0.25;
        
        self.aqiTextLayer.string = @"n/a";
    }
    {//create aqiQuality layer
        self.aqiQualityLayer = [CATextLayer layer];
        [self.layer addSublayer:self.aqiQualityLayer];
        self.aqiQualityLayer.alignmentMode = kCAAlignmentCenter;
        self.aqiQualityLayer.contentsScale = [[UIScreen mainScreen] scale];
        CGFontRef font = CGFontCreateWithFontName((__bridge CFStringRef)[UIFont boldSystemFontOfSize:16].fontName);
        self.aqiQualityLayer.font = font;
        self.aqiQualityLayer.fontSize = 16;
        self.aqiQualityLayer.foregroundColor = [[UIColor colorWithWhite:0.1 alpha:1.0] CGColor];
        self.aqiQualityLayer.borderColor = [[UIColor magentaColor] CGColor];
        self.aqiQualityLayer.borderWidth = 0.25;
        self.aqiQualityLayer.string = @"n/a";
    }
}

-(void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
//    NSLog(@"--ZZAQIDashBoardView2:: -layoutSublayersOfLayer! layer.frame=%@",NSStringFromCGRect(layer.frame));
    
    CGRect bounds = layer.bounds;
    
    
    CGRect circleFrame = bounds;
    circleFrame.size.width = MAX(0, MIN(bounds.size.width, bounds.size.height) - self.aqiMarkSize*2);
    circleFrame.size.height = circleFrame.size.width;
    circleFrame.origin.x = (bounds.size.width - circleFrame.size.width)/2;
    circleFrame.origin.y = (bounds.size.height - circleFrame.size.height)/2;
    
    [self _layoutColoredSegmentLayersWithFrame:circleFrame];
    [self _layoutAQIMarkLayerWithFrame:circleFrame];
    
    
    CGFloat aqiTextSize = (MIN(circleFrame.size.width, circleFrame.size.height) - self.circleWidth*2) * M_SQRT2/2; //0.707
    CGRect aqiTextFrame;
    aqiTextFrame.size.width = MAX(0, aqiTextSize);
//    aqiTextFrame.size.height = MAX(0, aqiTextSize);
    aqiTextFrame.size.height = ({
        CGFontRef font = (CGFontRef)self.aqiTextLayer.font;
        CGFloat fontSize = self.aqiTextLayer.fontSize;
        int units = CGFontGetUnitsPerEm(font);
        CGFloat fontHeight = fontSize*CGFontGetFontBBox(font).size.height/units;
        fontHeight;
    }); //only valid when CATextLayer.string is NOT of NSAttributedString
    aqiTextFrame.origin.x = (bounds.size.width - aqiTextFrame.size.width)/2;
    aqiTextFrame.origin.y = (bounds.size.height - aqiTextFrame.size.height)/2;
    [self _layoutAQITextLayerWithFrame:aqiTextFrame];
    
    CGRect aqiQualityFrame;
    aqiQualityFrame.size.width = aqiTextFrame.size.width;
    aqiQualityFrame.size.height = self.circleWidth;
    aqiQualityFrame.origin.x = aqiTextFrame.origin.x;
    aqiQualityFrame.origin.y = aqiTextFrame.origin.y+aqiTextFrame.size.height;
    [self _layoutAQIQualityLayerWithFrame:aqiQualityFrame];
}

-(void)setAQI:(NSNumber *)aqiIndex quality:(NSString *)quality pm25:(NSString *)pm25 pm10:(NSString *)pm10
{
    CGFloat aqiValue = [aqiIndex floatValue];
//    NSLog(@"--ZZAQIDashBoardView:: setAQI:%@ quality:pm25:pm10:!", @(aqiValue));
    
    _aqiValue = aqiValue;
    //set AQI text
    {//TODO: animate aqi value
        NSString *aqiValueString = [NSString stringWithFormat:@"%.0f", aqiValue];
        self.aqiTextLayer.string = aqiValueString;
    }
    {
        self.aqiQualityLayer.string = quality;
    }
    //animate AQI value for AQI mark layer
    [self _animateAQIMark:aqiValue];
}

-(void)setCircleWidth:(CGFloat)circleWidth
{
    _circleWidth = circleWidth;
    [self layoutSublayersOfLayer:self.layer];
}

-(void)setBlankAngle:(CGFloat)blankAngle
{
    _blankAngle = blankAngle;
    [self layoutSublayersOfLayer:self.layer];
}

-(void) _layoutColoredSegmentLayersWithFrame:(CGRect)frame
{
    self.coloredSegmentLayer.frame = frame;
    
    NSUInteger numColors = [self.colors count];
    CGPoint center = CGPointMake(frame.size.width/2, frame.size.height/2);
    CGFloat radius = MIN(frame.size.width, frame.size.height)/2 - self.circleWidth/2;
    CGFloat remainingAngle = 2*M_PI - self.blankAngle; //360-A/2
    CGFloat deltaAngle = remainingAngle / numColors;
    CGFloat startAngle0 = M_PI/2 + self.blankAngle/2; //M_PI/2 + A/2
    for(NSUInteger i=0; i<numColors; i++){
//        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//        [self.coloredSegmentLayer addSublayer:shapeLayer];
        CAShapeLayer *shapeLayer = (CAShapeLayer *) [[self.coloredSegmentLayer sublayers] objectAtIndex:i];
        shapeLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height); //adapt when size changed
        shapeLayer.path = ({
            CGFloat startAngle = startAngle0 + i*deltaAngle;
            CGFloat endAngle = startAngle + deltaAngle;
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
            [path CGPath];
        });
    }
}

-(void) _layoutAQIMarkLayerWithFrame:(CGRect)frame
{
    self.aqiMarkLayer.frame = frame;
    CGFloat x0 = frame.size.width/2;
    CGFloat y0 = frame.size.height/2;
//    CGFloat R0 = MIN(frame.size.width, frame.size.height)/2 - 2*self.aqiMarkSize;
    CGFloat R0 = MIN(frame.size.width, frame.size.height)/2;
    CGFloat R1 = R0 - self.circleWidth;

    self.aqiMarkLayer.path = ({
        UIBezierPath *path = [UIBezierPath bezierPath];
        CGFloat remainingAngle = 2*M_PI - self.blankAngle;
        CGFloat A0 = M_PI/2 + self.blankAngle/2;
        CGFloat A1 = A0 + remainingAngle;
        CGFloat Q0 = _minAQIValue;
        CGFloat Q1 = _maxAQIValue;
//        CGFloat q = self.aqiValue;
        CGFloat q = Q0; //initial AQI mark position
        CGFloat a = (q-Q0)/(Q1-Q0) * (A1-A0) + A0;  //calculate a from q, a∈[A0, A1]
        CGFloat angle = a;
        [path moveToPoint:CGPointMake(x0 + R0*cos(angle), y0 + R0*sin(angle))];
        CGFloat S = self.aqiMarkSize;
        CGFloat R01 = R0 + S;
//        CGFloat B1 = atan(S*tan(30.0*M_PI/180) / R01);
        CGFloat B1 = atan(S / R01);
        [path addLineToPoint:CGPointMake(x0 + R01*cos(angle+B1), y0 + R01*sin(angle+B1))];
        [path addLineToPoint:CGPointMake(x0 + R01*cos(angle-B1), y0 + R01*sin(angle-B1))];
        [path closePath];
        
        [path moveToPoint:CGPointMake(x0 + R1*cos(angle), y0 + R1*sin(angle))];
        CGFloat R11 = R1 - S;
        CGFloat B2 = atan(S / R11);
        [path addLineToPoint:CGPointMake(x0 + R11*cos(angle+B2), y0+R11*sin(angle+B2))];
        [path addLineToPoint:CGPointMake(x0 + R11*cos(angle-B2), y0+R11*sin(angle-B2))];
        [path closePath];
        
        [path CGPath];
    });
}

-(void) _layoutAQITextLayerWithFrame:(CGRect)frame
{
//    NSLog(@"--ZZAQIDashBoardView2:: _rebuildAQITextLayerWithFrame:%@!", NSStringFromCGRect(frame));
    self.aqiTextLayer.frame = frame;

}

-(void) _layoutAQIQualityLayerWithFrame:(CGRect)frame
{
    self.aqiQualityLayer.frame = frame;
}

-(void) _animateAQIMark:(CGFloat)aqiValue
{
    CGFloat remainingAngle = 2*M_PI - self.blankAngle;
//    CGFloat A0 = 0;
    CGFloat A1 = remainingAngle;
    CGFloat Q0 = _minAQIValue;
    CGFloat Q1 = _maxAQIValue;
    CGFloat angle = (aqiValue-Q0)/(Q1-Q0) * A1;  //calculate angle from q, a∈[A0, A1], q∈[minAQI, maxAQI]
    angle = MAX(0, MIN(angle, A1));
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    anim.values = ({
        NSArray<NSNumber *> *angleRatios = @[@(0.0), @(0.15), @(0.25), @(0.5), @(0.75), @(1.35), @(0.65), @(1.25), @(0.75), @(1.15), @(0.85), @(1.05), @(0.97), @(1.03), @(0.99), @(1.01), @(1.0)];
        NSMutableArray<id> *transforms = [NSMutableArray array];
        for(NSNumber *a in angleRatios){
            CGFloat angleRatio = [a floatValue];
            [transforms addObject:@(angleRatio*angle)];
        }
        transforms;
    });
    anim.duration = 0.6;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
//    anim.delegate = self;
    [self.aqiMarkLayer addAnimation:anim forKey:@"transform"];

//    NSLog(@"--ZZAQIDashBoardView2:: _animateAQIMark:! aqiValue=%@, angle=%@", @(aqiValue), @(angle*180/M_PI));
    
}

@end
