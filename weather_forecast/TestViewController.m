//
//  TestViewController.m
//  weather_forecast
//
//  Created by zhaoxiaojian on 1/17/17.
//  Copyright © 2017 Zhao Xiaojian. All rights reserved.
//

#import "TestViewController.h"
#import "ZZAQIDashBoardView.h"
#import "ZZWeatherForecastGraphView.h"

@interface TestViewController ()
@property NSString *cityId;
@property NSString *cityName;
@property ZZWeatherForecastGraphView *forecastGraphView;
@end

@implementation TestViewController

-(void)loadView
{
    self.forecastGraphView = [[ZZWeatherForecastGraphView alloc] initWithFrame:CGRectZero];
    self.view = self.forecastGraphView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showWeatherWithCityId:(NSString *)cityId cityName:(NSString *)cityName
{
    self.cityId = cityId;
    self.cityName = cityName;
    self.title = cityName;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSURL *baseURL = [NSURL URLWithString:@"https://free-api.heweather.com/x3/"]; //x3 interface, deprecated
    NSString *authKey = @"abb4394c4a8441159cd794ecaa7b5ef2";
    NSString *query = [NSString stringWithFormat:@"weather?cityid=%@&key=%@", self.cityId, authKey]; //x3 interface
    NSURL *url = [NSURL URLWithString:query relativeToURL:baseURL];
    //    NSLog(@"--url:: 0=%@\n\t1=%@\n\t2=%@\n\t3=%@\n\t4=%@", url, [url relativePath], [url relativeString], [url absoluteURL], [url absoluteString]);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSError *error = nil;
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(obj == nil){
            NSLog(@"--Network connection error! error=%@", error);
        }
        NSString *serviceKeyName = [[obj allKeys] firstObject]; //"HeWeather data service 3.0"
        NSDictionary *wdata = [[obj objectForKey:serviceKeyName] firstObject]; //weather data content
        NSString *wdata_status = [wdata objectForKey:@"status"];
        if(! [[wdata_status lowercaseString] isEqualToString:@"ok"]){ //Service status error!
            NSLog(@"--Weather service error! error=%@", wdata_status);
            return ;
        }
        NSArray *wdata_daily_forecast = [wdata objectForKey:@"daily_forecast"];
        if(wdata_daily_forecast){
            [self.forecastGraphView setWeatherDailyForecastData:wdata_daily_forecast];
        }else{
            NSLog(@"--error: no weather daily forecast!");
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
