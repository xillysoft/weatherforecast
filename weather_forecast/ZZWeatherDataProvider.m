//
//  ZZWeatherData.m
//  weather_forecast
//
//  Created by zhaoxiaojian on 10/28/16.
//  Copyright © 2016 Zhao Xiaojian. All rights reserved.
//

#import "ZZWeatherDataProvider.h"
#import "ZZWeather.h"

@interface ZZWeatherDataProvider()
@property(readwrite) NSString *cityId;
@property(readwrite) NSString *authKey;

@end



@implementation ZZWeatherDataProvider

-(instancetype)init
{
    return [self initWithCityId:nil authKey:nil];
}

-(instancetype)initWithCityId:(NSString *)cityId authKey:(NSString *)authKey
{
    self = [super init];
    if(self) {
        _cityId = cityId;
        _authKey = authKey;
    }
    return self;
}

-(void)requestWeatherData
{
    NSString *url = [NSString stringWithFormat:@"https://api.heweather.com/x3/weather?cityid=%@&key=%@", _cityId, _authKey];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:mainQueue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if(data == nil){ //Connection error!
            if([self.delegate respondsToSelector:@selector(weatherDataDidFailWithConnectionError:response:sender:)])
                [self.delegate weatherDataDidFailWithConnectionError:connectionError response:response sender:self];
            return ;
        }
        
        NSError *error = nil;
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(obj == nil){ //JSON parsing error!
            if([self.delegate respondsToSelector:@selector(weatherDataDidFailWithConnectionError:response:sender:)])
                [self.delegate weatherDataDidFailWithConnectionError:error response:response sender:self];
            return ;
        }
        if(! [obj isKindOfClass:[NSDictionary class]]){
            if([self.delegate respondsToSelector:@selector(weatherDataDidFailWithDataFormat:sender:)])
                [self.delegate weatherDataDidFailWithDataFormat:data sender:self];
            return ;
        }
        
        NSString *serviceKeyName = [[obj allKeys] firstObject]; //"HeWeather data service 3.0"
        NSDictionary *wdata = [[obj objectForKey:serviceKeyName] firstObject]; //weather data content
        NSString *wdata_status = [wdata objectForKey:@"status"];
        if(! [[wdata_status lowercaseString] isEqualToString:@"ok"]){ //Service status error!
            if([self.delegate respondsToSelector:@selector(weatherDataDidFailWithServiceStatus:sender:)])
                [self.delegate weatherDataDidFailWithServiceStatus:wdata_status sender:self];
            return ;
        }
        
        //Test whether there is new update
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *utcDateLastUpdatedString = [[[wdata objectForKey:@"basic"] objectForKey:@"update"] objectForKey:@"utc"];
        if(utcDateLastUpdatedString == nil){
            if([self.delegate respondsToSelector:@selector(weatherDataDidFailWithDataFormat:sender:)])
                [self.delegate weatherDataDidFailWithDataFormat:data sender:self];
            return ;
        }
        
        NSDate *dateLastUpdate = [formatter dateFromString:utcDateLastUpdatedString];
        if(self.dateLastUpdated!=nil && [self.dateLastUpdated isEqualToDate:dateLastUpdate]){ //no update yet
            if([self.delegate respondsToSelector:@selector(weatherDataDidSucceedWithNoUpdate:sender:)])
                [self.delegate weatherDataDidSucceedWithNoUpdate:dateLastUpdate sender:self];
            return ;
        }
        
        //there is an weather data update
        self.dateLastUpdated = dateLastUpdate;
        
        //AQI received
        NSDictionary *wdata_aqi = [[wdata objectForKey:@"aqi"] objectForKey:@"city"];
        if(wdata_aqi){
            if([self.delegate respondsToSelector:@selector(weatherDataDidReceiveAQI:sender:)])
                [self.delegate weatherDataDidReceiveAQI:wdata_aqi sender:self];
        }
        
        //Life Suggestion Index received
        NSDictionary *wdata_suggestion = [wdata objectForKey:@"suggestion"];
        if(wdata_suggestion){
            if([self.delegate respondsToSelector:@selector(weatherDataDidReceivSuggestion:sender:)])
                [self.delegate weatherDataDidReceivSuggestion:wdata_suggestion sender:self];
        }
        
        NSDictionary *wdata_now = [wdata objectForKey:@"now"];
        if(wdata_now){
            if([self.delegate respondsToSelector:@selector(weatherDataDidReceivNowWeather:sender:)])
                [self.delegate weatherDataDidReceivNowWeather:wdata_now sender:self];
        }

        NSDictionary *wdata_hourly_forecast = [wdata objectForKey:@"hourly_forecast"];
        if(wdata_hourly_forecast){
            if([self.delegate respondsToSelector:@selector(weatherDataDidReceivHourlyForecast:sender:)])
                [self.delegate weatherDataDidReceivHourlyForecast:wdata_hourly_forecast sender:self];
        }
        
        NSArray *wdata_daily_forecast = [wdata objectForKey:@"daily_forecast"];
        if(wdata_daily_forecast){
            if([self.delegate respondsToSelector:@selector(weatherDataDidReceivDaylyForecast:sender:)])
                [self.delegate weatherDataDidReceivDaylyForecast:wdata_daily_forecast sender:self];
        }
    }];
    
}

@end
