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

/*!
 * Set AQI value, quality text, pm25 value, pm10 value.
 * AQI will be clampt to range [0..500]
 */
-(void)setAQI:(NSNumber *)aqi quality:(NSString *)quality pm25:(NSNumber *)pm25 pm10:(NSNumber *)pm10;

//REMOVE IT.
@property(nonatomic) IBInspectable CGFloat aqiValue; //TODO: test only, remove it.

/*!
 * default value: 45*2=90 degree
 * range: 0..360 in degree
 */
@property(nonatomic) IBInspectable CGFloat angle;

/*!
 * with of the circle
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

/*!
 * the colors for 10 AQI segments
 */
@property(nonatomic) IBInspectable NSArray<UIColor *> *colors;

@end
