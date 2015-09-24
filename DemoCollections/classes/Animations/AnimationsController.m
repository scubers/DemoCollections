//
//  AnimationsController.m
//  DemoCollections
//
//  Created by mima on 15/9/18.
//  Copyright © 2015年 王俊仁. All rights reserved.
//

#import "AnimationsController.h"
#import "BlocksKit.h"

@interface AnimationsController()

@end

@implementation AnimationsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    shapeLayer.frame = CGRectMake(20, 100, 200, 200);
    shapeLayer.lineCap = @"round";
    shapeLayer.lineWidth = 10;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    shapeLayer.strokeColor = [UIColor purpleColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    path.lineJoinStyle = kCGLineCapRound;
    path.usesEvenOddFillRule = YES;
    
    [path moveToPoint:CGPointMake(20, 100)];
    
    [path addLineToPoint:CGPointMake(20, 300)];
    [path addLineToPoint:CGPointMake(220, 300)];
    [path addLineToPoint:CGPointMake(220, 100)];
//    [path addLineToPoint:CGPointMake(20, 100)];
    [path addCurveToPoint:CGPointMake(20, 100) controlPoint1:CGPointMake(200, 60) controlPoint2:CGPointMake(40, 170)];
    
    shapeLayer.path = path.CGPath;

    shapeLayer.strokeStart = 0;
    shapeLayer.strokeEnd = 0;
    
    [self.view.layer addSublayer:shapeLayer];
    
    __block CGFloat end = 0;
    [NSTimer bk_scheduledTimerWithTimeInterval:.1 block:^(NSTimer *timer) {
        if (end > 1)
        {
            [timer invalidate];
            [self secondAnimate];
        }
        shapeLayer.strokeEnd = end;
        end += 0.05;
    } repeats:YES];
    

}

- (void)secondAnimate
{
    
    
}

@end









