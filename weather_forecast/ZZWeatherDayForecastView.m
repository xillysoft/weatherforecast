//
//  ZZWeatherDayForecastView.m
//  weather_forecast
//
//  Created by zhaoxiaojian on 11/1/16.
//  Copyright © 2016 Zhao Xiaojian. All rights reserved.
//

#import "ZZWeatherDayForecastView.h"

@interface ZZWeatherDayForecastView(){
    NSDate *_forecastDate;
    NSString *_dayCode;
    NSString *_dayText;
    NSString *_nightCode;
    NSString *_nightText;
    NSNumber *_tempMin;
    NSNumber *_tempMax;
    NSString *_windDir;
    NSString *_windSC;
}

@property UIImageView *conditionDayImageView;
@property UIImageView *conditionNightImageView;
@property UILabel *conditionDayLabel;
@property UILabel *conditionNightLabel;
@property UILabel *temperatureLabel;
@property UILabel *windLabel;
@end


@implementation ZZWeatherDayForecastView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self _loadSubviews];
    }
    return self;
}

-(void)_loadSubviews
{
    self.conditionDayImageView = [[UIImageView alloc] init];
    self.conditionNightImageView = [[UIImageView alloc] init];
    self.conditionDayLabel = [[UILabel alloc] init];
    self.conditionNightLabel = [[UILabel alloc] init];
    self.temperatureLabel = [[UILabel alloc] init];
    self.windLabel = [[UILabel alloc] init];
    [self addSubview:self.conditionDayImageView];
    self.conditionDayImageView.tintColor = [UIColor lightGrayColor];
    [self addSubview:self.conditionNightImageView];
    self.conditionNightImageView.tintColor = [UIColor lightGrayColor];
    [self addSubview:self.conditionDayLabel];
    [self addSubview:self.conditionNightLabel];
    [self addSubview:self.temperatureLabel];
    self.temperatureLabel.numberOfLines = 1;
    [self addSubview:self.windLabel];
    
    [self _setupConstraints];
}

-(void)_setupConstraints
{
    self.conditionDayImageView.translatesAutoresizingMaskIntoConstraints = NO;
    //conditionDayImageView.top = superview.top+5
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.conditionDayImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:5]];
    //conditionDayImageView.left = superview.left+5
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.conditionDayImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:5]];
    
    self.conditionNightImageView.translatesAutoresizingMaskIntoConstraints = NO;
    //conditionNightImageView.left = conditionDayImageView.right+10
    //conditionNightImageView.centerY = conditionDayImageView.centerY
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.conditionNightImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.conditionDayImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:10]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.conditionNightImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.conditionDayImageView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    self.conditionDayLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.conditionNightLabel.translatesAutoresizingMaskIntoConstraints = NO;
    //conditionDayLabel.top = conditionDayImageView.bottom
    //conditionDayLabel.centerX = conditionDayImageView.centerX
    //conditionNightLabel.baseline = conditionDayLabel.baseline
    //conditionNightLabel.centerX = conditionNightImageView.centerX
    //conditionDaylabel.bottom = superview.bottom
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.conditionDayLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.conditionDayImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.conditionDayLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.conditionDayImageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.conditionNightLabel attribute:NSLayoutAttributeBaseline relatedBy:NSLayoutRelationEqual toItem:self.conditionDayLabel attribute:NSLayoutAttributeBaseline multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.conditionNightLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.conditionNightImageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.conditionDayLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.conditionDayLabel.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];

    self.temperatureLabel.translatesAutoresizingMaskIntoConstraints = NO;
    //temperatureLabel.centerY = conditionNightImageView.centerY
    //temperatureLabel.left = conditionNightImageView.right+30
    //temperatureLabel.right = superview.right-10
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.temperatureLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.conditionNightImageView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.temperatureLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.conditionNightImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:30]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.temperatureLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10]];
    
    self.windLabel.translatesAutoresizingMaskIntoConstraints = NO;
    //windLabel.top = temperatureLabel.bottom+10
    //windLabel.left = temperatureLabel.left
    //windLabel.right = superview.right-10
    //windLabel.bottm ≤ conditionDayLabel.bottom
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.windLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.temperatureLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.windLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.temperatureLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.windLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.windLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.conditionDayLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    //conditionDayImageView.width = 40;
    NSLayoutConstraint *c1 = [NSLayoutConstraint constraintWithItem:self.conditionDayImageView attribute:
                              NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:40];
    c1.priority = UILayoutPriorityDefaultHigh;
    [self addConstraint:c1];
    //conditionDayImageView.height = conditionDayImageView.width
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.conditionDayImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.conditionDayImageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    //conditionNightImageView.width = conditionDayImageView.width
    //conditionNightImageView.height = conditionDayImageView.height
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.conditionNightImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.conditionDayImageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.conditionNightImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.conditionDayImageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    
    [self.conditionDayImageView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.conditionNightImageView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    //Content Compression Resistance/Hugging priority
    [self.conditionDayImageView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.conditionNightImageView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.temperatureLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.windLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//    self.temperatureLabel.adjustsFontSizeToFitWidth = YES;
//    self.windLabel.adjustsFontSizeToFitWidth = YES;
    [self.temperatureLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.windLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

    
}

-(void)setForecastDate:(NSDate *)date
{
    _forecastDate = date;
}

-(void)setConditionDayCode:(NSString *)dayCode dayText:(NSString *)dayText nightCode:(NSString *)nightCode nightText:(NSString *)nightText
{
    _dayCode = dayCode;
    _dayText = dayText;
    _nightCode = nightCode;
    _nightText = nightText;
    NSBundle *bundle = [NSBundle mainBundle];
    UIImage *dayImage = [UIImage imageNamed:[bundle pathForResource:dayCode ofType:@"png"]];
    UIImage *nightImage = [UIImage imageNamed:[bundle pathForResource:nightCode ofType:@"png"]];
    [self.conditionDayImageView setImage:[dayImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [self.conditionNightImageView setImage:[nightImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [self.conditionDayLabel setText:dayText];
    [self.conditionNightLabel setText:nightText];
    
}

-(void)setTemperatureMax:(NSNumber *)maxTemp min:(NSNumber *)minTemp
{
    _tempMin = minTemp;
    _tempMax = maxTemp;
    NSString *maxTempString = [maxTemp stringValue];
    NSString *minTempString = [minTemp stringValue];
    NSString *tempString1 = [NSString stringWithFormat:@"%@~%@", maxTempString, minTempString];
    NSString *tempString2 = @"°C";
    NSString *tempString = [tempString1 stringByAppendingString:tempString2];
    [self.temperatureLabel setAttributedText:({
        UIFont *font1 = [UIFont boldSystemFontOfSize:32];
        UIFont *font2 = [UIFont boldSystemFontOfSize:16];
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:tempString];
        [as addAttribute:NSFontAttributeName value:font1 range:NSMakeRange(0, [tempString1 length])];
        [as addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange([maxTempString length], 1)];
        NSRange unitRange = NSMakeRange([tempString1 length], [tempString2 length]);
        [as addAttribute:NSFontAttributeName value:font2 range:unitRange];
        [as addAttribute:NSBaselineOffsetAttributeName value:@([font1 capHeight] - [font2 capHeight]) range:unitRange];
        as;
    })];
}

-(void)setWindDir:(NSString *)windDir SC:(NSString *)windSC
{
    _windDir = windDir;
    _windSC = windSC;
    
    NSString *windString = [NSString stringWithFormat:@"%@ %@", windDir, windSC];
    [self.windLabel setAttributedText:({
        [[NSAttributedString alloc] initWithString:windString
                                        attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    })];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
