//
//  ZZGradientColoredView.h
//  weather_forecast
//
//  Created by zhaoxiaojian on 11/7/16.
//  Copyright © 2016 Zhao Xiaojian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, ZZGradientColoredViewDirection){
    ZZGradientColoredViewDirectionHorizontal,
    ZZGradientColoredViewDirectionVertical
};


@interface ZZGradientColoredView : UIView

@property(readwrite) ZZGradientColoredViewDirection direction;
@property(readwrite) UIColor *colorStart;
@property(readwrite) UIColor *colorEnd;

@end
