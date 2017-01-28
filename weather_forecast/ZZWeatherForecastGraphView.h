//
//  ZZWeatherForecastView.h
//  weather_forecast
//
//  Created by zhaoxiaojian on 1/20/17.
//  Copyright © 2017 Zhao Xiaojian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZWeatherDataProvider.h"

@interface ZZWeatherForecastGraphView : UIView
-(void)setWeatherDailyForecastData:(NSArray *)dailyForecast;
@end
