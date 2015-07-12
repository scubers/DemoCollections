//
//  QTMultiTableView.m
//  DemoCollections
//
//  Created by 王俊仁 on 15/7/12.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "QTMultiTableView.h"

@interface QTMultiTableView() <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *tableViews;

@end

@implementation QTMultiTableView

#pragma mark - 生命周期
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self seupSubviews];
    }
    return  self;
}

- (void)seupSubviews
{
    //初始化一个ScrollView
    {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        _scrollView = scrollView;
        [self addSubview:scrollView];
        _scrollView.pagingEnabled = YES;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    //让ScrollView填充整个View，设置contentSize
    _scrollView.frame = self.bounds;
    _scrollView.contentSize = CGSizeMake(_tableViews.count * _scrollView.bounds.size.width, 0);

    //设置内部TableView的Frame
    [_tableViews enumerateObjectsUsingBlock:^(UITableView *tableView, NSUInteger idx, BOOL *stop){

        CGSize baseSize = _scrollView.bounds.size;
        tableView.frame = CGRectMake(idx * baseSize.width, 0, baseSize.width, baseSize.height);

        NSLog(@"%@", NSStringFromCGRect(tableView.frame));

    }];

}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self reloadTableViews];
}

#pragma mark - 公共方法
- (void)reloadTableViews
{
    //移除内部所有子View
    {
        [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_tableViews removeAllObjects];
    }

    //设置内部TableView
    {
        NSInteger count = [_dataSource numberOfTableViewInMultiTableView:self];
        for (int i = 0; i < count; i++)
        {
            if (_delegate && [_delegate respondsToSelector:@selector(tableViewForMultiTableView:atIndex:)])
            {
                UITableView *tableView = [_delegate tableViewForMultiTableView:self atIndex:i];

                [_scrollView addSubview:tableView];
                [self.tableViews addObject:tableView];


            }
            else //如果没设置代理，则使用默认
            {
                UITableView *tableView = [[UITableView alloc] init];

                tableView.delegate = self;
                tableView.dataSource = self;
                [_scrollView addSubview:tableView];
                [self.tableViews addObject:tableView];

            }

        }
    }
}

#pragma mark - Getter Setter
- (void)setDataSource:(id<QTMultiTableViewDataSource>)dataSource
{
    _dataSource = dataSource;
    [self reloadTableViews];
}

- (void)setDelegate:(id<QTMultiTableViewDelegate>)delegate
{
    _delegate = delegate;
    [self reloadTableViews];
}

- (NSMutableArray *)tableViews
{
    if (!_tableViews)
    {
        _tableViews = [NSMutableArray array];
    }
    return _tableViews;
}



#pragma mark - UITableViewDataSource,UITableViewDelegate 内部测试默认使用
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"testCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%zd", indexPath.row];
    return cell;
}

@end
















