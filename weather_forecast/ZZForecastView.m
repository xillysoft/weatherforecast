//
//  ZZForecastView.m
//  weather_forecast
//
//  Created by zhaoxiaojian on 11/4/16.
//  Copyright © 2016 Zhao Xiaojian. All rights reserved.
//

#import "ZZForecastView.h"
#import "ZZCircleView.h"

@interface ZZForecastView(){
    NSDate *_forecastDate; //发布日期
    NSString *_dayCode; //天气状况代码－白天
    NSString *_dayText; //天气状况－白天
    NSString *_nightCode; //天气状况代码－夜间
    NSString *_nightText; //天气状况－夜间
    NSNumber *_tempMax; //最高气温
    NSNumber *_tempMin; //最低气温
    NSString *_windDir; //风向
    NSString *_windSC; //风力等级
    NSNumber *_windSpd; //风速
    NSNumber *_PoP; //probability of precipitation %
    NSNumber *_humidity; //humidity %
}
@property (weak, nonatomic) IBOutlet ZZCircleView *circleView;
@property (weak, nonatomic) IBOutlet UIImageView *conditionImageView;
@property (weak, nonatomic) IBOutlet UILabel *tempHighLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLowLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionTxtLabel;
@property (weak, nonatomic) IBOutlet UILabel *windScaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *windDirLabel;
@property (weak, nonatomic) IBOutlet UILabel *PoPLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconWindImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconPoPImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconHumidityImageView;

@end


@implementation ZZForecastView

-(instancetype)init
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ZZForecastView"
                                          owner:self
                                        options:nil] firstObject];
    
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self _initViews];
}


-(void)_initViews
{
    UIColor *iconTintColor = [UIColor darkGrayColor];
    UIImageRenderingMode mode = UIImageRenderingModeAlwaysTemplate;
    self.iconWindImageView.image = [self.iconWindImageView.image imageWithRenderingMode:mode];
    self.iconPoPImageView.image = [self.iconPoPImageView.image imageWithRenderingMode:mode];
    self.iconHumidityImageView.image = [self.iconHumidityImageView.image imageWithRenderingMode:mode];
    self.iconWindImageView.tintColor = iconTintColor;
    self.iconPoPImageView.tintColor = iconTintColor;
    self.iconHumidityImageView.tintColor = iconTintColor;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/*!
 * the date the forecast is last updated
 */
-(void)setForecastDate:(NSDate *)date
{
    _forecastDate = date;
}

/*!
 * nightCode, nightText may be nil.
 */
-(void)setConditionDayCode:(NSString *)dayCode dayText:(NSString *)dayText nightCode:(NSString *)nightCode nightText:(NSString *)nightText
{
    _dayCode = dayCode;
    _dayText = dayText;
    _nightCode = nightCode;
    _nightText = nightText;

    NSBundle *bundle = [NSBundle mainBundle];
    UIImage *dayImage = [UIImage imageNamed:[bundle pathForResource:dayCode ofType:@"png"]];
//    UIImage *nightImage = [UIImage imageNamed:[bundle pathForResource:nightCode ofType:@"png"]];

    self.conditionImageView.image = dayImage;
    self.conditionTxtLabel.text = dayText;
}

/*!
 * hight temperature, low temperature
 */
-(void)setTemperatureMax:(NSNumber *)maxTemp min:(NSNumber *)minTemp
{
    _tempMax = maxTemp;
    _tempMin = minTemp;

    self.tempHighLabel.text = [maxTemp stringValue];
    self.tempLowLabel.text = [minTemp stringValue];
}

/*!
 * wind direction, scale, speed(kMPH)
 */
-(void)setWindDir:(NSString *)windDir scale:(NSString *)windSC speed:(NSNumber *)windSpd
{
    _windDir = windDir;
    _windSC = windSC;
    _windSpd = windSpd;
    
    //self.windScaleLabel.text can be set as winSC or windSpd(kMPH)
    self.windScaleLabel.text = windSC;
    self.windDirLabel.text = windDir;
}

/*!
 * probability of precipitation
 */
-(void)setPoP:(NSNumber *)pop
{
    _PoP = pop;

    self.PoPLabel.text = [pop stringValue];
}

/*!
 * humidity %
 */
-(void)setHumidity:(NSNumber *)humidity
{
    _humidity = humidity;
    
    self.humidityLabel.text = [humidity stringValue];
}
@end
