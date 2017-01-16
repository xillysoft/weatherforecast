//
//  ZZAQIDashBoardView2.h
//  weather_forecast
//
//  Created by zhaoxiaojian on 1/16/17.
//  Copyright © 2017 Zhao Xiaojian. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface ZZAQIDashBoardView2 : UIView

@property(nonatomic) IBInspectable CGFloat blankAngle; //default: M_PI/2
@property(nonatomic) IBInspectable CGFloat circleWidth; //default: 50.0

@property(nonatomic) IBInspectable CGFloat aqiValue; //must be within range from _minAQIValue to _maxAQIValue
@property(nonatomic) IBInspectable CGFloat aqiMarkSize; //default: 10.0

@end
