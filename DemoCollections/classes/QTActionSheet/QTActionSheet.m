//
//  QTActionSheet.m
//  DemoCollections
//
//  Created by mima on 15/7/28.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "QTActionSheet.h"
#import "Masonry.h"

#define QTActionSheetHeight 48
#define QTActionSheetMargin 0.5
#define QTActionSheetCoverTag 7878

@interface QTActionSheet()

@property (nonatomic, strong) NSMutableArray       *otherButtonTitles;
@property (nonatomic, strong) NSMutableArray       *buttons;

@property (nonatomic, weak  ) UIView               *titleBgView;
@property (nonatomic, weak  ) UILabel              *titleLabel;

@property (nonatomic, weak  ) UIView               *titleView;

@property (nonatomic, copy  ) NSString             *cancelButtonTitle;
@property (nonatomic, copy  ) NSString             *title;

@property (nonatomic, copy  ) QTActionSheetHandler handler;

@end

@implementation QTActionSheet

#pragma mark - 生命周期
- (instancetype)initWithTitle:(NSString *)title handler:(QTActionSheetHandler)handler cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles
{
    if (self = [super init])
    {
        self.backgroundColor   = [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1];
        self.handler           = handler;
        self.cancelButtonTitle = cancelButtonTitle;
        self.title             = title;
        self.otherButtonTitles = [NSMutableArray arrayWithArray:otherButtonTitles];
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.buttons = nil;
    
    //初始化控件
    {
        for (int i = 0; i < self.otherButtonTitles.count + 1; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            button.tag = i;
            button.backgroundColor = [UIColor whiteColor];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            if (i == self.otherButtonTitles.count) {
                [button setTitle:_cancelButtonTitle forState:UIControlStateNormal];
            }
            else
            {
                [button setTitle:self.otherButtonTitles[i] forState:UIControlStateNormal];
            }
            
            [self addSubview:button];
            [self.buttons addObject:button];
            
        }
        
        //如果有自定义titleView
        if (_delegate && [_delegate respondsToSelector:@selector(titleViewForActionSheet:)])
        {
            UIView *titleView = [_delegate titleViewForActionSheet:self];
            
            [self addSubview:titleView];
            _titleView = titleView;
        }
        //如果有标题
        else if (_title)
        {
            UIView *titleBgView = [[UIView alloc] init];
            
            titleBgView.backgroundColor = [UIColor whiteColor];
            
            [self addSubview:titleBgView];
            _titleBgView = titleBgView;
            
            
            UILabel *titleLabel = [[UILabel alloc] init];
            
            titleLabel.numberOfLines   = 0;
            titleLabel.text            = _title;
            titleLabel.backgroundColor = [UIColor whiteColor];
            titleLabel.textAlignment   = NSTextAlignmentCenter;
            titleLabel.font            = [UIFont systemFontOfSize:14];
            
            
            [titleBgView addSubview:titleLabel];
            _titleLabel = titleLabel;
        }
    }
    
    [self autolayout];
    
}

- (void)autolayout
{
    __weak typeof(self) ws = self;
    //设置约束
    UIButton *lastButton;
    
    if (_titleView)
    {
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(_titleView.superview);
            if (ws.delegate && [ws.delegate respondsToSelector:@selector(heightForTitleViewInActionSheet:)])
            {
                make.height.mas_equalTo([ws.delegate heightForTitleViewInActionSheet:ws]);
            }
            else
            {
                make.height.mas_equalTo(QTActionSheetHeight);
            }
        }];
    }
    else if (_titleBgView)
    {
        [_titleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(_titleBgView.superview);
            make.height.mas_equalTo(QTActionSheetHeight);
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(_titleLabel.superview);
            make.centerX.mas_equalTo(_titleLabel.superview);
            make.left.right.mas_equalTo(_titleLabel.superview).insets(UIEdgeInsetsMake(0, 30, 0, 30));
        }];
    }
    
    
    
    
    for (int i = 0; i < self.buttons.count; i++)
    {
        
        if (i == 0) //第一个
        {
            
            [self.buttons[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                if (_titleView)
                {
                    make.left.right.mas_equalTo([self.buttons[i] superview]);
                    make.top.mas_equalTo(_titleView.mas_bottom).offset(QTActionSheetMargin);
                }
                else if (_titleBgView)
                {
                    make.left.right.mas_equalTo([self.buttons[i] superview]);
                    make.top.mas_equalTo(_titleBgView.mas_bottom).offset(QTActionSheetMargin);
                }
                else
                {
                    make.left.right.top.mas_equalTo([self.buttons[i] superview]);
                }
                
                make.height.mas_equalTo(QTActionSheetHeight);
            }];
            
            lastButton = self.buttons[i];
            
            continue;
        }
        
        if (i == self.buttons.count - 1) //最后一个
        {
            [self.buttons[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo([self.buttons[i] superview]);
                make.height.mas_equalTo(QTActionSheetHeight);
            }];
            
            continue;
        }
        
        [self.buttons[i] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo([self.buttons[i] superview]);
            make.height.mas_equalTo(QTActionSheetHeight);
            make.top.mas_equalTo(lastButton.mas_bottom).offset(QTActionSheetMargin);
        }];
        
        lastButton = self.buttons[i];
    }

}

#pragma mark - 事件响应
- (void)buttonClick:(UIButton *)button
{
    if (self.handler)
    {
        self.handler(self, button.tag);
    }
    
    [self hide];
}

- (void)tapCover:(UITapGestureRecognizer *)recognizer
{
    [self hide];
}

#pragma mark - 公共方法
- (CGFloat)heightForActionSheet
{
    CGFloat titleHeight = 0;
    if (_delegate)
    {
        if ([_delegate respondsToSelector:@selector(heightForTitleViewInActionSheet:)])
        {
            titleHeight = [_delegate heightForTitleViewInActionSheet:self];
        }
        else
        {
            titleHeight = QTActionSheetHeight;
        }
    }
    else if (_titleBgView)
    {
        titleHeight = QTActionSheetHeight;
    }
    
    CGFloat height = self.buttons.count * (QTActionSheetHeight + QTActionSheetMargin) + (QTActionSheetMargin) + titleHeight;
    return height;
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *cover = [[UIView alloc] initWithFrame:window.bounds];
    
    cover.backgroundColor = [UIColor blackColor];
    cover.tag             = QTActionSheetCoverTag;
    cover.layer.opacity   = 0.1;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCover:)];
    [cover addGestureRecognizer:tap];
    
    self.frame = CGRectMake(0, window.frame.size.height, window.bounds.size.width, self.heightForActionSheet);
    
    [window addSubview:cover];
    [window addSubview:self];
    
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:0.3 animations:^{
        
        cover.layer.opacity = 0.3;
        ws.center = CGPointMake(window.center.x, window.bounds.size.height - self.bounds.size.height/2);;
        
    }];
}

- (void)hide
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *cover = [window viewWithTag:QTActionSheetCoverTag];
    
    
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:0.25 animations:^{
        
        cover.layer.opacity = 0.1;
        ws.center = CGPointMake(window.center.x, window.bounds.size.height + self.bounds.size.height/2);;
        
    } completion:^(BOOL finished) {
        
        [cover removeFromSuperview];
        [self removeFromSuperview];
        
    }];
}

#pragma mark - Getter Setter
- (NSMutableArray *)otherButtonTitles
{
    if (!_otherButtonTitles) {
        _otherButtonTitles = [NSMutableArray array];
    }
    return _otherButtonTitles;
}
- (NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (void)setDelegate:(id<QTActionSheetDelegate>)delegate
{
    _delegate = delegate;
    
    [self setupSubviews];
}


@end







