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



#pragma mark - QTInvitationConfirmViewController ---------------------------------------------------
@interface QTInvitationConfirmViewController()

@property (nonatomic, strong) UIView      *background;///< 白色的背景

@property (nonatomic, strong) UILabel     *activityLabel;///< 活动label
@property (nonatomic, strong) UIButton    *closeButton;///< 关闭按钮
@property (nonatomic, strong) UIButton    *locationButton;///< 地点按钮
@property (nonatomic, strong) UIButton    *timeButton;///< 时间按钮
@property (nonatomic, strong) UIButton    *confirmButton;///< 确定按钮

@property (nonatomic, strong) UITextField *roseField;///< 玫瑰编辑框
@property (nonatomic, strong) UIButton    *plusButton;///< 添加按钮
@property (nonatomic, strong) UIButton    *minusButton;///< 减少按钮

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configure];
    [self setupSubviews];
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
    _background = [[UIView alloc] init];
    _background.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_background];
    
    
    _activityLabel = [[UILabel alloc] init];
    _activityLabel.textAlignment = NSTextAlignmentCenter;
    [_background addSubview:_activityLabel];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_background addSubview:_closeButton];
    
    _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_background addSubview:_locationButton];
    
    _timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_background addSubview:_timeButton];
    
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_background addSubview:_confirmButton];

    
    _roseField = [[UITextField alloc] init];
    [_background addSubview:_roseField];
    
    _plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_background addSubview:_plusButton];
    
    _minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_background addSubview:_minusButton];
    
    [self autolayout];
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
    
    [_locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_locationButton.superview);
        make.top.mas_equalTo(_activityLabel.mas_bottom);
        make.height.mas_equalTo(_activityLabel);
    }];
    
    [_timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_timeButton.superview);
        make.top.mas_equalTo(_locationButton.mas_bottom);
        make.height.mas_equalTo(_locationButton);
    }];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }];
    
}

#pragma mark - 事件响应
- (void)tap:(UITapGestureRecognizer *)reco
{
    // TODO: 执行自己的消失动画
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.view.backgroundColor = [UIColor clearColor];
        
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    
}


@end
