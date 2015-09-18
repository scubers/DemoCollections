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

#define func_random_color() [UIColor colorWithRed:(float)(arc4random()%10000)/10000.0 green:(float)(arc4random()%10000)/10000.0 blue:(float)(arc4random()%10000)/10000.0 alpha:(float)(arc4random()%10000)/10000.0]



@interface TestViewController () <UINavigationControllerDelegate, UIViewControllerAnimatedTransitioning,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITextView *tv;

@property (nonatomic, weak) UIButton *btn;

@property (nonatomic, assign) NSUInteger cursorLocation;

@property (nonatomic, strong) id content;




@end

@implementation TestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blueColor];
   
    
}


- (void)testUIStackView
{
    UIStackView *stackView = [[UIStackView alloc] init];
    
    [self.view addSubview:stackView];
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(stackView.superview);
        make.top.mas_equalTo(stackView.superview).offset(64);
    }];
    
    NSMutableArray *views = [NSMutableArray array];
    
    for (int i = 0; i < 5; i++)
    {
        UILabel *label = [[UILabel alloc] init];
        label.text = [NSString stringWithFormat:@"%d", i];
        
        label.backgroundColor = func_random_color();
        label.textAlignment = NSTextAlignmentCenter;
        
        [views addObject:label];
        [stackView addArrangedSubview:label];
        
    }
    
    stackView.axis                             = UILayoutConstraintAxisHorizontal;
    stackView.distribution                     = UIStackViewDistributionFillProportionally;
    stackView.alignment                        = UIStackViewAlignmentFill;
    stackView.spacing                          = 3;
    stackView.baselineRelativeArrangement      = YES;
    stackView.layoutMarginsRelativeArrangement = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            UILabel *label         = [[UILabel alloc] init];
            label.backgroundColor  = func_random_color();
            label.textAlignment    = NSTextAlignmentCenter;
            [views addObject:label];
            label.text             = [NSString stringWithFormat:@"%zd", views.count-1];
            [stackView addArrangedSubview:label];
//            stackView.distribution = UIStackViewDistributionFillEqually;
        } completion:nil];
        
        
    });
    
    
}

- (CALayer *)createBall
{
    CALayer *layer = [[CALayer alloc] init];
    
    layer.frame           = CGRectMake(0, 100, 30, 30);
    layer.cornerRadius    = 15;
    layer.backgroundColor = [UIColor blackColor].CGColor;
    
    return layer;
}

- (void)keyFrameAnimationWithPath
{
    CALayer *ball = [self createBall];
    
    [self.view.layer addSublayer:ball];
    
    CAKeyframeAnimation *ka = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    CGPathRef path = CGPathCreateWithEllipseInRect(CGRectMake(0, 100, 100, 100), NULL);
    ka.path = path;
    CGPathRelease(path);
    
    
    ka.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    ka.duration = 1;
    ka.repeatCount = 1000;
    
    [ball addAnimation:ka forKey:@""];
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
