//
//  QTAlertView.m
//  DemoCollections
//
//  Created by mima on 15/8/4.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "QTAlertView.h"
#import "Masonry.h"

#define QTAlertViewCoverTag 8653

@interface QTAlertView()

@property (nonatomic, copy  ) QTAlertViewHandler handler;

@property (nonatomic, weak  ) UILabel            *titleLabel;
@property (nonatomic, strong) NSMutableArray     *buttons;


@property (nonatomic, strong) UITextField        *usernameField;
@property (nonatomic, strong) UITextField        *passwordField;

@property (nonatomic, weak  ) UIView             *custmizedView;


@property (nonatomic, copy  ) NSString           *title;
@property (nonatomic, copy  ) NSString           *message;
@property (nonatomic, copy  ) NSString           *cancelButtonTitle;
@property (nonatomic, strong) NSMutableArray     *buttonTitles;

@property (nonatomic, assign) QTAlertViewMode    alertViewMode;


@end

@implementation QTAlertView

#pragma mark - 生命周期
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                         mode:(QTAlertViewMode)mode
                      handler:(QTAlertViewHandler)handler
{
    
    if (self  = [super init])
    {
        self.backgroundColor = [UIColor whiteColor];
        
        self.handler           = handler;
        self.title             = title;
        self.message           = message;
        self.alertViewMode     = mode;
        self.cancelButtonTitle = cancelButtonTitle;
        
        if (cancelButtonTitle.length)
        {
            [self.buttonTitles addObject:cancelButtonTitle];
        }
        
        [self.buttonTitles addObjectsFromArray:otherButtonTitles];
        
        self.layer.cornerRadius = 5;
        self.clipsToBounds      = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTap:)];
        
        [self addGestureRecognizer:tap];
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.buttons = nil;
    
    //初始化标题
    {
        UILabel *titleLabel = [[UILabel alloc] init];
        
        titleLabel.text          = self.title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
        
        
        //设置底部分割线
        UIView *separator = [[UIView alloc] init];
        
        separator.backgroundColor = [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1];
        
        [titleLabel addSubview:separator];
        
        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(titleLabel);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    
    //初始化buttons
    {
        [self.buttonTitles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [button setTitle:obj forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:52/255.0 green:118/255.0 blue:253/255.0 alpha:1] forState:UIControlStateNormal];
            
            if (idx == 0 && [obj isEqualToString:self.cancelButtonTitle])
            {
                [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
            
            [self.buttons addObject:button];
            
            {
                //设置顶部分割线
                UIView *separator = [[UIView alloc] init];
                separator.backgroundColor = [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1];
                [button addSubview:separator];
                
                [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.top.mas_equalTo(button);
                    make.height.mas_equalTo(0.5);
                }];
            }
            
        }];
        
        [self.buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self addSubview:obj];
        }];
        
        //初始化事件
        {
            __weak typeof(self) ws = self;
            [self.buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
                [button addTarget:ws action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            }];
        }
    }
    
    {
        switch (self.alertViewMode) {
            case QTAlertViewModeDefault:
            {
                
            }break;
                
            case QTAlertViewModePassword:
            {
                UITextField *passwordField = [[UITextField alloc] init];
                
                passwordField.secureTextEntry = YES;
                
                [self addSubview:passwordField];
                _passwordField = passwordField;
            }break;
                
            case QTAlertViewModeUsernameAndPassword:
            {
                UITextField *usernameField = [[UITextField alloc] init];
                
                usernameField.placeholder = @"用户名";
                
                [self addSubview:usernameField];
                _usernameField = usernameField;
                
                
                UITextField *passwordField = [[UITextField alloc] init];
                
                passwordField.secureTextEntry = YES;
                passwordField.placeholder = @"密码";
                
                [self addSubview:passwordField];
                _passwordField = passwordField;
                
            }break;
                
            case QTAlertViewModeCustmized:
            {
                if (_delegate && [_delegate respondsToSelector:@selector(custmizedViewForAlertView:)])
                {
                    UIView *custmizedView = [_delegate custmizedViewForAlertView:self];
                    
                    [self addSubview:custmizedView];
                    
                    _custmizedView = custmizedView;
                }
                
            }break;
                
            default:
                break;
        }
    }
    
    [self autolayout];
}

- (void)autolayout
{
    __weak typeof(self) ws = self;
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(_titleLabel.superview);
        make.height.mas_equalTo(QTAlertViewTitleHeight);
    }];
    
    UIView *tempView = _titleLabel;
    switch (self.alertViewMode) {
        case QTAlertViewModeDefault:
        {
            
        }break;
            
        case QTAlertViewModePassword:
        {
            tempView = _passwordField;
            
            [_passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(ws);
                make.top.mas_equalTo(_titleLabel.mas_bottom);
                make.height.mas_equalTo(QTAlertViewTextFieldHeight);
            }];
            
        }break;
            
        case QTAlertViewModeUsernameAndPassword:
        {
            tempView = _passwordField;
            
            [_usernameField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(ws).insets(UIEdgeInsetsMake(5, 5, 5, 5));
                make.top.mas_equalTo(_titleLabel.mas_bottom);
                make.height.mas_equalTo(QTAlertViewTextFieldHeight);
            }];
            
            {
                //设置顶部分割线
                UIView *separator = [[UIView alloc] init];
                separator.backgroundColor = [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1];
                [_usernameField addSubview:separator];
                
                [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.mas_equalTo(_usernameField);
                    make.height.mas_equalTo(0.5);
                }];
            }
            
            [_passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(ws).insets(UIEdgeInsetsMake(5, 5, 5, 5));
                make.top.mas_equalTo(_usernameField.mas_bottom);
                make.height.mas_equalTo(QTAlertViewTextFieldHeight);
            }];
        }break;
            
        case QTAlertViewModeCustmized:
        {
            [_custmizedView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(ws);
                make.top.mas_equalTo(_titleLabel.mas_bottom);
                make.height.mas_equalTo([_delegate alertView:ws heightForCustmizedView:_custmizedView]);
            }];
            
            if (_delegate)
            {
                tempView = _custmizedView;
            }
        }break;
            
        default:
            break;
    }

    
    
    
    if (self.buttons.count == 1)
    {
        [self.buttons.firstObject mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(ws);
            make.height.mas_equalTo(QTAlertViewButtonHeight);
        }];
    }
    
    if (self.buttons.count == 2)
    {
        [self.buttons.firstObject mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.mas_equalTo(ws);
            make.width.mas_equalTo(ws.mas_width).multipliedBy(0.5);
            make.height.mas_equalTo(QTAlertViewButtonHeight);
        }];
        
        //设置中间分割线
        {
            UIView *separator = [[UIView alloc] init];
            separator.backgroundColor = [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1];
            [self.buttons.firstObject addSubview:separator];
            [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.right.top.mas_equalTo(_buttons.firstObject);
                make.width.mas_equalTo(1);
            }];
        }
        
        
        [self.buttons.lastObject mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(ws);
            make.height.width.mas_equalTo(self.buttons.firstObject);
        }];
    }
    
    if (self.buttons.count > 2)
    {
        __block UIButton *lastButton;
        [self.buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(ws);
                make.height.mas_equalTo(QTAlertViewButtonHeight);
                
                if (!lastButton)
                {
                    make.top.mas_equalTo(tempView.mas_bottom);
                }
                else
                {
                    make.top.mas_equalTo(lastButton.mas_bottom);
                }
                
            }];
            
            lastButton = button;
        }];
    }
    
}

#pragma makr - 公共方法
- (CGFloat)caculateAlertViewHeight
{
    CGFloat buttonsHeight = self.buttons.count < 3 ? QTAlertViewButtonHeight : self.buttons.count * QTAlertViewButtonHeight;
    
    CGFloat middleHeight = 0;
    switch (self.alertViewMode) {
        case QTAlertViewModeDefault:
        {
            
        }break;
            
        case QTAlertViewModePassword:
        {
            middleHeight = QTAlertViewTextFieldHeight;
        }break;
            
        case QTAlertViewModeUsernameAndPassword:
        {
            middleHeight = QTAlertViewTextFieldHeight * 2;
        }break;
            
        case QTAlertViewModeCustmized:
        {
            if (_delegate && [_delegate respondsToSelector:@selector(alertView:heightForCustmizedView:)])
            {
                middleHeight = [_delegate alertView:self heightForCustmizedView:_custmizedView];
            }
        }break;
            
        default:
            break;
    }

    
    
    return QTAlertViewTitleHeight + buttonsHeight + middleHeight;
}

#pragma mark - 事件响应

- (void)buttonClick:(UIButton *)button
{
    if (self.handler) {
        self.handler(self, [self.buttons indexOfObject:button]);
    }
    
    [self hide];
}

- (void)selfTap:(UITapGestureRecognizer *)recognizer
{
    [self becomeFirstResponder];
}

- (void)tapCover:(UIGestureRecognizer *)recognizer
{
    [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - 公共方法
- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *cover = [[UIView alloc] initWithFrame:window.bounds];
    
    cover.backgroundColor = [UIColor blackColor];
    cover.tag             = QTAlertViewCoverTag;
    cover.layer.opacity   = 0.1;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCover:)];
    [cover addGestureRecognizer:tap];
    
    self.center = CGPointMake(window.center.x, window.center.y);
    self.bounds = CGRectZero;
    
    [window addSubview:cover];
    [window addSubview:self];
    
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:0.25 animations:^{
        
        cover.layer.opacity = 0.25;
        ws.bounds = CGRectMake(0, 0, 280, ws.caculateAlertViewHeight);
        
    }];
}

- (void)hide
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *cover = [window viewWithTag:QTAlertViewCoverTag];
    
    
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:0.25 animations:^{
        
        cover.layer.opacity = 0;
        ws.bounds = CGRectZero;
        
    } completion:^(BOOL finished) {
        
        [cover removeFromSuperview];
        [self removeFromSuperview];
        
    }];
}

#pragma mark - Getter Setter
- (void)setDelegate:(id<QTAlertViewDelegate>)delegate
{
    _delegate = delegate;
    
    if (delegate)
    {
        [self setupSubviews];
    }
}

- (NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (NSMutableArray *)buttonTitles
{
    if (!_buttonTitles) {
        _buttonTitles = [NSMutableArray array];
    }
    return _buttonTitles;
}

- (NSString *)username
{
    return _usernameField.text;
}

- (NSString *)password
{
    return _passwordField.text;
}

@end












