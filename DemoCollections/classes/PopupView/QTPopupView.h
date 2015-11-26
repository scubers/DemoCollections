//
//  QTPopupView.h
//  DemoCollections
//
//  Created by 王俊仁 on 15/11/3.
//  Copyright © 2015年 王俊仁. All rights reserved.
//

#import <UIKit/UIKit.h>

#define func_random_color() [UIColor colorWithRed:(float)(arc4random()%10000)/10000.0 green:(float)(arc4random()%10000)/10000.0 blue:(float)(arc4random()%10000)/10000.0 alpha:(float)(arc4random()%10000)/10000.0]

@class QTPopupView;

typedef enum
{
    QTPopupViewArrowPointToTop,
    QTPopupViewArrowPointToLeft,
    QTPopupViewArrowPointToBottom,
    QTPopupViewArrowPointToRight,
    
}QTPopupViewArrowPointTo;

#pragma mark - QTPopupViewDelegate

@protocol QTPopupViewDelegate <NSObject>

@optional
- (void)popupView:(QTPopupView *)popupView didSelectItemAtIndex:(NSIndexPath *)indexPath;

@end

typedef void(^QTPopupViewCompleteBlock)(QTPopupView *popupView, NSIndexPath *indexPath);

#pragma mark - QTPopupView
@interface QTPopupView : UIView

@property (nonatomic, weak) id<QTPopupViewDelegate> delegate;

@property (nonatomic, strong) UITableView             *tableView;///< 内部菜单列表tableView，可自省替换

@property (nonatomic, assign) CGFloat                 itemFontSize;///< 菜单字体大小，自定义tableView后失效
@property (nonatomic, assign) CGFloat                 itemRowHieght;///< 菜单行高大小，自定义tableView后失效
@property (nonatomic, strong) UIColor                 *itemTextColor;

@property (nonatomic, assign) CGFloat                 arrowPosition;///< 箭头的处于边沿的位置0~1之间

@property (nonatomic, assign) UIEdgeInsets            contentInsets;

@property (nonatomic, assign) QTPopupViewArrowPointTo arrowPointTo;///< 箭头指向方向


- (instancetype)initWithTitles:(NSArray<NSString *> *)titles
                        inView:(UIView *)view
                       atPoint:(CGPoint)point
                   contentSize:(CGSize)contentSize
                      complete:(QTPopupViewCompleteBlock)complete;

- (instancetype)initWithTitleAndIcons:(NSArray<NSDictionary<NSString *, UIImage *> *> *)infos
                               inView:(UIView *)view
                              atPoint:(CGPoint)point
                          contentSize:(CGSize)contentSize
                             complete:(QTPopupViewCompleteBlock)complete;



- (void)show;
- (void)dismiss;

@end
