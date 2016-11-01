//
//  ViewController.m
//  weather_forecast
//
//  Created by zhaoxiaojian on 10/28/16.
//  Copyright © 2016 Zhao Xiaojian. All rights reserved.
//

#import "ViewController.h"
#import "ZZWeatherDataProvider.h"
#import "ZZWeatherNowView.h"
#import "ZZWeatherDayForecastView.h"

@interface ViewController () <ZZWeatherDataProviderDelegate> {
    NSLayoutConstraint *_topLayoutConstraint;
    BOOL _isConstaintsUpdated;
}

@property ZZWeatherDataProvider *weatherData;
@property ZZWeatherNowView *weatherNowView;
@property NSMutableArray<ZZWeatherDayForecastView *> *forecastViews;

@end

@implementation ViewController

-(void)loadView
{
    UIView *container = [[UIScrollView alloc] initWithFrame:CGRectZero];
    container.backgroundColor = [UIColor whiteColor];
    
    self.weatherNowView = [[ZZWeatherNowView alloc] initWithFrame:CGRectZero];
    [container addSubview:self.weatherNowView];
    
    self.forecastViews = [NSMutableArray array];
    for(int i=0; i<7; i++){
        ZZWeatherDayForecastView *forecastView = [[ZZWeatherDayForecastView alloc] initWithFrame:CGRectZero];
        [self.forecastViews addObject:forecastView];
        [container addSubview:forecastView];
    }
    
//    view.translatesAutoresizingMaskIntoConstraints = NO;
    self.view = container;
    
    _isConstaintsUpdated = NO;
    [self updateViewConstraints]; //-updateViewConstraints will not called initially
}

-(void)updateViewConstraints
{
    if(! _isConstaintsUpdated){
        self.weatherNowView.translatesAutoresizingMaskIntoConstraints = NO;
        //self.weatherNowView.top = superview.top + topLayoutGuide
        _topLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.weatherNowView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.weatherNowView.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        [self.view addConstraint:_topLayoutConstraint];
        
        //self.weatherNowView.centerX = superview.centerX
        //self.weatherNowView.width = superview.width
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.weatherNowView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.weatherNowView.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.weatherNowView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.weatherNowView.superview attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
        
        for(int i=0; i<7; i++){
            ZZWeatherDayForecastView *forecastView = self.forecastViews[i];
            forecastView.translatesAutoresizingMaskIntoConstraints = NO;
            //self.forecastViews[i].top = self.weatherNowView.bottom+15 or self.forecastViews[i-1].bottom+5
            if(i == 0){
                [self.view addConstraint:[NSLayoutConstraint constraintWithItem:forecastView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.weatherNowView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:15]];
            }else{
//                [self.view addConstraint:[NSLayoutConstraint constraintWithItem:forecastView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.forecastViews[i-1] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10]];
                [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.forecastViews[i] attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.forecastViews[i-1] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5]];
            }
            //self.forecastViews[6].bottom = superview.bottom
            if(i == 7-1){
                [self.view addConstraint:[NSLayoutConstraint constraintWithItem:forecastView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:forecastView.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10]];
            }
            
            //self.weatherForecastView.centerX = superview.centerX
            //self.weatherForecastView.width = superview.width
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:forecastView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:forecastView.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:forecastView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:forecastView.superview attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
        }
        _isConstaintsUpdated = YES;
    }
    [super updateViewConstraints];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    BOOL hidden = [[self navigationController] isNavigationBarHidden];
    [[self navigationController] setNavigationBarHidden:!hidden animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *cityId = @"CN101080101";
    NSString *authKey = @"abb4394c4a8441159cd794ecaa7b5ef2";
    self.weatherData = [[ZZWeatherDataProvider alloc] initWithCityId:cityId authKey:authKey];
    self.weatherData.delegate = self;
    [self.weatherData requestWeatherData];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGFloat topGuide;
    if([self respondsToSelector:@selector(topLayoutGuide)]){
        topGuide = [self.topLayoutGuide length];
    }else{
        topGuide = [[UIApplication sharedApplication] statusBarFrame].size.height;
    }
    [_topLayoutConstraint setConstant:topGuide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)weatherDataDidFailWithConnectionError:(NSError *)error response:(NSURLResponse *)response sender:(ZZWeatherDataProvider *)weatherData
{
    NSLog(@"--WeatherDataProvider:: ConnectionError! error=%@, respone=%@", error, response);
}
-(void)weatherDataDidFailWithServiceStatus:(NSString *)status sender:(ZZWeatherDataProvider *)weatherData
{
    NSLog(@"--WeatherDataProvider:: ServiceError! status=%@", status);
}
-(void)weatherDataDidFailWithDataFormat:(NSData *)returnedData sender:(ZZWeatherDataProvider *)weatherData
{
    NSLog(@"--WeatherDataProvider:: Data Format Error! \n\treceived data=%@", [[NSString alloc] initWithData:returnedData encoding:NSUTF8StringEncoding]);
}
-(void)weatherDataDidReceiveAQI:(NSDictionary *)aqi sender:(ZZWeatherDataProvider *)sender
{
//    NSLog(@"WeatherDataProvider:: Received AQI! \n\taqi=%@", aqi);
}
-(void)weatherDataDidReceivSuggestion:(NSDictionary *)suggestion sender:(ZZWeatherDataProvider *)sender
{
//    NSLog(@"--WeatherDataProvider:: Received Sugguestion! \n\tSuggestion=%@", suggestion);
}

-(void)weatherDataDidReceivNowWeather:(NSDictionary *)weatherNow sender:(ZZWeatherDataProvider *)sender
{
//    NSLog(@"--WeatherDataProvider:: Receive Now Weather! \n\tnow=%@", weatherNow);
    
    NSString *conditionCode = [[weatherNow objectForKey:@"cond"] objectForKey:@"code"];
    NSString *conditionText = [[weatherNow objectForKey:@"cond"] objectForKey:@"txt"];
    NSString *temp = [weatherNow objectForKey:@"tmp"];
    NSString *windDir = [[weatherNow objectForKey:@"wind"] objectForKey:@"dir"];
    NSString *windSC = [[weatherNow objectForKey:@"wind"] objectForKey:@"sc"];
    
    [self.weatherNowView setWeatherConditionCode:conditionCode];
    [self.weatherNowView setWeatherConditionText:conditionText];
    [self.weatherNowView setWeatherTemperature:[temp integerValue]];
    [self.weatherNowView setWindDir:windDir];
    [self.weatherNowView setWindSC:windSC];
    [self.weatherNowView setLastUpdated:sender.dateLastUpdated];
    
}

-(void)weatherDataDidReceivDaylyForecast:(NSArray *)dailyForecast sender:(ZZWeatherDataProvider *)sender
{
//    NSLog(@"--WeatherDataProvider:: Receive Daily Forecast! \n\tDaily forecast=%@", dailyForecast);
    for(int i=0; i<7; i++){
        NSDictionary *dayForecast = dailyForecast[i];
        ZZWeatherDayForecastView *forecastView = self.forecastViews[i];
        NSString *dateString = [dayForecast objectForKey:@"date"];
        NSDateFormatter *formatterIn = [[NSDateFormatter alloc] init];
        [formatterIn setDateFormat:@"yyyy-MM-dd"];
        NSDate *forecastDate = [formatterIn dateFromString:dateString];
        [forecastView setForecastDate:forecastDate];
        
        NSString *cond_code_d = [[dayForecast objectForKey:@"cond"] objectForKey:@"code_d"];
        NSString *cond_code_n = [[dayForecast objectForKey:@"cond"] objectForKey:@"code_n"];
        NSString *cond_txt_d = [[dayForecast objectForKey:@"cond"] objectForKey:@"txt_d"];
        NSString *cond_txt_n = [[dayForecast objectForKey:@"cond"] objectForKey:@"txt_n"];
        [forecastView setConditionDayCode:cond_code_d dayText:cond_txt_d nightCode:cond_code_n nightText:cond_txt_n];
        
        NSString *tmp_max = [[dayForecast objectForKey:@"tmp"] objectForKey:@"max"];
        NSString *tmp_min = [[dayForecast objectForKey:@"tmp"] objectForKey:@"min"];
        [forecastView setTemperatureMax:@([tmp_max integerValue]) min:@([tmp_min integerValue])];
        
        NSString *wind_dir = [[dayForecast objectForKey:@"wind"] objectForKey:@"dir"];
        NSString *wind_sc = [[dayForecast objectForKey:@"wind"] objectForKey:@"sc"];
        [forecastView setWindDir:wind_dir SC:wind_sc];
        
        NSDateFormatter *formatterOut = [[NSDateFormatter alloc] init];
        [formatterOut setDateFormat:@"M-d EEEE"];
//        [outFormatter setDateStyle:NSDateFormatterShortStyle];
//        [outFormatter setTimeStyle:NSDateFormatterNoStyle];
        
        [formatterOut setLocale:[NSLocale currentLocale]];
        NSLog(@"--%d:[%@]: %@-->%@, %@~%@C", i, [formatterOut stringFromDate:forecastDate], cond_txt_d, cond_txt_n, tmp_max, tmp_min);
    }
    
}


@end
