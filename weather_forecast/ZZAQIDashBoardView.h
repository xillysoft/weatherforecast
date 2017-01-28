//
//  ZZAQIDashBoardView2.h
//  weather_forecast
//
//  Created by zhaoxiaojian on 1/16/17.
//  Copyright © 2017 Zhao Xiaojian. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface ZZAQIDashBoardView : UIView

@property(nonatomic) IBInspectable CGFloat blankAngle; //default: M_PI/2
@property(nonatomic) IBInspectable CGFloat circleWidth; //default: 50.0

//test only, use -setAQI:quality:pm25:pm10 instead!
@property(nonatomic) IBInspectable CGFloat aqiValue; //must be within range from _minAQIValue to _maxAQIValue
@property(nonatomic) IBInspectable CGFloat aqiMarkSize; //default: 10.0

-(void)setAQI:(NSNumber *)aqiIndex quality:(NSString *)quality pm25:(NSString *)pm25 pm10:(NSString *)pm10;

@end
