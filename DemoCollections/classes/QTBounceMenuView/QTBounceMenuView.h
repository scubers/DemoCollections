//
//  QTBounceMenuView.h
//  DemoCollections
//
//  Created by mima on 15/11/12.
//  Copyright © 2015年 王俊仁. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QTBounceMenuView;

@protocol QTBounceMenuViewDelegate <NSObject>

@required
- (NSInteger)numberOfItemForBounceMenuView:(QTBounceMenuView *)bounceMenuView;


@optional
- (UIView *)bounceMenuView:(QTBounceMenuView *)bounceMenuView viewForItemAtIndex:(NSInteger)index;

- (void)bounceMenuView:(QTBounceMenuView *)bounceMenuView didSelectItemAtIndex:(NSInteger)index;
/**
 *  可选实现,不实现则使用默认布局
 */
- (CGRect)frameForItemInBounceMenuView:(QTBounceMenuView *)bounceMenuView atIndex:(NSInteger)index;
@end

@interface QTBounceMenuView : UIView

@property (nonatomic, weak  ) id<QTBounceMenuViewDelegate> delegate;

@property (nonatomic, assign) UIEdgeInsets             contentInsets;

@property (nonatomic, assign) CGFloat                  lineGap;
@property (nonatomic, assign) int                      totalColumn;
@property (nonatomic, assign) CGSize                   baseItemSize;

- (void)showAtView:(UIView *)view complete:(void (^)(QTBounceMenuView *bounceMenuView))complete;
- (void)dismissMenuView;

@end
