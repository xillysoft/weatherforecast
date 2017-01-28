//
//  ZZWeatherForecastView.m
//  weather_forecast
//
//  Created by zhaoxiaojian on 1/20/17.
//  Copyright © 2017 Zhao Xiaojian. All rights reserved.
//

#import "ZZWeatherForecastGraphView.h"
@interface ZZWeatherForecastGraphView()

@property CAShapeLayer *highTemperatureLayer;
@property CAShapeLayer *lowTemperatureLayer;

@property NSArray *dailyForecast;
@end


@implementation ZZWeatherForecastGraphView
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
    self.highTemperatureLayer = [CAShapeLayer layer];
    [self.layer addSublayer:self.highTemperatureLayer];
    
    self.lowTemperatureLayer = [CAShapeLayer layer];
    [self.layer addSublayer:self.lowTemperatureLayer];
}

-(void)layoutSublayersOfLayer:(CALayer *)layer
{
    CGFloat marginTop = 10.0;
    CGFloat marginBottom = 0.0;
    CGFloat marginLeft = 5.0;
    CGFloat marginRigth = marginLeft;
    CGRect frame = layer.bounds;
    frame.origin.y = marginTop;
    frame.origin.x = marginLeft;
    frame.size.height -= marginTop+marginBottom;
    frame.size.width -= marginLeft+marginRigth;
    
    [self _layoutTemperatureLayers:frame];
}

-(void)_layoutTemperatureLayers:(CGRect)frame
{
    self.highTemperatureLayer.frame = frame;
    self.lowTemperatureLayer.frame = frame;
    if(self.dailyForecast){
        [self showDailyForecast:self.dailyForecast];
    }
}

-(void)showDailyForecast:(NSArray *)dailyForecast
{
    CGRect bounds = self.highTemperatureLayer.bounds;
    
    //find the highest and lowest temperature in the daily forecast array
    NSInteger tempHighest = NSIntegerMin; //within high temperatures
    NSInteger tempLowest = NSIntegerMax; //within low temperatures
    for(int i=0; i<[self.dailyForecast count]; i++){
        NSInteger tempHigh = [[[self.dailyForecast[i] objectForKey:@"tmp"] objectForKey:@"max"] integerValue];
        NSInteger tempLow = [[[self.dailyForecast[i] objectForKey:@"tmp"] objectForKey:@"min"] integerValue];
        if(tempHighest < tempHigh)
            tempHighest = tempHigh;
        if(tempLowest > tempLow)
            tempLowest = tempLow;
    }
    NSUInteger numDays = [dailyForecast count];
    UIBezierPath *pathHighTemp = [UIBezierPath bezierPath];
    UIBezierPath *pathLowTemp = [UIBezierPath bezierPath];
    
    
    for(NSUInteger i=0; i<numDays; i++){
        CGFloat x = (CGFloat)i / (numDays-1) * bounds.size.width;
        
        NSInteger tempHigh = [[[self.dailyForecast[i] objectForKey:@"tmp"] objectForKey:@"max"] integerValue];
        NSInteger tempLow = [[[self.dailyForecast[i] objectForKey:@"tmp"] objectForKey:@"min"] integerValue];
        CGFloat yTempHigh = (tempHigh-tempLowest)/(tempHighest-tempLowest) * bounds.size.height;
        CGFloat yTempLow = (tempLow-tempLowest)/(tempHighest-tempLowest) * bounds.size.height;
        if(i==0){
            [pathHighTemp moveToPoint:CGPointMake(x, yTempHigh)];
            [pathLowTemp moveToPoint:CGPointMake(x, yTempLow)];
        }
        [pathHighTemp addLineToPoint:CGPointMake(x, yTempHigh)];
        [pathLowTemp addLineToPoint:CGPointMake(x, yTempLow)];
    
    }
    {//close the path
        [pathHighTemp addLineToPoint:CGPointMake(bounds.size.width, bounds.size.height)];
        [pathHighTemp addLineToPoint:CGPointMake(0, bounds.size.height)];
        [pathLowTemp addLineToPoint:CGPointMake(bounds.size.width, bounds.size.height)];
        [pathLowTemp addLineToPoint:CGPointMake(0, bounds.size.height)];
    }
    self.highTemperatureLayer.path = [pathHighTemp CGPath];
    self.lowTemperatureLayer.path = [pathLowTemp CGPath];
    
    self.highTemperatureLayer.strokeColor = [[UIColor redColor] CGColor];
    self.lowTemperatureLayer.strokeColor = [[UIColor blueColor] CGColor];
    self.highTemperatureLayer.fillColor = [[UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.5] CGColor];
    self.lowTemperatureLayer.fillColor = [[UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.5] CGColor];
    self.highTemperatureLayer.lineWidth = 2.0;
    self.lowTemperatureLayer.lineWidth = 2.0;
}

-(void)weatherDataDidReceivDaylyForecast:(NSArray *)dailyForecast sender:(ZZWeatherDataProvider *)sender
{
    self.dailyForecast = dailyForecast;
    [self showDailyForecast:dailyForecast];
}

@end
