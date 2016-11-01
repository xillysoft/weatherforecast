//
//  ZZWeatherData.h
//  weather_forecast
//
//  Created by zhaoxiaojian on 10/28/16.
//  Copyright © 2016 Zhao Xiaojian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZWeather.h"

@class ZZWeatherDataProvider;

/*!
 *protocol ZZWeatherDataProtocol
 */
@protocol ZZWeatherDataProviderDelegate <NSObject>
@optional
/*!
 * Failed with network reason.
 */
-(void)weatherDataDidFailWithConnectionError:(NSError *)error response:(NSURLResponse *)response sender:(ZZWeatherDataProvider *)weatherData;

/*! 
 * Failed Service error.
 */
-(void)weatherDataDidFailWithServiceStatus:(NSString *)status sender:(ZZWeatherDataProvider *)weatherData;

-(void)weatherDataDidFailWithDataFormat:(NSData *)returnedData sender:(ZZWeatherDataProvider *)weatherData;

@optional
/*!
 * Succeeded to get weather data, but no update
 */
-(void)weatherDataDidSucceedWithNoUpdate:(NSDate *)dateLasteUpdated sender:(ZZWeatherDataProvider *)weatherData;

@optional
/*!
 * Succeeded to get weather data, and there is an update
 */
-(void)weatherDataDidReceiveAQI:(NSDictionary *)aqi sender:(ZZWeatherDataProvider *)sender;

-(void)weatherDataDidReceivSuggestion:(NSDictionary *)suggestion sender:(ZZWeatherDataProvider *)sender;

-(void)weatherDataDidReceivNowWeather:(NSDictionary *)weatherNow sender:(ZZWeatherDataProvider *)sender;

-(void)weatherDataDidReceivHourlyForecast:(NSDictionary *)hourlyForecast sender:(ZZWeatherDataProvider *)sender;
-(void)weatherDataDidReceivDaylyForecast:(NSArray *)dailyForecast sender:(ZZWeatherDataProvider *)sender;
@end



/*!
 * class ZZWeatherData
 */
@interface ZZWeatherDataProvider : NSObject

@property(readonly) NSString *cityId;

@property id<ZZWeatherDataProviderDelegate> delegate;

- (instancetype)initWithCityId:(NSString *)cityId authKey:(NSString *)authKey NS_DESIGNATED_INITIALIZER;

/*!
 * weather data is returned to delegate methods
 */
- (void)requestWeatherData;

@property NSDate *dateLastUpdated;

@end
