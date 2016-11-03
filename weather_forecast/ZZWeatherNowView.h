//
//  ZZWeatherNowView.h
//  weather_forecast
//
//  Created by zhaoxiaojian on 10/28/16.
//  Copyright © 2016 Zhao Xiaojian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZWeatherNowView : UIView

-(void)setLastUpdated:(NSDate *)date;
-(void)setWeatherConditionText:(NSString *)text code:(NSString *)code;
-(void)setWeatherTemperature:(NSNumber *)temp;
-(void)setWeatherWindDir:(NSString *)dir SC:(NSString *)sc;

-(void)setAQI:(NSNumber *)aqiIndex quality:(NSString *)quality pm25:(NSString *)pm25 pm10:(NSString *)pm10;

@end
