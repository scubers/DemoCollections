//
//  QTSelectionView.h
//
//  Created by 王俊仁 on 15/7/11.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QTSelectionView;

/**
 *  代理
 */
@protocol QTSelectionViewDelegate <NSObject>
@optional
- (UIView *)selectionView:(QTSelectionView *)selectionView viewAtIndex:(NSInteger)index;
- (UIView *)markViewForSelectionView:(QTSelectionView *)selectionView;

- (void)selectionView:(QTSelectionView *)selectionView
      didSelectedFrom:(UIView *)fromView
              onIndex:(NSInteger)from
               toView:(UIView *)toView
              onIndex:(NSInteger)toIndex;
@end


/**
 *  数据源
 */
@protocol QTSelectionViewDataSource <NSObject>
@required
- (NSInteger)numberOfSelectionsInSelectionView:(QTSelectionView *)selectionView;
- (CGSize)selectionView:(QTSelectionView *)selectionView sizeForSelectionsAtIndex:(NSInteger)index;


@optional
- (NSInteger)marginForEachSelectionsInSelectionView:(QTSelectionView *)selectionView;
- (NSInteger)centeyYForMarkViewInSelectionView:(QTSelectionView *)selectionView;

@end


@interface QTSelectionView : UIView

@property (nonatomic, weak) id<QTSelectionViewDelegate> delegate;
@property (nonatomic, weak) id<QTSelectionViewDataSource> dataSource;

@property (nonatomic, assign, readonly) int selectedIndex;
@property (nonatomic, assign, readonly) int selectionMargin;

@property (nonatomic, assign, getter=isMarViewHidden) BOOL markViewHidden;
@property (nonatomic, assign, getter=isScrollable) BOOL scrollable;

@property (nonatomic, assign) UIEdgeInsets contentInsets;

- (void)reloadSelections;
- (void)scrollToIndex:(NSInteger)index;

@end








