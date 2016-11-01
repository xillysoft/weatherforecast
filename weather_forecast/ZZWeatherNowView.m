//
//  ZZWeatherNowView.m
//  weather_forecast
//
//  Created by zhaoxiaojian on 10/28/16.
//  Copyright © 2016 Zhao Xiaojian. All rights reserved.
//

#import "ZZWeatherNowView.h"

@interface ZZWeatherNowView(){
    NSLayoutConstraint *_weatherConditionImageSizeConstaint;
}
@property UIImageView *conditionImageView;
@property UILabel *temperatureLabel;
@property UILabel *conditionTextLabel;
@property UILabel *lastUpdatedLabel;
@property UILabel *windDirLabel;
@property UILabel *windSCLabel;

@end


@implementation ZZWeatherNowView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setupViews];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setupViews];
    }
    return self;
}

-(void)setupViews
{
    self.conditionImageView = [[UIImageView alloc] init];
    self.temperatureLabel = [[UILabel alloc] init];
    self.conditionTextLabel = [[UILabel alloc] init];
    self.lastUpdatedLabel = [[UILabel alloc] init];
    self.windDirLabel = [[UILabel alloc] init];
    self.windSCLabel = [[UILabel alloc] init];

//for debugging
//    self.conditionImageView.backgroundColor = [UIColor grayColor];
//    self.temperatureLabel.backgroundColor = [UIColor greenColor];
//    self.conditionTextLabel.backgroundColor = [UIColor purpleColor];
//    self.lastUpdatedLabel.backgroundColor = [UIColor brownColor];
//    self.windDirLabel.backgroundColor = [UIColor yellowColor];
//    self.windSCLabel.backgroundColor = [UIColor orangeColor];

    self.temperatureLabel.adjustsFontSizeToFitWidth = YES;
    self.conditionTextLabel.adjustsFontSizeToFitWidth = YES;
    self.lastUpdatedLabel.adjustsFontSizeToFitWidth = YES;
    
    [self addSubview:self.conditionImageView];
    [self addSubview:self.temperatureLabel];
    [self addSubview:self.conditionTextLabel];
    [self addSubview:self.lastUpdatedLabel];
    [self addSubview:self.windDirLabel];
    [self addSubview:self.windSCLabel];
    self.backgroundColor = [UIColor whiteColor]; //default UIView's backgroundColor is nil.

    [self _setupConstaints];
    [self setNeedsUpdateConstraints]; //Important for the -updateConstraints method to be called.

}

-(void)_setupConstaints
{
    self.conditionImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.temperatureLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.conditionTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.lastUpdatedLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.windDirLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.windSCLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    // self.conditionImage.height=100,
    //Changed to: conditionImage.height =
    //            temperatureLabel.height + conditionTextLabel.height + lastUpdatedLabel.height
    //    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.conditionImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:50]];
    
    //self.conditionImage.width ≤ 150
    // self.conditionImage.height = self.conditionImage.width
    _weatherConditionImageSizeConstaint = [NSLayoutConstraint constraintWithItem:self.conditionImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:0]; //a placeholder, will be updated in -updateConstraint method.
    _weatherConditionImageSizeConstaint.priority = UILayoutPriorityDefaultHigh;
    [self addConstraint:_weatherConditionImageSizeConstaint];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.conditionImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.conditionImageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    
    //1: self.conditionImage.left = superview.left;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.conditionImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.conditionImageView.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    //2: self.conditionImage.right = self.temperatureLabel.left-5
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.conditionImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.temperatureLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-5]];
    //3: self.temperatureLabel.right=superview.right-5
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.temperatureLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.temperatureLabel.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:-5]];
    //4: self.conditionImage.top = superview.top + 10;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.conditionImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.conditionImageView.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    //5: self.temperatureLabel.top = self.conditionImage.top
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.temperatureLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.conditionImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    //6: self.conditionTextLabel.top = self.temperatureLabel.bottom+5
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.conditionTextLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.temperatureLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5]];
    //7: self.lastUpdatedLabel.top = self.conditionTextLabel.bottom+5
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lastUpdatedLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.conditionTextLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5]];
    //self.lastUpdatedLabel.bottom = self.conditionImage.bottom
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self.conditionImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.lastUpdatedLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    c.priority = UILayoutPriorityDefaultHigh;
    [self addConstraint: c];
    
    //8: self.conditionTextLabel.left = self.temperatureLabel.left
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.conditionTextLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.temperatureLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    //self.conditionTextLabel.right = superview.right-5
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.conditionTextLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.conditionTextLabel.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:-5]];
    
    //9: self.lastUpdatedLabel.left = self.coditionTextLabel.left
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lastUpdatedLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.conditionTextLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    //self.lastUpdatedLabel.right = superview.right-5
    [self addConstraint: [NSLayoutConstraint constraintWithItem:self.lastUpdatedLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.lastUpdatedLabel.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:-5]];
    
    
    //6: self.windDirLabel.right = self.conditionImage.right
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.windDirLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.conditionImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    //7: self.windSClabel.left =  = self.windDirLabel.right+5
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.windSCLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.windDirLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:5]];
    //9: self.windDirLabel.top = self.lastUpdatedLabel+5
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.windDirLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.lastUpdatedLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5]];
    //10: self.windDirLabel.bottom = superview.bottom
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.windDirLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.windDirLabel.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    //11: self.windSCLabel.baseline = self.windDirLabel.baseline
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.windSCLabel attribute:NSLayoutAttributeBaseline relatedBy:NSLayoutRelationEqual toItem:self.windDirLabel attribute:NSLayoutAttributeBaseline multiplier:1.0 constant:0]];
    //self.windDirLabel.height = self.windSCLabel.heigth
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.windDirLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.windSCLabel attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    //Set vertical compression resistance
    [self.temperatureLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.conditionTextLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.lastUpdatedLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    //Set horizontal compressing resistance
    [self.temperatureLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.conditionTextLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.lastUpdatedLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    CGFloat conditionImageSize = [[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone ? 100 : 200;
    [_weatherConditionImageSizeConstaint setConstant:conditionImageSize];
    //    [self setNeedsUpdateConstraints];

}

-(void)updateConstraints
{
    [super updateConstraints];
}

+(BOOL)requiresConstraintBasedLayout
{
    return YES;
}

-(void)setWeatherConditionCode:(NSString *)weatherConditionCode
{
    _weatherConditionCode = weatherConditionCode;
    NSString *path = [[NSBundle mainBundle] pathForResource:weatherConditionCode ofType:@"png"];
    self.conditionImageView.image = [UIImage imageNamed:path];
    self.conditionImageView.tintColor = [UIColor grayColor];
}

-(void)setWeatherConditionText:(NSString *)weatherConditionText
{
    _weatherConditionText = weatherConditionText;
    self.conditionTextLabel.text = weatherConditionText;
}
-(void)setLastUpdated:(NSDate *)lastUpdated
{
    _lastUpdated = lastUpdated;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale currentLocale];
    formatter.dateFormat = @"MM-dd HH:mm";
    self.lastUpdatedLabel.attributedText = ({
        NSString *str = [NSString stringWithFormat:@"最后更新 %@", [formatter stringFromDate:lastUpdated]];
        [[NSAttributedString alloc] initWithString:str
                                        attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:[UIFont smallSystemFontSize]],
                                                     NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    });
    
}

-(void)setWeatherTemperature:(NSInteger)weatherTemperature
{
    _weatherTemperature = weatherTemperature;
    [self.temperatureLabel setAttributedText:({
        NSString *tempString0 = [NSString stringWithFormat:@"%ld", (long)weatherTemperature];
        NSString *tempString1 = @"°C";
        NSString *tempString = [tempString0 stringByAppendingString:tempString1];
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:tempString];
        [as addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange([tempString0 length], [tempString1 length])];
        UIFont *font0 = [UIFont boldSystemFontOfSize:80];
        UIFont *font1 = [UIFont boldSystemFontOfSize:32];
        [as addAttribute:NSFontAttributeName value:font0 range:NSMakeRange(0, [tempString length])];
        [as addAttribute:NSFontAttributeName value:font1 range:NSMakeRange([tempString0 length], [tempString1 length])];
        NSNumber *offsetAmount = @([font0 capHeight] - [font1 capHeight]);
        [as addAttribute:NSBaselineOffsetAttributeName value:offsetAmount range:NSMakeRange([tempString0 length], [tempString1 length])];
        
        as;
    })];
    
//    [self.temperatureLabel invalidateIntrinsicContentSize];
    
}

-(void)setWindDir:(NSString *)windDir
{
    _windDir = windDir;
    [self.windDirLabel setAttributedText:({
        [[NSAttributedString alloc] initWithString:windDir
                                        attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                                                     NSForegroundColorAttributeName: [UIColor grayColor]}];
    })];
}

-(void)setWindSC:(NSString *)windSC
{
    _windSC = windSC;
    [self.windSCLabel setAttributedText:({
        [[NSAttributedString alloc] initWithString:windSC
                                        attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                                                     NSForegroundColorAttributeName: [UIColor grayColor]}];
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
