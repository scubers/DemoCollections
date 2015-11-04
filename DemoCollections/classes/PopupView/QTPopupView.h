//
//  QTPopupView.h
//  DemoCollections
//
//  Created by 王俊仁 on 15/11/3.
//  Copyright © 2015年 王俊仁. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QTPopupView;

#pragma mark - QTPopupViewDelegate

@protocol QTPopupViewDelegate <NSObject>

@optional - (void)popupView:(QTPopupView *)popupView didSelectItemAtIndex:(NSIndexPath *)indexPath;

@end



#pragma mark - QTPopupView
@interface QTPopupView : UIView

@property (nonatomic, weak) id<QTPopupViewDelegate> delegate;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) CGFloat itemFontSize;
@property (nonatomic, assign) CGFloat itemRowHieght;

@property (nonatomic, assign) CGFloat arrowPosition;///< 头顶箭头的处于中间的位置0~1之间


- (instancetype)initWithTitles:(NSArray *)titles
                        inView:(UIView *)view
                       atPoint:(CGPoint)point
                   contentSize:(CGSize)contentSize;

- (void)dismiss;

@end
