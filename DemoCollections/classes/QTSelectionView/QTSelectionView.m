//
//  QTSelectionView.m
//  slideViewController
//
//  Created by 王俊仁 on 15/7/11.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//  类似 网易新闻 的顶部滑动选择栏

#import "QTSelectionView.h"

#define QTSelectionViewDefaultMargin 5
#define QTDefaultMarkViewHeight 5

@interface QTSelectionView() <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) UIView *markView;

@property (nonatomic, strong) NSMutableArray *selections;
@property (nonatomic, strong) NSMutableArray *marginViews;


@end

@implementation QTSelectionView

#pragma mark - 生命周期
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor        = [UIColor whiteColor];
        self.scrollViewFollowSelect = YES;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{

    {
        UIScrollView *scrollView = [[UIScrollView alloc] init];

        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.delegate        = self;

        _scrollView = scrollView;
        [self addSubview:scrollView];

        _scrollView.backgroundColor = [UIColor grayColor];
    }

}

- (void)layoutSubviews
{
    [super layoutSubviews];

    {
        //设置scrollView的大小 以及 contentSize;
        CGFloat x      = _contentInsets.left;
        CGFloat y      = _contentInsets.top;
        CGFloat width  = self.bounds.size.width - _contentInsets.left - _contentInsets.right;
        CGFloat height = self.bounds.size.height - _contentInsets.top - _contentInsets.bottom;

        _scrollView.frame                          = CGRectMake(x, y, width, height);
        _scrollView.contentSize                    = CGSizeMake(CGRectGetMaxX([_selections.lastObject frame]), 0);
        _scrollView.userInteractionEnabled         = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }


    [self.selections enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        view.center = CGPointMake(view.center.x, _scrollView.center.y);
    }];

    [self scrollToIndex:_selectedIndex animated:NO];

}

#pragma mark - 事件响应
- (void)selectionClick:(UITapGestureRecognizer *)recognizer
{

    int previousIndex = _selectedIndex;

    //获取当前点击的view
    UIView *view = recognizer.view;
    int index = (int)[self.selections indexOfObject:view];

    //如果点中的就是已经选中的View则什么都不做
    if (index == _selectedIndex) return;

    _selectedIndex = index;

    //移动MarkView
    [self moveMarkViewToIndex:_selectedIndex animated:YES];

    //通知代理
    [self didSelectViewFrom:previousIndex to:_selectedIndex];

    //判断是否需要滚动scrollView
    if(_scrollViewFollowSelect) [self scrollViewScrollToIndex:_selectedIndex animated:YES];


}

#pragma mark - 私有方法

/**
 *  移动底部指示View （MarkView）到指定index
 */
- (void)moveMarkViewToIndex:(NSInteger)index animated:(BOOL)animated
{
    UIView *view = [_selections objectAtIndex:index];

    if (!_markViewHidden)
    {
        //标识滑动到指定的index下
        [UIView animateWithDuration:animated ? 0.3 : 0 animations:^{

            CGFloat x = view.center.x;
            CGFloat y = _scrollView.frame.size.height - QTDefaultMarkViewHeight;
            if (_dataSource && [_dataSource respondsToSelector:@selector(centeyYForMarkViewInSelectionView:)])
            {
                y = [_dataSource centeyYForMarkViewInSelectionView:self];
            }

            _markView.center = CGPointMake(x, y);
        }];
    }

}

/**
 *  手动选择某个View
 */
- (void)selectViewAtIndex:(NSInteger)index animated:(BOOL)animated
{
    int previousIndex = _selectedIndex;
    _selectedIndex = (int)index;

    [self moveMarkViewToIndex:_selectedIndex animated:animated];

    [self didSelectViewFrom:previousIndex to:_selectedIndex];
}

/**
 *  让ScrollView滚动至选择中的view居中
 */
- (void)scrollViewScrollToIndex:(NSInteger)index animated:(BOOL)animated
{
    if (index > _selections.count-1 || index < 0 ) return;

    if (_scrollView.isScrollEnabled)
    {
        CGRect rect = [[_selections objectAtIndex:index] frame];
        CGPoint point = rect.origin;

        CGFloat windowWidth = _scrollView.frame.size.width;
        //计算滚动到的位置
        CGFloat x = point.x - windowWidth/2 + rect.size.width/2;
        if ( x < 0 )
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
        [_scrollView setContentOffset:point animated:animated];
    }
}

/**
 *  通知外部代理方法
 */
- (void)didSelectViewFrom:(NSInteger)from to:(NSInteger)to
{
    //通知代理
    if (_delegate && [_delegate respondsToSelector:@selector(selectionView:didSelectedFrom:onIndex:toView:onIndex:)])
    {
        [_delegate selectionView:self didSelectedFrom:[_selections objectAtIndex:from] onIndex:from toView:[_selections objectAtIndex:to] onIndex:to];
    }
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    if (_delegate && [_delegate respondsToSelector:@selector(selectionView:selectionView:atIndex:withDistanceToCenter:)])
    {

        __weak typeof(self) ws = self;
        [_selections enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {

            //判断当前view和可视窗口有无相交，即判断view是否可见
            CGRect rect = CGRectIntersection([_scrollView convertRect:_scrollView.bounds toView:self], [view convertRect:view.bounds toView:self]);

            if (!CGRectIsNull(rect))//如果可见，计算此view的中间与可视窗口中心的距离
            {
                
                CGFloat currentCenterX = _scrollView.contentOffset.x + _scrollView.frame.size.width / 2;
                CGFloat distance =  ABS(currentCenterX - view.center.x);

                [_delegate selectionView:ws selectionView:view atIndex:idx withDistanceToCenter:distance];
            }

        }];
    }
}

#pragma mark - 公共方法

/**
 *  重新绘制ScrollView内部控件
 */
- (void)reloadSelections
{
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    //根据数据源初始化内部控件
    NSInteger count = [_dataSource numberOfSelectionsInSelectionView:self];

    for (int i = 0; i < count; i++)
    {

        //每个view的size
        CGSize viewSize = [_dataSource selectionView:self sizeForSelectionsAtIndex:i];


        //每个Selection之间的间距

        //计算每个View的Frame
        //有代理时
        UIView *view;
        if (_delegate && [_delegate respondsToSelector:@selector(selectionView:viewAtIndex:)])
        {
            view = [_delegate selectionView:self viewAtIndex:i];
        }
        else //无代理时默认使用UILabel
        {
            UILabel *label = [[UILabel alloc] init];

            label.backgroundColor = [UIColor purpleColor];

            label.text = [NSString stringWithFormat:@"%zd",i];
            view       = label;
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
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(selectionClick:)];
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
                    markView.frame = CGRectMake(0, 0, [_selections[0] bounds].size.width, QTDefaultMarkViewHeight);
                }
                _markView.backgroundColor = [UIColor yellowColor];
                [_scrollView addSubview:markView];
                _markView = markView;
            }
        }
    }
}

/**
 *  滚动至并选中对应的view
 */
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated
{
    [self scrollViewScrollToIndex:index animated:animated];

    [self selectViewAtIndex:index animated:animated];
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

/**
 *  懒加载
 */
- (NSMutableArray *)marginViews
{
    if (!_marginViews) {
        _marginViews = [NSMutableArray array];
    }
    return _marginViews;
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









