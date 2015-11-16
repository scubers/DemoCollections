//
//  QTInvitationConfirmViewController.m
//  DemoCollections
//
//  Created by mima on 15/11/14.
//  Copyright © 2015年 王俊仁. All rights reserved.
//

#import "AppDelegate.h"
#import "QTInvitationConfirmViewController.h"
#import "Masonry.h"
#import "ReactiveCocoa.h"

#define DetailHeight 400

#pragma mark - QTConfirmButton ---------------------------------------------------

@interface QTConfirmButton : UIButton

@property (nonatomic, assign) QTInvitationConfirmViewControllerStatus status;

@property (nonatomic, strong) CAShapeLayer *loadingLayer;
@property (nonatomic, strong) CAShapeLayer *errorLayer;


@end

@implementation QTConfirmButton

#pragma mark - 生命周期
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    
}
@end

#pragma mark - QTInvitationConfirmViewController ---------------------------------------------------
@interface QTInvitationConfirmViewController() <UITextFieldDelegate>

@property (nonatomic, strong) UIView          *background;///< 白色的背景

@property (nonatomic, strong) UILabel         *activityLabel;///< 活动label
@property (nonatomic, strong) UIButton        *closeButton;///< 关闭按钮
@property (nonatomic, strong) UITableViewCell *locationCell;///< 地点按钮
@property (nonatomic, strong) UITableViewCell *timeCell;///< 时间按钮
@property (nonatomic, strong) UIButton        *confirmButton;///< 确定按钮

@property (nonatomic, strong) UITableViewCell *roseCell;///< 玫瑰按钮
@property (nonatomic, strong) UITextField     *roseField;///< 玫瑰编辑框
@property (nonatomic, strong) UIButton        *plusButton;///< 添加按钮
@property (nonatomic, strong) UIButton        *minusButton;///< 减少按钮

@property (nonatomic, copy  ) QTConfirmBlock block;
@property (nonatomic, strong) QTInvitation   *invitation;

@end

@implementation QTInvitationConfirmViewController

#pragma mark - 生命周期
- (instancetype)init
{
    if (self = [super init])
    {
        // MARK: Key code, 不知道为毛, 不在初始化设置背景颜色, present之后父视图还是会被移除
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    }
    return self;
}

- (instancetype)initWithInvitation:(QTInvitation *)invitation extraRose:(int)extraRose block:(QTConfirmBlock)block
{
    if (self = [super init])
    {
        // MARK: Key code, 不知道为毛, 不在初始化设置背景颜色, present之后父视图还是会被移除
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.block = block;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configure];
    [self setupSubviews];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.status = QTInvitationConfirmViewControllerStatusLoading;
    });
}

- (void)configure
{
    // 配置Modal出Controller后,底部controller不移除
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    // 点击透明地方dismiss
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
}

- (void)setupSubviews
{
    __weak typeof(self) ws = self;
    
    _background = [[UIView alloc] init];
    _background.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_background];
    
    
    _activityLabel = [[UILabel alloc] init];
    _activityLabel.textAlignment = NSTextAlignmentCenter;
    [_background addSubview:_activityLabel];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [[_closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [ws tap:nil];
    }];
    [_background addSubview:_closeButton];
    
    _locationCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
    [_background addSubview:_locationCell];
    
    _timeCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
    [_background addSubview:_timeCell];
    
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmButton addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
    [_background addSubview:_confirmButton];
    
    _roseCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
    [_background addSubview:_roseCell];
    
    _roseField = [[UITextField alloc] init];
    _roseField.enabled  = NO;
    _roseField.delegate = self;
    [_background addSubview:_roseField];
    
    _plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_background addSubview:_plusButton];
    
    _minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_background addSubview:_minusButton];
    
    [self autolayout];
    
    _activityLabel.text = @"散步";
    _locationCell.textLabel.text = @"购物公园一楼星巴克";
    _timeCell.textLabel.text = @"10:00~16:00";
    _roseCell.textLabel.text = @"玫瑰";
    
    _plusButton.backgroundColor = [UIColor greenColor];
    _minusButton.backgroundColor = [UIColor purpleColor];
    [_confirmButton setTitle:@"确认邀约" forState:UIControlStateNormal];
    _confirmButton.layer.cornerRadius = 3;
    _confirmButton.clipsToBounds      = YES;
    _confirmButton.backgroundColor    = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.8];
    
    _closeButton.backgroundColor = [UIColor purpleColor];
    
}

- (void)autolayout
{
    [_activityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(_activityLabel.superview);
        make.height.mas_equalTo(60);
    }];
    
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(_closeButton.superview);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [_locationCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_locationCell.superview);
        make.top.mas_equalTo(_activityLabel.mas_bottom);
        make.height.mas_equalTo(_activityLabel);
    }];
    
    [_timeCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_timeCell.superview);
        make.top.mas_equalTo(_locationCell.mas_bottom);
        make.height.mas_equalTo(_locationCell);
    }];
    
    [_roseCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_roseCell.superview);
        make.height.mas_equalTo(_timeCell);
        make.top.mas_equalTo(_timeCell.mas_bottom);
    }];
    
    [_plusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(_roseField);
        make.width.mas_equalTo(_plusButton.mas_height);
        make.right.mas_equalTo(_plusButton.superview).offset(-20);
    }];
    
    _roseField.backgroundColor = [UIColor redColor];
    [_roseField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(_roseCell).insets(UIEdgeInsetsMake(10, 10, 10, 10));
        make.width.mas_equalTo(100);
        make.right.mas_equalTo(_plusButton.mas_left);
    }];
    
    [_minusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(_plusButton);
        make.centerY.mas_equalTo(_plusButton);
        make.right.mas_equalTo(_roseField.mas_left);
    }];
    
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_confirmButton.superview).insets(UIEdgeInsetsMake(0, 15, 15, 15));
        make.bottom.mas_equalTo(_confirmButton.superview).offset(-15);
        make.height.mas_equalTo(50);
    }];
    
    {
        // 分割线
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lightGrayColor];
        [_locationCell addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.4);
            make.left.right.top.mas_equalTo(line.superview);
        }];
        
        line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lightGrayColor];
        [_timeCell addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(line.superview);
            make.height.mas_equalTo(0.4);
        }];
        
        line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lightGrayColor];
        [_roseCell addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(line.superview);
            make.height.mas_equalTo(0.4);
        }];
        
        line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lightGrayColor];
        [_roseCell addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(line.superview);
            make.height.mas_equalTo(0.4);
        }];
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _background.alpha = 0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CGSize size = CGSizeMake(self.view.size.width, DetailHeight);
    
    _background.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, size.width, size.height);
    _background.alpha = 1;
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _background.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - size.height, size.width, size.height);
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark - <UITextFieldDelegate>

#pragma mark - 事件响应
- (void)tap:(UITapGestureRecognizer *)reco
{
    // TODO: 执行自己的消失动画
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.view.backgroundColor = [UIColor clearColor];
        self.background.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.background.frame.size.width, self.background.frame.size.height);
        
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    
}

- (void)confirmClick:(UIButton *)sender
{
    if (_block)
    {
        _block(self, self.invitation);
        self.status = QTInvitationConfirmViewControllerStatusLoading;
    }
}

#pragma mark - Getter Setter
- (void)setStatus:(QTInvitationConfirmViewControllerStatus)status animated:(BOOL)animated
{
    // TODO: 没时间做动画了,用MBProgressHUD代替自己的动画
}

- (void)setStatus:(QTInvitationConfirmViewControllerStatus)status
{
    _status = status;
    
    switch (status) {
        case QTInvitationConfirmViewControllerStatusNormal:
            self.view.userInteractionEnabled = YES;
            break;
        case QTInvitationConfirmViewControllerStatusLoading:
            self.view.userInteractionEnabled = NO;
            break;
        case QTInvitationConfirmViewControllerStatusError:
            self.view.userInteractionEnabled = YES;
            break;
        default:
            break;
    }
}

@end
