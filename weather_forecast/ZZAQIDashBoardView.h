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

/*!
 * default value: 20 points
 */
@property IBInspectable CGFloat width;

/*!
 * range: 0..360 in degree
 * default value: 45*2=90 degree
 */
@property IBInspectable CGFloat angle;

/*!
 * top, bottom, left, right margin out of the circle
 * default: 10 points
 */
@property IBInspectable CGFloat margin;

@property IBInspectable NSArray<UIColor *> *colors;
@end
