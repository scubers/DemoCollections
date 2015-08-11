//
//  QTPickerView.h
//  DemoCollections
//
//  Created by 王俊仁 on 15/7/19.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    QTPickerModeDate,
    QTPickerModeDateAndTime,
    QTPickerModeCountDownTimer,
    QTPickerModeCustomize

}QTPickerMode;

typedef enum
{

    QTPickerAnimateDirectionTop,
    QTPickerAnimateDirectionLeft,
    QTPickerAnimateDirectionBottom,
    QTPickerAnimateDirectionRight

} QTPickerAnimateDirection;

@class QTPickerView;

typedef void(^CompleteHandler)(QTPickerView *pickerView, BOOL isConfirm);


typedef void(^QTCancelButtonAction)(QTPickerView *pickerView);
typedef void(^QTConfirmButtonAction)(QTPickerView *pickerView);

@protocol QTPickerViewDelegate <UIPickerViewDelegate>

@optional
- (UIView *)viewForMiddleBarInPickerView:(QTPickerView *)pickerView;
- (UIView *)viewForBottomInPickerView:(QTPickerView *)pickerView;


- (void)pickerViewDidConfirm:(QTPickerView *)pickerView;
- (void)pickerViewDidCancel:(QTPickerView *)pickerView;

@end


@protocol QTPickerViewDateSource <UIPickerViewDataSource>

@optional

@end

@interface QTPickerView : UIView

@property (nonatomic, weak) id<QTPickerViewDelegate> delegate;
@property (nonatomic, weak) id<QTPickerViewDateSource> dataSource;

@property (nonatomic, assign) CGFloat heightForMiddleBar;
@property (nonatomic, assign) CGFloat heightForBottomView;

@property (nonatomic, copy) QTCancelButtonAction cancelBlock;
@property (nonatomic, copy) QTConfirmButtonAction confirmBlock;

@property (nonatomic, assign) QTPickerMode pickerMode;

@property (nonatomic, assign) QTPickerAnimateDirection animateDirection;

/**
 *  初始化，本初始化需要使用代理来处理确认
 */
- (instancetype)initWithPickerMode:(QTPickerMode)pickerMode;
/**
 *  本初始化不需要代理，直接使用Block调用
 */
- (instancetype)initWithPickerMode:(QTPickerMode)pickerMode withBlock:(CompleteHandler)handler;

/**
 *  返回内部包装的pickerView,或者UIDatePicker
 */
- (UIView *)pickerView;
/**
 *  返回delegate设置的中间栏View
 */
- (UIView *)middleBarView;

- (void)showWithDirection:(QTPickerAnimateDirection)direction;
- (void)hideWithDirection:(QTPickerAnimateDirection)direction;

- (void)show;
- (void)hide;

@end
