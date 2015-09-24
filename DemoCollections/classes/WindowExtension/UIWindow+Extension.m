//
//  UIWindow+Extension.m
//  WindowExtension
//
//  Created by 王俊仁 on 15/9/23.
//  Copyright © 2015年 王俊仁. All rights reserved.
//

#import "UIWindow+Extension.h"
#import <objc/runtime.h>

#define BaseTag 9090
#define AnimationTime 0.5
#define ScreenBounce [UIScreen mainScreen].bounds


#pragma mark - 内部使用的ContainerView

@class UIWindowContainerView;

@protocol UIWindowContainerViewDelegate <NSObject>

@optional
- (void)windowContainer:(UIWindowContainerView *)container didPan:(UIPanGestureRecognizer *)recognizer;

@end

@interface UIWindowContainerView : UIView

@property (nonatomic, weak) id<UIWindowContainerViewDelegate> delegate;

@end

@implementation UIWindowContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)pan:(UIPanGestureRecognizer *)reco
{
    if (_delegate && [_delegate respondsToSelector:@selector(windowContainer:didPan:)])
    {
        [_delegate windowContainer:self didPan:reco];
    }
}


@end


#pragma mark - UIWindow分类实现
static const NSString *WindowControllersKey         = @"WindowControllersKey";
static const NSString *WindowContainerViewsKey      = @"WindowContainerViewsKey";

@interface UIWindow() <UIWindowContainerViewDelegate>

/**
 *  对应push出来的控制器栈
 */
@property (nonatomic, strong) NSMutableArray *controllers;
/**
 *  对应push出来的控制器所在的containerView栈
 */
@property (nonatomic, strong) NSMutableArray *containerViews;

@end

@implementation UIWindow (Extension)

#pragma mark - Controller的操作
- (void)pushController:(UIViewController *)controller animated:(BOOL)animated
{
    NSMutableArray *array = self.controllers;

    [array addObject:controller];

    [self handlePush:animated complete:nil];

}

- (UIViewController *)popControllerWithAnimated:(BOOL)animated
{
    if (self.controllers.count < 2)
    {
        return nil;
    }

    UIViewController *popController = self.controllers.lastObject;

    [self handlePop:animated complete:nil];

    return popController;
}

- (void)popToController:(UIViewController *)controller animated:(BOOL)animated
{
    if (self.controllers.count < 2)
    {
        return;
    }

    [self.controllers enumerateObjectsUsingBlock:^(UIViewController *cl, NSUInteger idx, BOOL * _Nonnull stop) {

        if (controller == cl)
        {
            // 处理controller栈
            NSMutableArray *newControllers = [[self.controllers subarrayWithRange:NSMakeRange(0, idx + 1)] mutableCopy];
            [newControllers addObject:self.controllers.lastObject];
            self.controllers = newControllers;

            // 处理container栈
            NSMutableArray *newContainers = [[self.containerViews subarrayWithRange:NSMakeRange(0, idx + 1)] mutableCopy];
            [newContainers addObject:self.containerViews.lastObject];
            self.containerViews = newContainers;

            // pop一次
            [self popControllerWithAnimated:animated];

            *stop = YES;
        }

    }];

}

- (void)popToRootControllerWithAnimated:(BOOL)animated
{
    if (self.controllers.count < 2)
    {
        return;
    }

    NSMutableArray *newControllers = [@[self.controllers.firstObject, self.controllers.lastObject] mutableCopy];

    self.controllers = newControllers;

    NSMutableArray *newContainers = [@[self.containerViews.firstObject, self.containerViews.lastObject] mutableCopy];

    self.containerViews = newContainers;

    [self handlePop:animated complete:nil];
}


/**
 *  最后以push的方式来展现栈顶的controller
 */
- (void)setControllers:(NSArray *)controllers animated:(BOOL)animated
{

    [self pushController:controllers.lastObject animated:animated];

    [self setControllers:[NSMutableArray arrayWithArray:controllers]];

    UIWindowContainerView *lastContainer = self.containerViews.lastObject;
    self.containerViews = nil;

    // 重置内存中container栈
    [controllers enumerateObjectsUsingBlock:^(UIViewController *controller, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == controllers.count-1)
        {
            [self.containerViews addObject:lastContainer];
            *stop = YES;
        }
        else
        {
            UIWindowContainerView *container = [[UIWindowContainerView alloc] initWithFrame:CGRectMake(ScreenBounce.origin.x - 100, ScreenBounce.origin.y, ScreenBounce.size.width, ScreenBounce.size.height)];
            container.delegate = self;

            [container addSubview:controller.view];

            [self.containerViews addObject:container];

        }
    }];

}

#pragma mark - 获取操作
- (NSMutableArray *)stackControllers
{
    return self.controllers;
}

- (UIViewController *)controllerAtIndex:(NSInteger)index
{
    return [self.controllers objectAtIndex:index];
}
- (UIViewController *)topController
{
    return self.controllers.lastObject;
}


#pragma mark - 私有方法
- (void)handlePush:(BOOL)animated complete:(dispatch_block_t)complete
{
    CGRect rect = [UIScreen mainScreen].bounds;

    // 初始化一个容器并将需要push的view添加到其子view中
    UIWindowContainerView *nextContainer = [[UIWindowContainerView alloc] initWithFrame:CGRectMake(rect.size.width, rect.origin.y, rect.size.width, rect.size.height)];
    nextContainer.delegate = self;

    [nextContainer addSubview:[self.controllers.lastObject view]];
    // 将容器添加到window中
    [self addSubview:nextContainer];

    //TODO: 需要同时操作上一个controller的container
    UIWindowContainerView *preContainer;
    if (self.containerViews.count)
    {
        preContainer = self.containerViews.lastObject;
    }

    // 将容器放入索引中
    [self.containerViews addObject:nextContainer];

    [UIView animateWithDuration:animated?AnimationTime:0 animations:^{
        nextContainer.frame = rect;
        if (preContainer)
        {
            preContainer.frame = CGRectMake(rect.origin.x - 100, rect.origin.y, rect.size.width, rect.size.height);
        }
    } completion:^(BOOL finished) {

        [preContainer removeFromSuperview];

        if (complete) complete();

    }];


}

- (void)handlePop:(BOOL)animated complete:(dispatch_block_t)complete
{
    NSLog(@"====> container count %zd", self.containerViews.count);
    NSLog(@"====> controller count %zd", self.controllers.count);

    if (self.controllers.count < 2)
    {
        return;
    }

    UIWindowContainerView *popContainer = self.containerViews.lastObject;
    UIWindowContainerView *displayContainer = [self.containerViews objectAtIndex:self.containerViews.count-2];

    [self insertSubview:displayContainer belowSubview:popContainer];

    // 执行动画
    CGRect rect = [UIScreen mainScreen].bounds;
    [UIView animateWithDuration:animated?AnimationTime:0 animations:^{

        displayContainer.frame = rect;
        popContainer.frame = CGRectMake(rect.size.width, rect.origin.y, rect.size.width, rect.size.height);

    } completion:^(BOOL finished) {

        [self.containerViews.lastObject removeFromSuperview];
        [self.containerViews removeLastObject];
        [self.controllers removeLastObject];

        if (complete) complete();
    }];
}

#pragma mark - UIWindowContainerViewDelegate
- (void)windowContainer:(UIWindowContainerView *)container didPan:(UIPanGestureRecognizer *)recognizer
{
    if (self.controllers.count < 2)
    {
        return;
    }

    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        UIWindowContainerView *preContainer = [self.containerViews objectAtIndex:self.containerViews.count - 2];
        [self insertSubview:preContainer belowSubview:self.containerViews.lastObject];
    }

    if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [recognizer translationInView:recognizer.view];
    }

    if (recognizer.state == UIGestureRecognizerStateFailed
        || recognizer.state == UIGestureRecognizerStateCancelled)
    {

    }


    [recognizer setTranslation:CGPointZero inView:recognizer.view];

    NSLog(@"state %zd", recognizer.state);

}

#pragma mark - Getter Setter
- (void)setControllers:(NSMutableArray *)controllers
{
    objc_setAssociatedObject(self, (__bridge const void *)(WindowControllersKey), controllers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableArray *)controllers
{
    NSMutableArray *controllers = (NSMutableArray *)objc_getAssociatedObject(self, (__bridge const void *)(WindowControllersKey));

    if (!controllers)
    {
        controllers = [NSMutableArray array];
        [self setControllers:controllers];
        return [self controllers];
    }

    return controllers;
}

- (void)setContainerViews:(NSMutableArray *)containerViews
{
    objc_setAssociatedObject(self, (__bridge const void *)(WindowContainerViewsKey), containerViews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)containerViews
{
    NSMutableArray *containerViews = (NSMutableArray *)objc_getAssociatedObject(self, (__bridge const void *)(WindowContainerViewsKey));

    if (!containerViews)
    {
        containerViews = [NSMutableArray array];
        [self setContainerViews:containerViews];
    }

    return containerViews;
}

@end





