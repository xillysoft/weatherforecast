//
//  ZZWeatherDayForecastView.h
//  weather_forecast
//
//  Created by zhaoxiaojian on 11/1/16.
//  Copyright © 2016 Zhao Xiaojian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZWeatherDayForecastView : UIView

-(void)setForecastDate:(NSDate *)date;

-(void)setConditionDayCode:(NSString *)dayCode
                    dayText:(NSString *)dayText
                  nightCode:(NSString *)nightCode
                  nightText:(NSString *)nightText;

-(void)setTemperatureMax:(NSNumber *)maxTemp min:(NSNumber *)minTemp;

-(void)setWindDir:(NSString *)windDir SC:(NSString *)windSC;

@end
