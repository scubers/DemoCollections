//
//  QTBounceMenuView.m
//  DemoCollections
//
//  Created by mima on 15/11/12.
//  Copyright © 2015年 王俊仁. All rights reserved.
//

#import "QTBounceMenuView.h"

#define AnimateBaseOffset 100

@interface QTBounceMenuView()

@property (nonatomic, weak) UIView *baseOnView;///< 显示在哪个view上面, 默认window

@property (nonatomic, strong) NSMutableArray<__kindof UIView *> *menuItemViews;

@end

@implementation QTBounceMenuView

#pragma mark - 生命周期
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupSubviews];
        
        self.baseItemSize = CGSizeZero;
//        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        self.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
        [self addGestureRecognizer:tap];
        
        
    }
    return self;
}

- (void)setupSubviews
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.menuItemViews = nil;
    
    for (int i = 0; i < [_delegate numberOfItemForBounceMenuView:self]; i++)
    {
        if ([_delegate respondsToSelector:@selector(bounceMenuView:viewForItemAtIndex:)])
        {
            [self.menuItemViews addObject:[_delegate bounceMenuView:self viewForItemAtIndex:i]];
        }
        else
        {
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor lightGrayColor];
            [self.menuItemViews addObject:view];
        }
    }
    [self.menuItemViews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addSubview:obj];
        obj.alpha = 0;
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    {// 设置每个菜单的大小
        [self.menuItemViews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([_delegate respondsToSelector:@selector(frameForItemInBounceMenuView:atIndex:)])
            {
                CGRect rect = [_delegate frameForItemInBounceMenuView:self atIndex:idx];
                obj.frame = rect;
            }
            else
            {
                // 默认布局
                [self defaultLayoutForMenuView:obj AtIndex:idx];
            }
            
        }];
    }
}

#pragma mark - 公共方法
- (void)showAtView:(UIView *)view complete:(void (^)(QTBounceMenuView *))complete
{
    _baseOnView = view;
    
    [_baseOnView addSubview:self];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showAnimationWithComplete:complete];
    });

}

- (void)dismissMenuView
{
    [self dismissWithMenuView:nil atIndex:-1 complete:nil];
}

#pragma mark - 私有方法
- (void)showAnimationWithComplete:(void (^)(QTBounceMenuView *))complete
{
    [self.menuItemViews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGRect rect = obj.frame;
        obj.frame = CGRectMake(obj.frame.origin.x, obj.frame.origin.y + AnimateBaseOffset, obj.frame.size.width, obj.frame.size.height);
        obj.alpha = 0;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * idx * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                obj.frame = rect;
                obj.alpha = 1;
            } completion:^(BOOL finished) {
                complete(self);
            }];
            
        });
        
    }];
    
}

- (void)dismissWithMenuView:(UIView *)view atIndex:(NSInteger)index complete:(void (^)(QTBounceMenuView *))complete;
{
    self.userInteractionEnabled = NO;
    [self.menuItemViews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * (self.menuItemViews.count - idx - 1) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                obj.frame = CGRectMake(obj.frame.origin.x, obj.frame.origin.y + AnimateBaseOffset, obj.frame.size.width, obj.frame.size.height);
                obj.alpha = 0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
            
        });
        
    }];
    
}



- (void)defaultLayoutForMenuView:(UIView *)menuView AtIndex:(NSInteger)index
{
    if (CGSizeEqualToSize(_baseItemSize, CGSizeZero)) return;
        
    CGRect areaRect = CGRectMake(_contentInsets.left, _contentInsets.top, self.bounds.size.width - (_contentInsets.left + _contentInsets.right), self.bounds.size.height - (_contentInsets.top + _contentInsets.bottom));
    
    CGFloat x = 0;
    CGFloat y = 0;
    
    int line = (int)index / _totalColumn;
    int column = (int)index % _totalColumn;
    
    CGFloat columnGap = (areaRect.size.width - (_totalColumn * _baseItemSize.width)) / (_totalColumn - 1);
    
    x = column * (_baseItemSize.width + columnGap) + _contentInsets.left;
    y = line * (_baseItemSize.height + _lineGap) + _contentInsets.top;
    
    menuView.frame = CGRectMake(x, y, _baseItemSize.width, _baseItemSize.height);
}

#pragma mark - 事件响应
- (void)backgroundTap:(UITapGestureRecognizer *)reco
{
    CGPoint point = [reco locationInView:self];
    
    __block BOOL flag = NO;
    
    [self.menuItemViews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if(CGRectContainsPoint(obj.frame, point))
        {
            if (_delegate && [_delegate respondsToSelector:@selector(bounceMenuView:didSelectItemAtIndex:)])
            {
                [_delegate bounceMenuView:self didSelectItemAtIndex:idx];
            }
            flag = YES;
            *stop = YES;
        }
        
    }];
    
    [self dismissWithMenuView:nil atIndex:-1 complete:nil];
    
}
   
#pragma mark - Getter Setter
- (NSMutableArray<UIView *> *)menuItemViews
{
    if (!_menuItemViews) {
        _menuItemViews = [NSMutableArray array];
    }
    return _menuItemViews;
}

- (void)setDelegate:(id<QTBounceMenuViewDelegate>)delegate
{
    _delegate = delegate;
    
    [self setupSubviews];
}

@end
