//
//  ZZAQIDashBoardView2.m
//  weather_forecast
//
//  Created by zhaoxiaojian on 1/16/17.
//  Copyright © 2017 Zhao Xiaojian. All rights reserved.
//

#import "ZZAQIDashBoardView2.h"

@interface ZZAQIDashBoardView2(){
    CGFloat _minAQIValue;
    CGFloat _maxAQIValue;
}
@property NSArray<UIColor *> *colors;
@property CALayer *coloredSegmentLayer;

@property CAShapeLayer *aqiMarkLayer;

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
    self.circleWidth = 50.0; //initial circle width
    self.blankAngle = M_PI/2; //initial blank angle (90 degrees)
    
    _minAQIValue = 0.0;
    _maxAQIValue = 500.0;
    self.aqiMarkSize = 15.0; //initial aqi mark size

    
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.layer.borderWidth = 1.0;
}
-(void)layoutSublayersOfLayer:(CALayer *)layer
{
    CGRect bounds = layer.bounds;
    
    CGRect circleFrame = CGRectMake(self.aqiMarkSize, self.aqiMarkSize, bounds.size.width-self.aqiMarkSize*2, bounds.size.height-self.aqiMarkSize*2);
    [self _rebuildColoredSegmentLayersWithFrame:circleFrame]; //TODO: subtract outer triangle mark from bounds
    [self _rebuildAQIMarkLayerWithFrame:circleFrame];

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

-(void)setAqiValue:(CGFloat)aqiValue
{
    _aqiValue = aqiValue;
    [self layoutSublayersOfLayer:self.layer];
}
-(void) _rebuildColoredSegmentLayersWithFrame:(CGRect)frame
{
    if(self.coloredSegmentLayer){
        [self.coloredSegmentLayer removeFromSuperlayer];
    }
    self.coloredSegmentLayer = [CALayer layer];
    self.coloredSegmentLayer.frame = frame;
    [self.layer addSublayer:self.coloredSegmentLayer];
    self.coloredSegmentLayer.shadowOpacity = 0.5;
    self.coloredSegmentLayer.shadowOffset = CGSizeMake(5, 5);
    self.coloredSegmentLayer.shadowRadius = 8;
    
    NSUInteger numColors = [self.colors count];
    CGPoint center = CGPointMake(frame.size.width/2, frame.size.height/2);
    CGFloat radius = MIN(frame.size.width, frame.size.height)/2 - self.circleWidth/2;
    CGFloat remainingAngle = 2*M_PI - self.blankAngle; //360-A/2
    CGFloat deltaAngle = remainingAngle / numColors;
    CGFloat startAngle0 = M_PI/2 + self.blankAngle/2; //M_PI/2 + A/2
    for(NSUInteger i=0; i<numColors; i++){
        UIColor *color = [self.colors objectAtIndex:i];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.contentsScale = [[UIScreen mainScreen] scale];
        [self.coloredSegmentLayer addSublayer:shapeLayer];
        shapeLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height); //adapt when size changed
        CGFloat startAngle = startAngle0 + i*deltaAngle;
        CGFloat endAngle = startAngle + deltaAngle;
        shapeLayer.path = ({
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
            [path CGPath];
        });
        shapeLayer.fillColor = [[UIColor clearColor] CGColor];
        shapeLayer.strokeColor = [color CGColor];
        shapeLayer.lineWidth = self.circleWidth;
//        shapeLayer.lineCap = kCALineCapRound;
    }
}

-(void)_rebuildAQIMarkLayerWithFrame:(CGRect)frame
{
    if(self.aqiMarkLayer){
        [self.aqiMarkLayer removeFromSuperlayer];
    }
    self.aqiMarkLayer = [CAShapeLayer layer];
    self.aqiMarkLayer.frame = frame;
    [self.layer addSublayer:self.aqiMarkLayer];
    self.aqiMarkLayer.contentsScale = [[UIScreen mainScreen] scale];
    CGFloat x0 = frame.size.width/2;
    CGFloat y0 = frame.size.height/2;
    CGFloat R0 = MIN(frame.size.width, frame.size.height)/2;
    CGFloat R1 = R0 - self.circleWidth;

    self.aqiMarkLayer.path = ({
        UIBezierPath *path = [UIBezierPath bezierPath];
        CGFloat remainingAngle = 2*M_PI - self.blankAngle;
        CGFloat A0 = M_PI/2 + self.blankAngle/2;
        CGFloat A1 = A0 + remainingAngle;
        CGFloat Q0 = _minAQIValue;
        CGFloat Q1 = _maxAQIValue;
        CGFloat q = self.aqiValue;
        CGFloat a = (q-Q0)/(Q1-Q0) * (A1-A0) + A0;        
        CGFloat angle = a;
        [path moveToPoint:CGPointMake(x0 + R0*cos(angle), y0 + R0*sin(angle))];
        CGFloat S = self.aqiMarkSize;
        CGFloat R01 = R0 + S;
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
    self.aqiMarkLayer.fillColor = [[UIColor grayColor] CGColor];
//    self.aqiMarkLayer.strokeColor = [[UIColor redColor] CGColor];
}

@end
