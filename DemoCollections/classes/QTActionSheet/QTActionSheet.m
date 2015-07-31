//
//  QTActionSheet.m
//  DemoCollections
//
//  Created by mima on 15/7/28.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "QTActionSheet.h"
#import "Masonry.h"

#define QTActionSheetHeight 50
#define QTActionSheetMargin 1
#define QTActionSheetCoverTag 7878

@interface QTActionSheet()

@property (nonatomic, strong) NSMutableArray *otherButtonTitles;
@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic, copy) NSString *cancelButtonTitle;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) QTActionSheetHandler handler;

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
    //初始化控件
    {
        if (!_title)
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
        }
        else
        {
            for (int i = 0; i < self.otherButtonTitles.count + 2; i++)
            {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                
                
                button.backgroundColor = [UIColor whiteColor];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                if (i != 0)
                {
                    button.tag = i - 1;
                    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                }
                else
                {
                    [button setTitle:_title forState:UIControlStateNormal];
                }
                
                if (i == self.otherButtonTitles.count + 1)
                {
                    [button setTitle:_cancelButtonTitle forState:UIControlStateNormal];
                }
                else
                {
                    if (i != 0)
                    {
                        [button setTitle:self.otherButtonTitles[i - 1] forState:UIControlStateNormal];
                    }
                }
                
                [self addSubview:button];
                [self.buttons addObject:button];
                
            }
        }
        
    }
    
    //设置约束
    {
        UIButton *lastButton;
        for (int i = 0; i < self.buttons.count; i++)
        {
            if (lastButton)
            {
                if (i == self.buttons.count - 1)//最后一个
                {
                    [self.buttons[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.bottom.mas_equalTo([self.buttons[i] superview]);
                        make.height.mas_equalTo(QTActionSheetHeight);
                    }];
                }
                else//中间的
                {
                    [self.buttons[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.mas_equalTo([self.buttons[i] superview]);
                        make.height.mas_equalTo(QTActionSheetHeight);
                        make.top.mas_equalTo(lastButton.mas_bottom).offset(QTActionSheetMargin);
                    }];
                }
                
            }
            else//第一个
            {
                [self.buttons[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.top.mas_equalTo([self.buttons[i] superview]);
                    make.height.mas_equalTo(QTActionSheetHeight);
                }];
            }
            
            
            lastButton = self.buttons[i];
        }
    }
    
}

#pragma mark - 事件响应
- (void)buttonClick:(UIButton *)button
{
    if (self.handler) {
        self.handler(self, button.tag, button);
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
    CGFloat height = self.buttons.count * (QTActionSheetHeight + QTActionSheetMargin) + 3 * QTActionSheetMargin;
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
    
    self.center = CGPointMake(window.center.x, window.bounds.size.height + self.bounds.size.height/2);
    self.bounds = CGRectMake(0, 0, window.bounds.size.width, self.heightForActionSheet);
    
    [window addSubview:cover];
    [window addSubview:self];
    
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:0.3 animations:^{
        
        cover.layer.opacity = 0.5;
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


@end







