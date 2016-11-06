//
//  ZZForecastView.m
//  weather_forecast
//
//  Created by zhaoxiaojian on 11/4/16.
//  Copyright © 2016 Zhao Xiaojian. All rights reserved.
//

#import "ZZForecastView.h"

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

@end


@implementation ZZForecastView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self _initViews];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self _initViews];
    }
    return self;
}

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:[UIColor clearColor]];
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
 
    self.conditionImageView.image = nil;
    self.tempHighLabel.text = self.tempLowLabel.text = @"-";
    self.conditionTxtLabel.text = nil;
    self.windDirLabel.text = @"-";
    self.windScaleLabel.text = nil;
    self.poPLabel.text = @"-";
    self.humidityLabel.text = @"-";
    
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
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"M/d";
    self.leftDateUpper.text = [formatter stringFromDate:date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit dateUnits = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *forecastDay = [calendar components:dateUnits fromDate:[NSDate date]];
    NSDateComponents *today = [calendar components:dateUnits fromDate:date];
    if([forecastDay isEqual:today]){
        self.leftDateLower.text = @"今天";
        self.leftDateLower.textColor = [UIColor grayColor];
    }else{
        formatter.dateFormat = @"EEEE"; //week day
        self.leftDateLower.text = [formatter stringFromDate:date];
        self.leftDateLower.textColor = [UIColor darkGrayColor];
    }
    
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

    self.conditionImageView.image = [dayImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.conditionTxtLabel.text = dayText;
    
    //decide best tintColor for day condition
    {
        const NSDictionary <NSString *, UIColor *> *tintColors = @{@"1": [UIColor lightGrayColor], //cloudy
                                                                   @"3": [UIColor blueColor], //rainy
                                                                   @"4": [UIColor purpleColor] //snowy
                                                                   };
        NSString *conditionFirstDigit = [dayCode substringToIndex:1];
        UIColor *tintColor = [tintColors objectForKey:conditionFirstDigit];
        if([dayCode isEqualToString:@"100"]){ //sunny
            self.conditionImageView.tintColor = [UIColor orangeColor];
        }else{
            self.conditionImageView.tintColor = tintColor ? tintColor : [UIColor lightGrayColor];
        }
    }
    
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

    self.poPLabel.text = [pop stringValue];
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
