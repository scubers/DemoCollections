//
//  QTMultiTableView.h
//  DemoCollections
//
//  Created by 王俊仁 on 15/7/12.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QTMultiTableView;
/**
 *  代理
 */
@protocol QTMultiTableViewDelegate <NSObject>
@optional
- (UITableView *)tableViewForMultiTableView:(QTMultiTableView *)multiTableView atIndex:(NSInteger)index;

@end


/**
 *  数据源
 */
@protocol QTMultiTableViewDataSource <NSObject>

@required
- (NSInteger)numberOfTableViewInMultiTableView:(QTMultiTableView *)multiTableView;

@end



@interface QTMultiTableView : UIView

@property (nonatomic, weak) id<QTMultiTableViewDelegate> delegate;
@property (nonatomic, weak) id<QTMultiTableViewDataSource> dataSource;


- (void)reloadTableViews;

@end
