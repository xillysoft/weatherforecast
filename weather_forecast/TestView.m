//
//  TestVie.m
//  weather_forecast
//
//  Created by zhaoxiaojian on 11/12/16.
//  Copyright © 2016 Zhao Xiaojian. All rights reserved.
//

#import "TestView.h"

@interface TestViewLayerDelegate : NSObject
@property UIImage *image;
@end

@implementation TestViewLayerDelegate

-(void)displayLayer:(CALayer *)layer
{
    if(self.image == nil){
        [super displayLayer:layer];
        return ;
    }
    layer.contents = (__bridge id)[self.image CGImage];
    layer.contentsGravity = kCAGravityResizeAspectFill;
}

//Note: the layer's -setNeedsDisplay must be called to have this delegate method called.
-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    CGRect frame = [layer frame];
    CGFloat strokeWidth = 5;
    CGContextAddEllipseInRect(ctx, CGRectMake(strokeWidth, strokeWidth, frame.size.width-strokeWidth*2, frame.size.height-strokeWidth*2));
    CGContextSetStrokeColorWithColor(ctx, [[UIColor redColor] CGColor]);
    CGContextSetLineWidth(ctx, 5);
    CGContextSetFillColorWithColor(ctx, [[UIColor greenColor] CGColor]);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    UIGraphicsPushContext(ctx);
    {
        NSString *str = NSStringFromCGRect(frame);
        NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                     NSFontAttributeName: [UIFont boldSystemFontOfSize:17]};
        CGSize textSize = [str sizeWithAttributes:attributes];
        [str drawAtPoint:CGPointMake((frame.size.width-textSize.width)/2, (frame.size.height-textSize.height)/2) withAttributes:attributes];
        NSString *str2 = [NSString stringWithFormat:@"actions=[%@]", [layer animationForKey:@"bounds"]];
        [str2 drawAtPoint:CGPointMake(50, 100) withAttributes:attributes];
    }
    UIGraphicsPopContext();
}

@end


@interface TestView()

@property CALayer *sublayer1;
@property TestViewLayerDelegate *layerDelegate;

@end


@implementation TestView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self _initView];
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self _initView];
    return self;
}

-(void)_initView
{
    self.sublayer1 = [CALayer layer];
    self.sublayer1.frame = CGRectMake(20, 20, 150, 100);
    self.sublayer1.backgroundColor = [[UIColor purpleColor] CGColor];
    self.sublayer1.cornerRadius = 5;
    //    self.sublayer1.masksToBounds = YES;
    self.sublayer1.shadowColor = [[UIColor grayColor] CGColor];
    self.sublayer1.shadowOffset = CGSizeMake(5, -5);
    self.sublayer1.shadowRadius = 5;
    self.sublayer1.shadowOpacity = 1.0;
    
    //Note: Don't assign sublayer's delegate as the view itself. the view already is the delegate of its own layer, it cannot be the delegate of more than one CALayer objects at once.
//    self.sublayer1.delegate = self;
    self.layerDelegate = [[TestViewLayerDelegate alloc] init];
//    self.sublayer1.delegate = self.layerDelegate;
    self.sublayer1.contents = (__bridge id)[self.image CGImage];
    
    [self.layer addSublayer:self.sublayer1];
    [self.sublayer1 setNeedsDisplay]; //IMPORTANT to have delegate's -drawLayer:inContext: get called.
    
    self.layer.borderWidth = 2.0;
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
}

-(void)layoutSublayersOfLayer:(CALayer *)layer
{
    if(layer == self.layer){
        CGSize size = self.layer.bounds.size;
        self.sublayer1.frame = CGRectMake(size.width/10, size.height/10, size.width*8/10, size.height*8/10);
    }
    
}

-(void)setImage:(UIImage *)image
{
    _image = image;
    self.layerDelegate.image = image;
    [self.sublayer1 setNeedsDisplay];
}

@end
