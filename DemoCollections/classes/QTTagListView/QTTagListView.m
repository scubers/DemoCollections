//
//  QTTagListView.m
//  DemoCollections
//
//  Created by 王俊仁 on 15/7/18.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "QTTagListView.h"

#define QTTagListViewBaseMargin 0
#define QTTagListViewExtractWidth 20

@interface QTTagListView ()

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *tags;

@end

@implementation QTTagListView

#pragma mark - 生命周期
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupSubviews];

        //初始化默认值
        _columns      = 3;
        _columnMargin = 10;
        _rowMargin    = 10;
        _tagHeight    = 30;
    }
    return self;
}

- (void)setupSubviews
{
    {
        UIScrollView *scrollView = [[UIScrollView alloc] init];

        [self addSubview:scrollView];
        _scrollView = scrollView;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tags removeAllObjects];


    {
        //设置scrollView的大小 以及 contentSize;
        CGFloat x      = _contentInsets.left;
        CGFloat y      = _contentInsets.top;
        CGFloat width  = self.bounds.size.width - _contentInsets.left - _contentInsets.right;
        CGFloat height = self.bounds.size.height - _contentInsets.top - _contentInsets.bottom;

        _scrollView.frame = CGRectMake(x, y, width, height);

        _scrollView.showsVerticalScrollIndicator = YES;


        int currentLine = 0;

        for (int i = 0; i < _tagTitles.count; i++)
        {

            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];

            [btn setTitle:_tagTitles[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(tagClick:) forControlEvents:UIControlEventTouchUpInside];

            btn.layer.cornerRadius = _tagHeight / 2;
            btn.clipsToBounds      = YES;
            btn.backgroundColor    = RandomColor;


            NSString *title = _tagTitles[i];
            CGSize size = [title sizeWithAttributes:@{ NSFontAttributeName : btn.titleLabel.font }];

            
            if (!self.tags.count)//第一个Tag
            {
                x      = 0;
                y      = 0;
                width  = size.width + QTTagListViewExtractWidth;
                height = _tagHeight;

                btn.frame = CGRectMake(x, y, width, height);

            }
            else//不是第一个Tag
            {
                x      = [self.tags.lastObject frame].origin.x + [self.tags.lastObject frame].size.width + _columnMargin;
                y      = [self.tags.lastObject frame].origin.y;
                width  = size.width + QTTagListViewExtractWidth;
                height = _tagHeight;


                if (x + width > _scrollView.frame.size.width)
                {

                    currentLine++;

                    CGFloat extractWidth = _scrollView.frame.size.width - (x - _columnMargin);

                    //处理上一行的宽度
                    NSMutableArray *lastLine = [NSMutableArray array];
                    [self.tags enumerateObjectsWithOptions:NSEnumerationReverse
                                                usingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
                        if (button.frame.origin.y == y)
                        {
                            [lastLine insertObject:button atIndex:0];
                        }
                        else
                        {
                            *stop = YES;
                        }

                    }];


                    for (int j = 0; j < lastLine.count; j++)
                    {
                        CGFloat lastWidth = [lastLine[j] frame].size.width + extractWidth / lastLine.count;
                        CGFloat lastX = [lastLine[j] frame].origin.x + j * (extractWidth / lastLine.count);
                        CGFloat lastY = y;
                        CGFloat lastHeight = _tagHeight;

                        [lastLine[j] setFrame:CGRectMake(lastX, lastY, lastWidth, lastHeight)];
                    }


                    //重新设置新的一行的第一个tag
                    x  = 0;
                    y  = y + _rowMargin + _tagHeight;

                }
                btn.frame = CGRectMake(x, y, width, height);
            }

            [_scrollView addSubview:btn];
            [self.tags addObject:btn];
            
        }

        {//处理最后一行，弱长度超过了_scrollView的2/3的话，让最行一行也充满一行

            UIButton *lastButton = self.tags.lastObject;

            CGFloat extractWidth = _scrollView.frame.size.width - (lastButton.frame.origin.x + lastButton.frame.size.width);

            if (extractWidth < _scrollView.frame.size.width / 3)
            {

                NSMutableArray *lastLine = [NSMutableArray array];
                [self.tags enumerateObjectsWithOptions:NSEnumerationReverse
                                            usingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
                    if (button.frame.origin.y == lastButton.frame.origin.y)
                    {
                        [lastLine insertObject:button atIndex:0];
                    }
                    else
                    {
                        *stop = YES;
                    }

                }];


                for (int j = 0; j < lastLine.count; j++)
                {
                    CGFloat lastWidth = [lastLine[j] frame].size.width + extractWidth / lastLine.count;
                    CGFloat lastX = [lastLine[j] frame].origin.x + j * (extractWidth / lastLine.count);
                    CGFloat lastY = y;
                    CGFloat lastHeight = _tagHeight;

                    [lastLine[j] setFrame:CGRectMake(lastX, lastY, lastWidth, lastHeight)];
                }
            }
        }

        NSLog(@"%d", currentLine);

        CGRect lastFrame = [self.tags.lastObject frame];
        _scrollView.contentSize = CGSizeMake(0, lastFrame.origin.y + lastFrame.size.height);
    }
}

#pragma mark - 公共方法
- (void)reloadTags
{
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tags removeAllObjects];

    [self setNeedsDisplay];
}

#pragma mark - 事件响应
- (void)tagClick:(UIButton *)button
{
    button.selected = !button.isSelected;

    //通知代理
    if (_delegate)
    {
        if ([_delegate respondsToSelector:@selector(tagListView:didSelectedTag:atIndex:)] && button.isSelected)
        {
            [_delegate tagListView:self didSelectedTag:button atIndex:[self.tags indexOfObject:button]];
        }
        else if([_delegate respondsToSelector:@selector(tagListView:didDeselectedTag:atIndex:)] && !button.isSelected)
        {
            [_delegate tagListView:self didDeselectedTag:button atIndex:[self.tags indexOfObject:button]];
        }
    }

}

#pragma mark - Getter Setter
- (NSMutableArray *)tags
{
    if (!_tags) {
        _tags = [NSMutableArray array];
    }
    return _tags;
}

@end
