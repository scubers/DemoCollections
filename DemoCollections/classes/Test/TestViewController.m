//
//  TestViewController.m
//  DemoCollections
//
//  Created by mima on 15/8/5.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "TestViewController.h"
#import "UIView+Extension.h"
#import "Masonry.h"
#import "ReactiveCocoa.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import <objc/runtime.h>
#import "BlocksKit.h"
#import "POP.h"




@interface TestViewController ()

@property (nonatomic, strong) UITextView *tv;

@property (nonatomic, weak) UIButton *btn;

@property (nonatomic, assign) NSUInteger cursorLocation;

@property (nonatomic, strong) id content;

@end

@implementation TestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (CALayer *)createBall
{
    CALayer *layer = [[CALayer alloc] init];
    
    layer.frame           = CGRectMake(0, 100, 30, 30);
    layer.cornerRadius    = 15;
    layer.backgroundColor = [UIColor blackColor].CGColor;
    
    return layer;
}

- (void)keyFrameAnimationTest
{
    CALayer *ball = [self createBall];
    
    [self.view.layer addSublayer:ball];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    
    CAKeyframeAnimation *ka = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    ka.values = @[
                  [NSValue valueWithCGPoint:ball.frame.origin],
                  [NSValue valueWithCGPoint:CGPointMake(100, 100)],
                  [NSValue valueWithCGPoint:CGPointMake(100, 300)],
                  [NSValue valueWithCGPoint:ball.frame.origin],
                  ];
    ka.timingFunctions = @[
                           [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                           [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                           [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                           [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                           ];
    ka.keyTimes = @[
                    @(0.0),
                    @(0.5),
                    @(0.9),
                    @(1.0),
                    ];
    //    ka.repeatCount = 1000;
    //    ka.duration = 5;
    
    
    CABasicAnimation *ba = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    ba.toValue = @(0);
    ba.duration = 2.5;
    
    //    CABasicAnimation *ba2 = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    //    ba.toValue = @(15);
    //    ba.duration = 2.5;
    //    ba.beginTime = 2.5;
    
    [group setAnimations:@[ka, ba]];
    
    group.duration = 5;
    group.repeatCount = 1000;
    
    //    [ball addAnimation:ka forKey:@"abc"];
    [ball addAnimation:group forKey:@"group"];
}

- (void)dealloc
{
    NSLog(@"");
}


@end
