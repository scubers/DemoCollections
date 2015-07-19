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
    QTPickerModeCoustom

}QTPickerMode;

typedef enum
{

    QTPickerAnimateDirectionTop,
    QTPickerAnimateDirectionLeft,
    QTPickerAnimateDirectionBottom,
    QTPickerAnimateDirectionRight

} QTPickerAnimateDirection;

@class QTPickerView;

typedef void(^QTCancelButtonAction)(QTPickerView *pickerView);
typedef void(^QTConfirmButtonAction)(QTPickerView *pickerView);

@protocol QTPickerViewDelegate <UIPickerViewDelegate>

@optional
- (UIView *)viewForMiddleBarInPickerView:(QTPickerView *)pickerView;
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

@property (nonatomic, copy) QTCancelButtonAction cancelBlock;
@property (nonatomic, copy) QTConfirmButtonAction confirmBlock;

@property (nonatomic, assign) QTPickerMode pickerMode;

@property (nonatomic, assign) QTPickerAnimateDirection animateDirection;

- (instancetype)initWithPickerMode:(QTPickerMode)pickerMode;

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
