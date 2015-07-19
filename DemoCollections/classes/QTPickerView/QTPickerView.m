//
//  QTPickerView.m
//  DemoCollections
//
//  Created by 王俊仁 on 15/7/19.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "QTPickerView.h"
#import "POP+MCAnimate.h"

#define QTPickerViewTopBarHeight 50

#define QTPickerViewCoverTag 989898

@interface QTPickerView()

@property (nonatomic, weak) UIView *topBar;

@property (nonatomic, weak) UIButton *cancelButton;
@property (nonatomic, weak) UIButton *confirmButton;

@property (nonatomic, weak) UIView *middleBar;
@property (nonatomic, weak) UIView *middleBarView;

@property (nonatomic, weak) UIPickerView *pickerView;

@property (nonatomic, weak) UIDatePicker *datePicker;

@end

@implementation QTPickerView

#pragma mark - 生命周期
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.layer.cornerRadius = 5;
        self.clipsToBounds      = YES;
        self.backgroundColor    = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];

        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithPickerMode:(QTPickerMode)pickerMode
{
    QTPickerView *pickerView = [[QTPickerView alloc] init];

    pickerView.pickerMode = pickerMode;

    return pickerView;
}

- (void)setupSubviews
{

    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    //初始化上面确认条
    {
        UIView *topBar = [[UIView alloc] init];

        topBar.backgroundColor = [UIColor lightGrayColor];

        [self addSubview:topBar];
        _topBar = topBar;

        //初始化取消和确认按钮
        {
            UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];

            [cancelButton addTarget:self
                             action:@selector(cancelButtonClick:)
                   forControlEvents:UIControlEventTouchUpInside];

            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];

            [_topBar addSubview:cancelButton];
            _cancelButton = cancelButton;



            UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];

            [confirmButton addTarget:self
                             action:@selector(confirmButtonClick:)
                   forControlEvents:UIControlEventTouchUpInside];

            [confirmButton setTitle:@"确认" forState:UIControlStateNormal];

            [_topBar addSubview:confirmButton];
            _confirmButton = confirmButton;

        }
    }

    //初始化中间栏
    {
        UIView *middleBar = [[UIView alloc] init];

        middleBar.backgroundColor = [UIColor clearColor];

        [self addSubview:middleBar];
        _middleBar = middleBar;

        {
            if (_delegate && [_delegate respondsToSelector:@selector(viewForMiddleBarInPickerView:)])
            {
                UIView *middleView = [_delegate viewForMiddleBarInPickerView:self];
                [middleBar addSubview:middleView];
                _middleBarView = middleView;
            }
        }
    }

    //初始化pickView
    {

        if (_pickerMode != QTPickerModeCoustom)
        {
            UIDatePicker *dp = [[UIDatePicker alloc] init];

            dp.datePickerMode = (NSUInteger)_pickerMode;

            _datePicker = dp;
            [self addSubview:dp];

        }
        else
        {
            UIPickerView *pickerView = [[UIPickerView alloc] init];

            pickerView.delegate   = _delegate;
            pickerView.dataSource = _dataSource;
            
            [self addSubview:pickerView];
            _pickerView = pickerView;
        }


    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    {
        CGFloat x      = 0;
        CGFloat y      = 0;
        CGFloat width  = self.frame.size.width;
        CGFloat height = QTPickerViewTopBarHeight;
        _topBar.frame = CGRectMake(x, y, width, height);

        //两个按钮的位置
        {
            x      = 0;
            y      = 0;
            width  = 50;
            height = 50;
            _cancelButton.frame = CGRectMake(x, y, width, height);
            _cancelButton.center = CGPointMake(width / 2, _topBar.center.y);

            x      = 0;
            y      = 0;
            width  = 50;
            height = 50;
            _confirmButton.frame = CGRectMake(x, y, width, height);
            _confirmButton.center = CGPointMake(self.frame.size.width - width / 2, _topBar.center.y);
        }

        x      = 0;
        y      = _topBar.frame.origin.y + _topBar.frame.size.height;
        width  = self.frame.size.width;
        height = _heightForMiddleBar;
        _middleBar.frame = CGRectMake(x, y, width, height);

        //中间view位置
        {
            x      = 0;
            y      = 0;
            width  = _middleBar.frame.size.width;
            height = _middleBar.frame.size.height;
            _middleBarView.frame = CGRectMake(x, y, width, height);

        }


        x      = 0;
        y      = _middleBar.frame.origin.y + _middleBar.frame.size.height;
        width  = self.frame.size.width;
        height = self.frame.size.height - y;
        _pickerView.frame = CGRectMake(x, y, width, height);

    }
}

#pragma mark - 事件响应
- (void)confirmButtonClick:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(pickerViewDidConfirm:)])
    {
        [_delegate pickerViewDidConfirm:self];
    }
}

- (void)cancelButtonClick:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(pickerViewDidCancel:)])
    {
        [_delegate pickerViewDidCancel:self];
    }
}

#pragma mark - 公共方法
- (UIView *)pickerView
{
    if (_pickerMode == QTPickerModeCoustom)
    {
        return _pickerView;
    }
    else
    {
        return _datePicker;
    }
}

- (UIView *)middleBarView
{
    return _middleBarView;
}

- (void)showWithDirection:(QTPickerAnimateDirection)direction
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    UIView *cover = [[UIView alloc] initWithFrame:window.bounds];

    cover.backgroundColor = [UIColor blackColor];
    cover.tag             = QTPickerViewCoverTag;
    cover.layer.opacity   = 0.1;

    switch (direction) {
        case QTPickerAnimateDirectionTop:
        {
            self.center = CGPointMake(window.center.x, (-1) * self.frame.size.height / 2);
        }break;

        case QTPickerAnimateDirectionLeft:
        {
            self.center = CGPointMake((-1) * self.frame.size.width / 2, window.center.y);

        }break;

        case QTPickerAnimateDirectionBottom:
        {
            self.center = CGPointMake(window.center.x, window.frame.size.height + self.frame.size.height / 2);

        }break;

        case QTPickerAnimateDirectionRight:
        {
            self.center = CGPointMake(window.frame.size.width + self.frame.size.width / 2, window.center.y);
        }break;

        default:
            break;
    }

    [window addSubview:cover];
    [window addSubview:self];

    __weak typeof(self) ws = self;
    [UIView animateWithDuration:0.3 animations:^{

        cover.layer.opacity = 0.5;
        ws.center = window.center;

    }];



}

- (void)hideWithDirection:(QTPickerAnimateDirection)direction
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    UIView *cover = [window viewWithTag:QTPickerViewCoverTag];

    CGPoint point;
    switch (direction) {
        case QTPickerAnimateDirectionTop:
        {
            point = CGPointMake(window.center.x, (-1) * self.frame.size.height / 2);
        }break;

        case QTPickerAnimateDirectionLeft:
        {
            point = CGPointMake((-1) * self.frame.size.width / 2, window.center.y);

        }break;

        case QTPickerAnimateDirectionBottom:
        {
            point = CGPointMake(window.center.x, window.frame.size.height + self.frame.size.height / 2);

        }break;

        case QTPickerAnimateDirectionRight:
        {
            point = CGPointMake(window.frame.size.width + self.frame.size.width / 2, window.center.y);
        }break;

        default:
            break;
    }

    __weak typeof(self) ws = self;
    [UIView animateWithDuration:0.25 animations:^{
        cover.layer.opacity = 0.1;
        ws.center = point;

    } completion:^(BOOL finished) {

        [cover removeFromSuperview];
        [self removeFromSuperview];

    }];


}

- (void)show
{
    [self showWithDirection:_animateDirection];
}

- (void)hide
{
    [self hideWithDirection:_animateDirection];
}

#pragma mark - Getter Setter
- (void)setDelegate:(id<QTPickerViewDelegate>)delegate
{
    _delegate = delegate;
    _pickerView.delegate = delegate;

    [self setupSubviews];
}

- (void)setDataSource:(id<QTPickerViewDateSource>)dataSource
{
    _dataSource = dataSource;
    _pickerView.dataSource = dataSource;
}

- (void)setPickerMode:(QTPickerMode)pickerMode
{
    _pickerMode = pickerMode;

    [self setupSubviews];
}


@end









