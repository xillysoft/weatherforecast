//
//  ZZWeatherNowView.h
//  weather_forecast
//
//  Created by zhaoxiaojian on 10/28/16.
//  Copyright © 2016 Zhao Xiaojian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZWeatherNowView : UIView
@property(readwrite, nonatomic) NSString *weatherConditionText;
@property(readwrite, nonatomic) NSString *weatherConditionCode;
@property(readwrite, nonatomic) NSInteger weatherTemperature;
@property(readwrite, nonatomic) NSDate *lastUpdated;

@property(readwrite, nonatomic) NSString *windDir;
@property(readwrite, nonatomic) NSString *windSC;
@end
