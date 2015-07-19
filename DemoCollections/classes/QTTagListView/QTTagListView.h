//
//  QTTagListView.h
//  DemoCollections
//
//  Created by 王俊仁 on 15/7/18.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QTTagListView;

@protocol QTTagListViewDelegate <NSObject>

@optional

- (void)tagListView:(QTTagListView *)tagListView didSelectedTag:(UIButton *)button atIndex:(NSInteger)index;
- (void)tagListView:(QTTagListView *)tagListView didDeselectedTag:(UIButton *)button atIndex:(NSInteger)index;

@end

@interface QTTagListView : UIView

@property (nonatomic, strong) NSMutableArray        *tagTitles;
@property (nonatomic, assign) UIEdgeInsets          contentInsets;


@property (nonatomic, assign) CGFloat               rowMargin;
@property (nonatomic, assign) CGFloat               columnMargin;

@property (nonatomic, assign) CGFloat               tagHeight;
/**
 *  最多有多少列
 */
@property (nonatomic, assign) NSUInteger            columns;

@property (nonatomic, weak  ) id<QTTagListViewDelegate> delegate;


- (void)reloadTags;

@end
