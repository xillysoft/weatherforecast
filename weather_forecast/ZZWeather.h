//
//  ZZWeather.h
//  weather_forecast
//
//  Created by zhaoxiaojian on 10/28/16.
//  Copyright © 2016 Zhao Xiaojian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZWeather : NSObject
@property NSString *conditionText; //e.g. "晴"
@property NSString *conditionCode; //e.g. "202"

@property NSInteger temperature; //e.g. 13

@property NSString *windDirection; //e.g. "西风"
@property NSString *windSC; //e.g. "5-6", "微风"
@end
