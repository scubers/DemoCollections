//
//  NavigationAnimationDemo.m
//  DemoCollections
//
//  Created by mima on 15/9/18.
//  Copyright © 2015年 王俊仁. All rights reserved.
//

#import "NavigationAnimationDemo.h"
#import "ReactiveCocoa.h"

#define func_random_color() [UIColor colorWithRed:(float)(arc4random()%10000)/10000.0 green:(float)(arc4random()%10000)/10000.0 blue:(float)(arc4random()%10000)/10000.0 alpha:(float)(arc4random()%10000)/10000.0]

@interface NavigationAnimationDemo()<UINavigationControllerDelegate, UIViewControllerAnimatedTransitioning,UIGestureRecognizerDelegate>

@property (nonatomic, assign) UINavigationControllerOperation operation;

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactiveTransition;

@end

@implementation NavigationAnimationDemo

- (void)viewDidLoad
{
    
    self.view.backgroundColor = func_random_color();
    
    
    self.navigationController.delegate = self;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    
    button.center = self.view.center;
    
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        UIViewController *vc = [[NavigationAnimationDemo alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.view addSubview:button];
    
    [self addHandler];
    
    NSArray *array = self.navigationController.view.subviews;
    
    NSLog(@"%@", array);
}


- (void)addHandler
{
    // 添加一个滑动返回手势
    UIScreenEdgePanGestureRecognizer *popReco = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePop:)];
    popReco.edges = UIRectEdgeLeft;
    [self.navigationController.view addGestureRecognizer:popReco];
    
}



- (void)handlePop:(UIScreenEdgePanGestureRecognizer *)reco
{
    CGFloat progress = [reco translationInView:reco.view].x / reco.view.bounds.size.width;
    
    progress = MIN(1.0, MAX(0.0, progress));
    
    NSLog(@"%f", progress);
    
    if (reco.state == UIGestureRecognizerStateBegan)
    {
        self.interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(reco.state == UIGestureRecognizerStateChanged)
    {
        [self.interactiveTransition updateInteractiveTransition:progress];
        
    }
    else if(reco.state == UIGestureRecognizerStateEnded || reco.state == UIGestureRecognizerStateCancelled)
    {
        if (progress > 0.5)
        {
            [self.interactiveTransition finishInteractiveTransition];
        }
        else
        {
            [self.interactiveTransition cancelInteractiveTransition];
        }
        self.interactiveTransition = nil;
    }
    
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interactiveTransition;
}

/**
 *  返回转场动画时间
 */
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

/**
 *  返回一个UIVIewControllerAnimatedTranstioning, 这个对象主要主责在navigation转场是的动画内容
 */
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    self.operation = operation;
    return self;
}

/**
 *  转场动画具体实现的地方
 */
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // 每个transitionContext都包含着一个containerView，所有动画都需要在这个view里面进行
    UIView *containerView = [transitionContext containerView];
    
    UIViewController *fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *destView = nil;
    CGAffineTransform destTransForm;
    if (self.operation == UINavigationControllerOperationPush)
    {
        [containerView insertSubview:toController.view aboveSubview:fromController.view];
        destView           = toController.view;
        destView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        destTransForm      = CGAffineTransformMakeScale(1, 1);
    }
    if (self.operation == UINavigationControllerOperationPop)
    {
        [containerView insertSubview:toController.view belowSubview:fromController.view];
        
        destView = fromController.view;
        
        self.navigationController.delegate = toController;
        
        destTransForm = CGAffineTransformMakeScale(0.1, 0.1);
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        destView.transform = destTransForm;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
    
    
}


@end
