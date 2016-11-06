//
//  ZZForecastView.h
//  weather_forecast
//
//  Created by zhaoxiaojian on 11/4/16.
//  Copyright © 2016 Zhao Xiaojian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZCircleView.h"

@interface ZZForecastView : UIView

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UILabel *leftDateUpper;
@property (weak, nonatomic) IBOutlet UILabel *leftDateLower;

@property (weak, nonatomic) IBOutlet ZZCircleView *circleView;
@property (weak, nonatomic) IBOutlet UIImageView *conditionImageView;
@property (weak, nonatomic) IBOutlet UILabel *tempHighLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempSeperatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLowLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionTxtLabel;
@property (weak, nonatomic) IBOutlet UILabel *windScaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *windDirLabel;
@property (weak, nonatomic) IBOutlet UILabel *poPLabel;

@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconWindImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconPoPImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconHumidityImageView;

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
