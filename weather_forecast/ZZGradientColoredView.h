//
//  ZZGradientColoredView.h
//  weather_forecast
//
//  Created by zhaoxiaojian on 11/7/16.
//  Copyright © 2016 Zhao Xiaojian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, ZZGradientColoredViewDirection){
    ZZGradientColoredViewDirectionAutomatical,
    ZZGradientColoredViewDirectionHorizontal,
    ZZGradientColoredViewDirectionVertical
};

IB_DESIGNABLE
@interface ZZGradientColoredView : UIView

@property(readwrite, nonatomic) IBInspectable ZZGradientColoredViewDirection direction;

@property(readwrite, nonatomic) IBInspectable UIColor *colorStart;
@property(readwrite, nonatomic) IBInspectable UIColor *colorEnd;

@end
