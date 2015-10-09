//
//  UIWindow+Extension.h
//  WindowExtension
//
//  Created by 王俊仁 on 15/9/23.
//  Copyright © 2015年 王俊仁. All rights reserved.
//
//  在window级别的切换控制

#import <UIKit/UIKit.h>

@protocol UIWindowTransitionDelegate <NSObject>

@optional
- (NSTimeInterval)transitionAnimationDuration;
/**
 *  设置container相对于屏幕的frame等属性动画即可/开始和结束都需要设置
 *  complete 需要在动画执行完后必须调用
 */
- (void)pushAnimationWithPreviouseContainer:(UIView *)preContainer newContainer:(UIView *)newContainer complete:(dispatch_block_t)complete;
- (void)popAnimationWithPopContainer:(UIView *)popContainer displayContainer:(UIView *)displayContainer complete:(dispatch_block_t)complete;

@end

@interface UIWindow (Extension)

@property (nonatomic, strong) id<UIWindowTransitionDelegate> delegate;

#pragma mark - Controller的操作
- (void)pushController:(UIViewController *)controller animated:(BOOL)animated;
- (UIViewController *)popControllerWithAnimated:(BOOL)animated;

- (void)popToController:(UIViewController *)controller animated:(BOOL)animated;
- (void)popToRootControllerWithAnimated:(BOOL)animated;

/**
 *  最后以push的方式来展现栈顶的controller
 */
- (void)setControllers:(NSArray *)controllers animated:(BOOL)animated;

#pragma mark - 获取操作
- (NSMutableArray *)stackControllers;
- (UIViewController *)controllerAtIndex:(NSInteger)index;
- (UIViewController *)topController;

@end




