//
//  ZZForecastView.h
//  weather_forecast
//
//  Created by zhaoxiaojian on 11/4/16.
//  Copyright © 2016 Zhao Xiaojian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZForecastView : UIView

/*!
 * the date the forecast is last updated
 */
-(void)setForecastDate:(NSDate *)date;

/*!
 * nightCode, nightText may be nil.
 */
-(void)setConditionDayCode:(NSString *)dayCode
                   dayText:(NSString *)dayText
                 nightCode:(NSString *)nightCode
                 nightText:(NSString *)nightText;

/*!
 * hight temperature, low temperature
 */
-(void)setTemperatureMax:(NSNumber *)maxTemp min:(NSNumber *)minTemp;

/*!
 * wind direction, scale, speed(kMPH)
 */
-(void)setWindDir:(NSString *)windDir scale:(NSString *)windSC speed:(NSNumber *)windSpd;

/*!
 * probability of precipitation
 */
-(void)setPoP:(NSNumber *)pop;

/*!
 * humidity %
 */
-(void)setHumidity:(NSNumber *)humidity;


@end
