//
//  ZZAQIView.h
//  weather_forecast
//
//  Created by zhaoxiaojian on 11/10/16.
//  Copyright © 2016 Zhao Xiaojian. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface ZZAQIDashBoardView : UIView

-(void)setAQI:(NSNumber *)aqi quality:(NSString *)quality pm25:(NSNumber *)pm25 pm10:(NSNumber *)pm10;
@property(nonatomic) IBInspectable CGFloat aqiValue;

/*!
 * default value: 45*2=90 degree
 * range: 0..360 in degree
 */
@property(nonatomic) IBInspectable CGFloat angle;

/*!
 * default value: 40 points
 */
@property(nonatomic) IBInspectable CGFloat width;

/*!
 * default value: 10 points
 */
@property(nonatomic) IBInspectable CGFloat indicatorSize;

/*!
 * top, bottom, left, right margin out of the circle
 * default: 5 points
 */
@property(nonatomic) IBInspectable CGFloat margin;

@property(nonatomic) IBInspectable NSArray<UIColor *> *colors;

@end
