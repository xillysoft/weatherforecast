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
#import "ZZForecastView.h"
#import "ZZGradientColoredView.h"

@interface ViewController () <ZZWeatherDataProviderDelegate, UIScrollViewDelegate> {
    NSLayoutConstraint *_topLayoutConstraint;
    BOOL _isConstaintsUpdated;
    
    BOOL _isRequestingWeatherData;
    BOOL _isScrollViewDragging;
}

@property ZZWeatherDataProvider *weatherData;

@property UIActivityIndicatorView *activityIndicatorView;

@property ZZWeatherNowView *weatherNowView;
@property NSMutableArray<ZZForecastView *> *forecastViews;
@property NSMutableArray<ZZGradientColoredView *> *connectionLineViews;

@end

@implementation ViewController

-(void)loadView
{
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    //prevent view controller to automatically adjust scrollview, add a topGuide constriant manually
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    //TODO use a background picture insead solid color
    UIColor *backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.0];
    scrollView.backgroundColor = backgroundColor;
    
    self.weatherNowView = [[ZZWeatherNowView alloc] initWithFrame:CGRectZero];
    [scrollView addSubview:self.weatherNowView];
    
    int numForecasts = 7;
    self.forecastViews = [NSMutableArray array];
    for(int i=0; i<numForecasts; i++){ //n forecastViews
        ZZForecastView *forecastView = (ZZForecastView *)[[[NSBundle mainBundle] loadNibNamed:@"ZZForecastView"
                                                                      owner:nil
                                                                    options:nil] firstObject];
//        forecastView.backgroundColor = i%2==0 ?  backgroundColor : [UIColor blackColor];
        forecastView.backgroundColor = backgroundColor;
        
        [self.forecastViews addObject:forecastView];
        [scrollView addSubview:forecastView];
    }
    
    self.connectionLineViews = [NSMutableArray array];
    for(int i=0; i<numForecasts + 1; i++){ //n+1 connection lines between forecastViews
        ZZGradientColoredView *connectionLineView = [[ZZGradientColoredView alloc] initWithFrame:CGRectZero];
        connectionLineView.direction = ZZGradientColoredViewDirectionVertical;
        connectionLineView.colorStart = connectionLineView.colorEnd = [UIColor darkGrayColor];
        
        [self.connectionLineViews addObject:connectionLineView];
        [scrollView addSubview:connectionLineView];
    }
    
//    view.translatesAutoresizingMaskIntoConstraints = NO;
    self.view = scrollView;
    
    _isConstaintsUpdated = NO;
    [self updateViewConstraints]; //-updateViewConstraints will not called initially
    
    
    scrollView.delegate = self;
    _isScrollViewDragging = NO;
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.activityIndicatorView]];
    self.activityIndicatorView.hidesWhenStopped = YES;
//    self.activityIndicatorView.color = [UIColor blueColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *authKey = @"abb4394c4a8441159cd794ecaa7b5ef2";
    NSString *cityId = self.cityId ? self.cityId : @"CN101080101";
    self.weatherData = [[ZZWeatherDataProvider alloc] initWithCityId:cityId authKey:authKey];
    self.weatherData.delegate = self;
    [self.weatherData requestWeatherData_x3];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self setTitle:self.cityName];
 
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
        
        const CGFloat paddingBetweenForecastViews = 30;
        
        int numForecasts = 7;
        
        for(int i=0; i<numForecasts; i++){ //constraints for forecastViews
            ZZForecastView *forecastView = self.forecastViews[i];
            
            forecastView.translatesAutoresizingMaskIntoConstraints = NO;
            //self.forecastViews[i].top = self.weatherNowView.bottom+15 or self.forecastViews[i-1].bottom+20
            if(i == 0){//for forecastView[0]
                //forecastView.top == weatherNowView.bottom+20
                [self.view addConstraint:[NSLayoutConstraint constraintWithItem:forecastView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.weatherNowView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20]];
            }else{ //i≥1
                //forecastViews[i].top == forecastViews[i-1].to + padding
                [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.forecastViews[i] attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.forecastViews[i-1] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:paddingBetweenForecastViews]];
                
                //Additional constriants added to align views on the same columns of rows
                //forecastViews[i].leftView.width = forecastViews[i-1].leftView.width
                //forecastViews[i].circleView.centerX = forecastViews[i-1].circleView.centerX
                //forecastViews[i].tempSeparatorLabel.centerX = forecastViews[i-1].tempSeparatorLabel.centerX
                //forecastViews[i].iconWindImageView.centerX = forecastViews[i-1].iconWindImageView.centerX
                //forecastViews[i].iconPoPImageView.centerX = forecastViews[i-1].iconPoPImageView.centerX
                //forecastViews[i].iconHumidityImageView.centerX = forecastViews[i-1].iconHumidityImageView.centerX
                [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.forecastViews[i].leftView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.forecastViews[i-1].leftView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
                [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.forecastViews[i].circleView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.forecastViews[i-1].circleView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
                [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.forecastViews[i].tempSeperatorLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.forecastViews[i-1].tempSeperatorLabel attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
                [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.forecastViews[i].iconWindImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.forecastViews[i-1].iconWindImageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
                [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.forecastViews[i].iconPoPImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.forecastViews[i-1].iconPoPImageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
                [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.forecastViews[i].iconHumidityImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.forecastViews[i-1].iconHumidityImageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];

                
            }
            //self.forecastViews[6].bottom = superview.bottom - 20
            if(i == 7-1){
                [self.view addConstraint:[NSLayoutConstraint constraintWithItem:forecastView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:forecastView.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-20]];
            }
            
            //self.weatherForecastView.centerX = superview.centerX
            //self.weatherForecastView.width = superview.width
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:forecastView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:forecastView.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:forecastView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:forecastView.superview attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
        }
        
        const CGFloat connectionLineWidth = 3;
        for(int i=0; i<numForecasts + 1; i++){ //constraints for connectionLineViews
            ZZGradientColoredView *connectionLineView = self.connectionLineViews[i];
            connectionLineView.translatesAutoresizingMaskIntoConstraints = NO;
            
            //connectionLineView.width = 5
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.connectionLineViews[i] attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:connectionLineWidth]];
            
            ZZForecastView *forecastView = i==0 ? self.forecastViews[0] : self.forecastViews[i-1];
            //self.connectionLineViews[i].centerX = forecastView.circleView.centerX
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.connectionLineViews[i] attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:forecastView.circleView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
            

            if(i == 0){//for connectionLineViews[0]
                //self.connectionLineViews[i].top = self.weatherNowView.bottom+5
                [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.connectionLineViews[i] attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.weatherNowView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5]];
            }else{ //i≥1
                //self.connectionLineViews[i].top = self.forecasViews[i-1].circleView.bottom
                [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.connectionLineViews[i] attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.self.forecastViews[i-1].circleView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
            }
            if(i == numForecasts){ //last connectionLineView
                //self.connectionLineViews[i].bottom = superview.bottom-5
                [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.connectionLineViews[i] attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.connectionLineViews[i].superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5]];
            }else{
                //self.connectionLineViews[i].bottom = self.forecastViews[i].circleView.top
                [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.connectionLineViews[i] attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.forecastViews[i].circleView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
            }


        }
        
        _isConstaintsUpdated = YES;
    }
    [super updateViewConstraints];
}


-(void)viewWillLayoutSubviews
{
    //Note: Set UIViewController's automaticallyAjustsScrollViewInsets = NO
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
}

-(void)weatherDataWillBeginLoading:(ZZWeatherDataProvider *)sender
{
    _isRequestingWeatherData = YES;
    [self.activityIndicatorView startAnimating];
}
-(void)weatherDataDidEndLoading:(ZZWeatherDataProvider *)sender
{
    _isRequestingWeatherData = NO;
    [self.activityIndicatorView stopAnimating];
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
    
    NSString *aqiIndexString = [aqi objectForKey:@"aqi"];
    NSNumber *aqiIndex = @([aqiIndexString intValue]);
    NSString *aqiQuality = [aqi objectForKey:@"qlty"];
    NSString *aqiPM25 = [aqi objectForKey:@"pm25"];
    NSString *aqiPM10 = [aqi objectForKey:@"pm10"];
    [self.weatherNowView setAQI:aqiIndex quality:aqiQuality pm25:aqiPM25 pm10:aqiPM10];
}
-(void)weatherDataDidReceivSuggestion:(NSDictionary *)suggestion sender:(ZZWeatherDataProvider *)sender
{
//    NSLog(@"--WeatherDataProvider:: Received Sugguestion! \n\tSuggestion=%@", suggestion);
}

-(void)weatherDataDidReceivNowWeather:(NSDictionary *)weatherNow sender:(ZZWeatherDataProvider *)sender
{
//    NSLog(@"--WeatherDataProvider:: Receive Now Weather!");
    
    NSString *conditionCode = [[weatherNow objectForKey:@"cond"] objectForKey:@"code"];
    NSString *conditionText = [[weatherNow objectForKey:@"cond"] objectForKey:@"txt"];
    NSString *temp = [weatherNow objectForKey:@"tmp"];
    NSString *windDir = [[weatherNow objectForKey:@"wind"] objectForKey:@"dir"];
    NSString *windSC = [[weatherNow objectForKey:@"wind"] objectForKey:@"sc"];
    
    [self.weatherNowView setLastUpdated:sender.dateLastUpdated];
    [self.weatherNowView setWeatherConditionText:conditionText code:conditionCode];
    [self.weatherNowView setWeatherTemperature:@([temp intValue])];
    [self.weatherNowView setWeatherWindDir:windDir SC:windSC];
    
}

//handle daily forecast
-(void)weatherDataDidReceivDaylyForecast:(NSArray *)dailyForecast sender:(ZZWeatherDataProvider *)sender
{
    //find the highest and lowest temperature in the daily forecast array
    NSInteger tempHighest = NSIntegerMin;
    NSInteger tempLowest = NSIntegerMax;
    for(int i=0; i<MIN(7, [dailyForecast count]); i++){
        NSInteger tempHigh = [[[dailyForecast[i] objectForKey:@"tmp"] objectForKey:@"max"] integerValue];
        NSInteger tempLow = [[[dailyForecast[i] objectForKey:@"tmp"] objectForKey:@"min"] integerValue];
        if(tempHighest < tempHigh)
            tempHighest = tempHigh;
        if(tempLowest > tempLow)
            tempLowest = tempLow;
    }
    
    for(int i=0; i<MIN(7, [dailyForecast count]); i++){
        NSDictionary *dayForecast = dailyForecast[i];
        ZZForecastView *forecastView = self.forecastViews[i];
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
        CGFloat tempHigh = [tmp_max integerValue];
        CGFloat tempLow = [tmp_min integerValue];
        [forecastView setTemperatureMax:@(tempHigh) min:@(tempLow)];
        
        CGFloat tempAvg = tempHigh;
        CGFloat hue = (tempAvg - tempHighest) / (tempLowest - tempHighest); //value=[0.0, 1.0]
        hue = MIN(MAX(0, hue), 1.0);
        UIColor *colorForTemp = [UIColor colorWithHue:hue saturation:0.6 brightness:1.0 alpha:1.0];
        [self.connectionLineViews[i] setColorEnd:colorForTemp];
        [self.connectionLineViews[i+1] setColorStart:colorForTemp];
        [self.connectionLineViews[i] setNeedsDisplay];
        [self.connectionLineViews[i+1] setNeedsDisplay];
        
        NSString *wind_dir = [[dayForecast objectForKey:@"wind"] objectForKey:@"dir"];
        NSString *wind_sc = [[dayForecast objectForKey:@"wind"] objectForKey:@"sc"];
        NSString *wind_spd = [[dayForecast objectForKey:@"wind"] objectForKey:@"spd"];
        NSNumber *windSpd = wind_spd ? [NSNumber numberWithInteger:[wind_spd integerValue]] : nil;
        [forecastView setWindDir:wind_dir scale:wind_sc speed:windSpd];
        
        NSString *PoP = [dayForecast objectForKey:@"pop"];
        NSString *hum = [dayForecast objectForKey:@"hum"];
        [forecastView setPoP:PoP ? [NSNumber numberWithInteger:[PoP integerValue]] : nil];
        [forecastView setHumidity:hum ? [NSNumber numberWithInteger:[hum integerValue]] : nil];
        
        NSDateFormatter *formatterOut = [[NSDateFormatter alloc] init];
        [formatterOut setDateFormat:@"M-d EEEE"];
//        [outFormatter setDateStyle:NSDateFormatterShortStyle];
//        [outFormatter setTimeStyle:NSDateFormatterNoStyle];
        
        [formatterOut setLocale:[NSLocale currentLocale]];
//        NSLog(@"--%d:[%@]: %@-->%@, %@~%@C", i, [formatterOut stringFromDate:forecastDate], cond_txt_d, cond_txt_n, tmp_max, tmp_min);
    }
    UIColor *colorStart = [self.connectionLineViews[0] colorEnd];
//    colorStart = self.connectionLineViews[0].superview.backgroundColor;
    [self.connectionLineViews[0] setColorStart:colorStart];
    
    UIColor *colorEnd = [self.connectionLineViews[[dailyForecast count]] colorStart];
//    colorEnd = self.connectionLineViews[0].superview.backgroundColor;
    [self.connectionLineViews[[dailyForecast count]] setColorEnd:colorEnd];
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _isScrollViewDragging = YES;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _isScrollViewDragging = NO;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(_isScrollViewDragging){ //dragging down to refresh
        if(scrollView.contentOffset.y <= -100 && !_isRequestingWeatherData){
            [_weatherData requestWeatherData_x3]; //refresh
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
