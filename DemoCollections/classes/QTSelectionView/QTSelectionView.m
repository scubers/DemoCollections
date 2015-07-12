//
//  QTSelectionView.m
//  slideViewController
//
//  Created by 王俊仁 on 15/7/11.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//  类似 网易新闻 的顶部滑动选择栏

#import "QTSelectionView.h"

#define QTSelectionViewDefaultMargin 5

@interface QTSelectionView()

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) UIView *markView;

@property (nonatomic, strong) NSMutableArray *selections;

@end

@implementation QTSelectionView

#pragma mark - 生命周期
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{

    {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.backgroundColor = [UIColor clearColor];
        _scrollView = scrollView;
        [self addSubview:scrollView];
    }

}

- (void)layoutSubviews
{
    [super layoutSubviews];

    {
        //设置scrollView的大小 以及 contentSize;
        CGFloat x = _contentInsets.left;
        CGFloat y = _contentInsets.top;
        CGFloat width = self.bounds.size.width - _contentInsets.left - _contentInsets.right;
        CGFloat height = self.bounds.size.height - _contentInsets.top - _contentInsets.bottom;
        CGRect rect = CGRectMake(x, y, width, height);
        _scrollView.frame = rect;
        _scrollView.contentSize = CGSizeMake(CGRectGetMaxX([_selections.lastObject frame]), 0);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.userInteractionEnabled = YES;
    }


    [self.selections enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        view.center = CGPointMake(view.center.x, _scrollView.center.y);
    }];

}

#pragma mark - 事件响应
- (void)selectionClick:(UITapGestureRecognizer *)recognizer
{
    //获取当前点击的view
    UIView *view = recognizer.view;
    int index = (int)[self.selections indexOfObject:view];

    //如果点中的就是已经选中的View则什么都不做
    if (index == _selectedIndex) return;


    [self scrollToIndex:index];
}

- (void)selectViewAtIndex:(NSInteger)index
{
    int previousIndex = _selectedIndex;
    _selectedIndex = (int)index;

    UIView *view = [_selections objectAtIndex:index];

    if (!_markViewHidden)
    {
        //标识滑动到指定的index下
        [UIView animateWithDuration:0.3 animations:^{

            CGFloat x = view.center.x;
            CGFloat y = view.center.y + view.bounds.size.height/2 - 5/2;
            if (_dataSource && [_dataSource respondsToSelector:@selector(centeyYForMarkViewInSelectionView:)])
            {
                y = [_dataSource centeyYForMarkViewInSelectionView:self];
            }

            _markView.center = CGPointMake(x, y);
        }];
    }

    //通知代理
    if (_delegate && [_delegate respondsToSelector:@selector(selectionView:didSelectedFrom:onIndex:toView:onIndex:)])
    {
        [_delegate selectionView:self didSelectedFrom:[_selections objectAtIndex:previousIndex] onIndex:previousIndex toView:[_selections objectAtIndex:index] onIndex:index];
    }



}

#pragma mark - 公共方法

- (void)reloadSelections
{
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    //根据数据源初始化内部控件
    NSInteger count = [_dataSource numberOfSelectionsInSelectionView:self];

    for (int i = 0; i < count; i++)
    {

        //每个view的size
        CGSize viewSize = [_dataSource sizeForSelectionsInSelectionView:self atIndex:i];


        //每个Selection之间的间距

        //计算每个View的Frame
        //有代理时
        UIView *view;
        if (_delegate && [_delegate respondsToSelector:@selector(viewForSelectionView:atIndex:)])
        {
            view = [_delegate viewForSelectionView:self atIndex:i];
        }
        else //无代理时默认使用UILabel
        {
            UILabel *label = [[UILabel alloc] init];
            label.text = [NSString stringWithFormat:@"%zd",i];
            view = label;
        }

        CGFloat x = 0;
        if (self.selections.count != 0)
        {
            x = CGRectGetMaxX([self.selections.lastObject frame]) + self.selectionMargin;
        }

        view.frame = CGRectMake(x, 0, viewSize.width, viewSize.height);

        [self.selections addObject:view];
        [_scrollView addSubview:view];

        //设置事件
        {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectionClick:)];
            view.userInteractionEnabled = YES;
            [view addGestureRecognizer:tap];

        }
            


        //初始化标记view
        {
            if (!_markView)
            {
                UIView *markView;
                if (_delegate && [_delegate respondsToSelector:@selector(markViewForSelectionView:)])
                {
                    markView = [_delegate markViewForSelectionView:self];
                }
                else
                {
                    markView = [[UIView alloc] init];
                    markView.backgroundColor = [UIColor yellowColor];
                    markView.frame = CGRectMake(0, 0, [_selections[0] bounds].size.width, 5);
                }
                _markView.backgroundColor = [UIColor yellowColor];
                [_scrollView addSubview:markView];
                _markView = markView;
            }
        }
    }

    //默认选中第一个
    [self scrollToIndex:_selectedIndex];

}

- (void)scrollToIndex:(NSInteger)index
{
    if (index > _selections.count-1 || index < 0 ) return;

    if (_scrollView.isScrollEnabled)
    {
        CGRect rect = [[_selections objectAtIndex:index] frame];
        CGPoint point = rect.origin;

        CGFloat windowWidth = _scrollView.frame.size.width;
        //计算滚动到的位置
        CGFloat x = point.x - windowWidth/2 + rect.size.width/2;
        if (x < 0 )
        {
            point = CGPointZero;
        }
        else if(x > _scrollView.contentSize.width - windowWidth)
        {
            point = CGPointMake(_scrollView.contentSize.width - windowWidth, 0);
        }
        else
        {
            point = CGPointMake(x, 0);
        }
        [_scrollView setContentOffset:point animated:YES];
    }

    [self selectViewAtIndex:index];


}

#pragma mark - Getter Setter
- (void)setDataSource:(id<QTSelectionViewDataSource>)dataSource
{
    _dataSource = dataSource;
    [self reloadSelections];
}

- (void)setDelegate:(id<QTSelectionViewDelegate>)delegate
{
    _delegate = delegate;
    [self reloadSelections];
}

/**
 *  懒加载
 */
- (NSMutableArray *)selections
{
    if (!_selections) {
        _selections = [NSMutableArray array];
    }
    return _selections;
}

- (int)selectionMargin
{
    if (_dataSource && [_dataSource respondsToSelector:@selector(marginForEachSelectionsInSelectionView:)])
    {
        return (int)[_dataSource marginForEachSelectionsInSelectionView:self];
    }
    return QTSelectionViewDefaultMargin;
}

- (void)setMarkViewHidden:(BOOL)markViewHidden
{
    _markViewHidden = markViewHidden;
    _markView.hidden = markViewHidden;
}

- (void)setScrollable:(BOOL)scrollable
{
    _scrollable = scrollable;
    _scrollView.scrollEnabled = scrollable;
}

@end









