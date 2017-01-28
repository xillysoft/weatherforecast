//
//  ZZWeatherForecastView.m
//  weather_forecast
//
//  Created by zhaoxiaojian on 1/20/17.
//  Copyright © 2017 Zhao Xiaojian. All rights reserved.
//

#import "ZZWeatherForecastGraphView.h"
@interface ZZWeatherForecastGraphView()

//the "background" gradient colored layer "masked" by high/low temperature shape layer.
@property CAGradientLayer *highGradientLayer;
@property CAGradientLayer *lowGradientLayer;

//the high/low temperature shape layer is the "masks" of high/low gradient layer
@property CAShapeLayer *highTempShapeLayer;
@property CAShapeLayer *lowTempShapeLayer;
@property NSMutableArray<CALayer *> *conditionImageLayers;

@property NSArray *dailyForecast;

@property CAShapeLayer *gridLayer;

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
    
    self.highGradientLayer = ({
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = ({
            CGColorRef color1 = [[UIColor redColor] CGColor];
            CGColorRef color2 = [[UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0] CGColor];
            CGColorRef color3 = [[UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:1.0] CGColor];
            @[(__bridge id)color1, (__bridge id)color2, (__bridge id)color3];
        });
        gradientLayer.startPoint = CGPointMake(0.5, 0.0);
        gradientLayer.endPoint = CGPointMake(0.5, 1.0);
        gradientLayer;
    });
    [self.layer addSublayer:self.highGradientLayer];
    
    self.lowGradientLayer = ({
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = ({
            CGColorRef color1 = [[UIColor colorWithRed:0.0 green:0.75 blue:0.25 alpha:1.0] CGColor];
            CGColorRef color2 = [[UIColor colorWithRed:0.2 green:1.0 blue:0.2 alpha:1.0] CGColor];
            @[(__bridge id)color1, (__bridge id)color2];
        });
        gradientLayer.startPoint = CGPointMake(0.5, 0.0);
        gradientLayer.endPoint = CGPointMake(0.5, 1.0);
        gradientLayer;
    });
    [self.layer addSublayer:self.lowGradientLayer];
    
    self.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.layer.borderWidth = 1.0;
    
    self.highTempShapeLayer = [CAShapeLayer layer];
    //    [self.layer addSublayer:self.highTemperatureLayer];
    self.highGradientLayer.mask = self.highTempShapeLayer;
    self.highTempShapeLayer.fillColor = [[UIColor whiteColor] CGColor]; //for mask-use only (with its shape), only alpha channel is used.
    self.highTempShapeLayer.strokeColor = [[UIColor lightGrayColor] CGColor];
    self.highTempShapeLayer.lineDashPattern = @[@(1.0), @(0.0)];
    
    self.lowTempShapeLayer = [CAShapeLayer layer];
    //    [self.layer addSublayer:self.lowTemperatureLayer];
    self.lowGradientLayer.mask = self.lowTempShapeLayer;
    self.lowTempShapeLayer.fillColor = [[UIColor whiteColor] CGColor]; //for mask-use only (with its shape), only alpha channel is used for mask.

    self.gridLayer = [CAShapeLayer layer];
    [self.layer addSublayer:self.gridLayer];
    self.gridLayer.strokeColor = [[UIColor lightGrayColor] CGColor];
    self.gridLayer.fillColor = [[UIColor clearColor] CGColor];
}

-(void)layoutSublayersOfLayer:(CALayer *)layer
{
    CGFloat marginTop = 10.0;
    CGFloat marginBottom = 0.0;
    CGFloat marginLeft = 50.0;
    CGFloat marginRigth = 5.0;
    
    marginTop = 80;/////TODO: remove it!
    marginBottom = layer.bounds.size.height-marginTop-120; //TODO: remove it!
    
    CGRect frame1 = layer.bounds;
    frame1.origin.y = marginTop;
    frame1.origin.x = marginLeft;
    frame1.size.height -= marginTop+marginBottom;
    frame1.size.width -= marginLeft+marginRigth;
    
    [self _layoutTemperatureLayers:frame1];
}

-(void)_layoutTemperatureLayers:(CGRect)frame
{
    self.highGradientLayer.frame = frame;
    self.lowGradientLayer.frame = frame;
    self.gridLayer.frame = frame;
    self.gridLayer.path = ({
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.gridLayer.bounds];
        [path CGPath];
    });
    
    //the high/low temperature shape layer is used as "mask" of high/low gradient layer.
    self.highTempShapeLayer.frame = self.highGradientLayer.bounds;
    self.lowTempShapeLayer.frame = self.lowTempShapeLayer.bounds;
    
    if(self.dailyForecast){
        [self showDailyForecastAnimated:YES];
    }
}

-(void)showDailyForecastAnimated:(BOOL)animated
{
    NSArray *dailyForecast = self.dailyForecast;
    CGRect bounds = self.highTempShapeLayer.bounds;
    
    //find the highest and lowest temperature in the daily forecast array
    CGFloat tempHighest = NSIntegerMin; //within high temperatures
    CGFloat tempLowest = NSIntegerMax; //within low temperatures
    CGFloat minTempHigh = NSUIntegerMax;
    CGFloat maxTempLow = NSIntegerMin;
    for(int i=0; i<[self.dailyForecast count]; i++){
        NSInteger tempHigh = [[[self.dailyForecast[i] objectForKey:@"tmp"] objectForKey:@"max"] floatValue];
        NSInteger tempLow = [[[self.dailyForecast[i] objectForKey:@"tmp"] objectForKey:@"min"] floatValue];
        if(tempHighest < tempHigh)
            tempHighest = tempHigh;
        if(tempLowest > tempLow)
            tempLowest = tempLow;
        
        if(minTempHigh > tempHigh)
            minTempHigh = tempHigh;
        if(maxTempLow < tempLow)
            maxTempLow = tempLow;
    }
    
    
    //highGradientLayer has 3 colors (highGradientLayer.colors)
    self.highGradientLayer.locations = @[@(0.0), [NSNumber numberWithFloat:(minTempHigh-tempHighest)/(tempLowest-tempHighest)], @(1.0)];
    //lowGradientLayer has 2 colors
    self.lowGradientLayer.locations = @[[NSNumber numberWithFloat:1.0-(maxTempLow-tempLowest)/(tempHighest-tempLowest)], @(1.0)];
    
    NSUInteger numDays = [dailyForecast count];
    UIBezierPath *pathHighTemp = [UIBezierPath bezierPath];
    UIBezierPath *pathLowTemp = [UIBezierPath bezierPath];
    
//    NSLog(@"--tempHighest=%.0f, minTempHigh=%.0f, maxTempLow=%.0f, tempLowest=%.0f",tempHighest, minTempHigh, maxTempLow, tempLowest);

    CGFloat yPadding = 32; //take into acount of condImageSize-->condImageY
    const CGFloat yHigh = yPadding;
    const CGFloat yLow = bounds.size.height - yPadding;
    
    if(self.conditionImageLayers){
        for(CALayer *condImageLayer in self.conditionImageLayers){
            [condImageLayer removeFromSuperlayer];
        }
    }
    self.conditionImageLayers = [NSMutableArray arrayWithCapacity:numDays];
    
    NSMutableArray<NSNumber *> *yTempHighs = [NSMutableArray arrayWithCapacity:numDays];
    NSMutableArray<NSNumber *> *yTempLows = [NSMutableArray arrayWithCapacity:numDays];
    for(NSUInteger i=0; i<numDays; i++){
        CGFloat x = (CGFloat)i / (numDays-1) * bounds.size.width;

        NSDictionary *dayForecast = dailyForecast[i];
        NSString *dateString2 = ({
            NSString *dateString = [dayForecast objectForKey:@"date"];
            NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
            [formatter1 setDateFormat:@"yyyy-MM-dd"];
            NSDate *forecastDate = [formatter1 dateFromString:dateString];
            NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
            [formatter2 stringFromDate:forecastDate];
        });

        CGFloat tempHigh = [[[self.dailyForecast[i] objectForKey:@"tmp"] objectForKey:@"max"] floatValue];
        CGFloat tempLow = [[[self.dailyForecast[i] objectForKey:@"tmp"] objectForKey:@"min"] floatValue];
        
//        NSLog(@"--[day %d]: %.0f-->%.0f", i, tempHigh, tempLow);
        CGFloat yTempHigh = (CGFloat)(tempHigh-tempLowest)/(tempHighest-tempLowest) * (yHigh-yLow) + yLow;
        CGFloat yTempLow = (CGFloat)(tempLow-tempLowest)/(tempHighest-tempLowest) * (yHigh-yLow) + yLow;
        yTempHighs[i] = [NSNumber numberWithFloat:yTempHigh];
        yTempLows[i] = [NSNumber numberWithFloat:yTempLow];
        
        CGPoint pointHighTemp = CGPointMake(x, yTempHigh);
        CGPoint pointLowTemp = CGPointMake(x, yTempLow);
        if(i==0){//first point
            [pathHighTemp moveToPoint:pointHighTemp];
            [pathLowTemp moveToPoint:pointLowTemp];
        }else{
            [pathHighTemp addLineToPoint:pointHighTemp];
            [pathLowTemp addLineToPoint:pointLowTemp];
        }
        
        {//show condition image on each point
            UIImage *condImage = ({
                NSString *cond_code_d = [[dayForecast objectForKey:@"cond"] objectForKey:@"code_d"];
                NSString *condImagePath = [[NSBundle mainBundle] pathForResource:cond_code_d ofType:@"png"];
                [UIImage imageNamed:condImagePath];
            });
            self.conditionImageLayers[i] = [CALayer layer];
            [self.layer addSublayer:self.conditionImageLayers[i]];
            const CGFloat condImageSize = 32;
            self.conditionImageLayers[i].position = ({
                CGFloat condImageX = i==0 ? x+condImageSize/2 : (i==numDays-1 ? x-condImageSize/2 : x);
                CGFloat condImageY = yTempHigh-condImageSize/2;
                CGPoint condImagePosition0 = CGPointMake(condImageX, condImageY);
                [self.layer convertPoint:condImagePosition0 fromLayer:self.highGradientLayer];
            });
            self.conditionImageLayers[i].bounds = CGRectMake(0, 0, condImageSize, condImageSize);
            self.conditionImageLayers[i].backgroundColor = [[UIColor darkGrayColor] CGColor]; //use as "tint color"
//            self.conditionImageLayers[i].contents = (__bridge id)[condImage CGImage];
            self.conditionImageLayers[i].mask = ({
                CALayer *mask = [CALayer layer];
                mask.contents = (__bridge id)[[condImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] CGImage];
                mask;
            });
            self.conditionImageLayers[i].mask.frame = self.conditionImageLayers[i].bounds;
        }
    }
    
    {//close the path
        [pathHighTemp addLineToPoint:CGPointMake(bounds.size.width, bounds.size.height)];
        [pathHighTemp addLineToPoint:CGPointMake(0, bounds.size.height)];
        [pathLowTemp addLineToPoint:CGPointMake(bounds.size.width, bounds.size.height)];
        [pathLowTemp addLineToPoint:CGPointMake(0, bounds.size.height)];
    }
    
    //set path of the shape
    self.highTempShapeLayer.path = [pathHighTemp CGPath];
    self.lowTempShapeLayer.path = [pathLowTemp CGPath];
    
    self.highTempShapeLayer.strokeColor = [[UIColor redColor] CGColor];
    self.lowTempShapeLayer.strokeColor = [[UIColor blueColor] CGColor];
//    self.highTemperatureLayer.fillColor = [[UIColor colorWithRed:0.75 green:0.25 blue:0 alpha:0.5] CGColor];
//    self.lowTemperatureLayer.fillColor = [[UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.5] CGColor];
    self.highTempShapeLayer.lineWidth = 2.0;
    self.lowTempShapeLayer.lineWidth = 2.0;
    
    self.gridLayer.path = ({
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:bounds];
        CGFloat yTempHigh0 = [[yTempHighs objectAtIndex:0] floatValue];
        CGFloat yTempLow0 = [[yTempLows objectAtIndex:0] floatValue];
        [path moveToPoint:CGPointMake(0, yTempHigh0)];
        [path addLineToPoint:CGPointMake(bounds.size.width, yTempHigh0)];
        [path moveToPoint:CGPointMake(0, yTempLow0)];
        [path addLineToPoint:CGPointMake(bounds.size.width, yTempLow0)];
        [path CGPath];
    });
}

-(void)setWeatherDailyForecastData:(NSArray *)dailyForecast;
{
    self.dailyForecast = dailyForecast;
    [self showDailyForecastAnimated:YES];
}

@end
