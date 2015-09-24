//
//  UIWindow+Extension.h
//  WindowExtension
//
//  Created by 王俊仁 on 15/9/23.
//  Copyright © 2015年 王俊仁. All rights reserved.
//
//  在window级别的切换控制器

#import <UIKit/UIKit.h>

@interface UIWindow (Extension)

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




