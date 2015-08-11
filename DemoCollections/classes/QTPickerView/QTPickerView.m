//
//  QTPickerView.m
//  DemoCollections
//
//  Created by 王俊仁 on 15/7/19.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "QTPickerView.h"
#import "POP+MCAnimate.h"
#import "Masonry.h"

#define QTPickerViewTopBarHeight 50
#define QTInsidePickerViewHeight 150

#define QTPickerViewCoverTag 989898

@interface QTPickerView()

@property (nonatomic, weak) UIView          *topBar;

@property (nonatomic, weak) UIButton        *cancelButton;
@property (nonatomic, weak) UIButton        *confirmButton;

@property (nonatomic, weak) UIView          *middleBar;
@property (nonatomic, weak) UIView          *middleBarView;

@property (nonatomic, weak) UIView          *bottomView;

@property (nonatomic, weak) UIPickerView    *insidePickerView;

@property (nonatomic, weak) UIDatePicker    *datePicker;

@property (nonatomic, copy) CompleteHandler handler;


@end

@implementation QTPickerView

#pragma mark - 生命周期
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.layer.cornerRadius = 8;
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
    
    pickerView.frame = CGRectMake(-100, -100, 100, 100);

    return pickerView;
}

- (instancetype)initWithPickerMode:(QTPickerMode)pickerMode withBlock:(CompleteHandler)handler
{
    QTPickerView *pickerView = [[QTPickerView alloc] initWithPickerMode:pickerMode];

    pickerView.handler = handler;
    
    [pickerView hide];

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

        if (_pickerMode != QTPickerModeCustomize)
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
            _insidePickerView = pickerView;
        }
    }
    
    // 初始化底view
    {
        if (_delegate && [_delegate respondsToSelector:@selector(viewForBottomInPickerView:)])
        {
            UIView *view = [_delegate viewForBottomInPickerView:self];
            
            [self addSubview:view];
            _bottomView = view;
        }
    }
    
    [self autolayout];
}

- (void)autolayout
{
    // 顶部条
    [_topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(_topBar.superview);
        make.height.mas_equalTo(QTPickerViewTopBarHeight);
    }];
    
    //取消按钮
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_cancelButton.superview).offset(10);
        make.top.bottom.mas_equalTo(_cancelButton.superview).insets(UIEdgeInsetsMake(10, 0, 10, 0));
        make.width.mas_equalTo(50);
    }];
    
    //确认按钮
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_confirmButton.superview).offset(-10);
        make.top.bottom.mas_equalTo(_cancelButton.superview).insets(UIEdgeInsetsMake(10, 0, 10, 0));
        make.width.mas_equalTo(50);
    }];
    
    // 中间条
    [_middleBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_middleBar.superview);
        make.top.mas_equalTo(_topBar.mas_bottom);
        make.height.mas_equalTo(_heightForMiddleBar);
    }];
    
    [_middleBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_middleBarView.superview);
    }];
    
    if (self.pickerMode == QTPickerModeDate)
    {
        [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_datePicker.superview);
            make.top.mas_equalTo(_middleBar.mas_bottom);
            make.height.mas_equalTo(QTInsidePickerViewHeight);
        }];
        
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(_bottomView.superview);
            make.height.mas_equalTo(_heightForBottomView);
        }];
    }
    else
    {
        [_insidePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_insidePickerView.superview);
            make.top.mas_equalTo(_middleBar.mas_bottom);
            make.height.mas_equalTo(QTInsidePickerViewHeight);
        }];
        
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(_bottomView.superview);
            make.height.mas_equalTo(_heightForBottomView);
        }];
    }
    
    _insidePickerView.backgroundColor = [UIColor yellowColor];
    _bottomView.backgroundColor = [UIColor blueColor];
}


#pragma mark - 事件响应
- (void)confirmButtonClick:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(pickerViewDidConfirm:)])
    {
        [_delegate pickerViewDidConfirm:self];
    }

    if (_handler)
    {
        self.handler(self, YES);
    }
}

- (void)cancelButtonClick:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(pickerViewDidCancel:)])
    {
        [_delegate pickerViewDidCancel:self];
    }

    if (_handler)
    {
        self.handler(self, NO);
    }
}

#pragma mark - 公共方法
- (UIView *)pickerView
{
    if (_pickerMode == QTPickerModeCustomize)
    {
        return _insidePickerView;
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
    
    CGFloat width = 300;
    CGFloat height = QTPickerViewTopBarHeight + self.heightForMiddleBar + QTInsidePickerViewHeight + self.heightForBottomView;
    self.frame = CGRectMake(0, 0, width, height);

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
    _insidePickerView.delegate = delegate;

    [self setupSubviews];
}

- (void)setDataSource:(id<QTPickerViewDateSource>)dataSource
{
    _dataSource = dataSource;
    _insidePickerView.dataSource = dataSource;
}

- (void)setPickerMode:(QTPickerMode)pickerMode
{
    _pickerMode = pickerMode;

    [self setupSubviews];
}

- (void)setHeightForMiddleBar:(CGFloat)heightForMiddleBar
{
    _heightForMiddleBar = heightForMiddleBar;
    
    [self setupSubviews];
}

- (void)setHeightForBottomView:(CGFloat)heightForBottomView
{
    _heightForBottomView = heightForBottomView;
    
    [self setupSubviews];
}


@end









