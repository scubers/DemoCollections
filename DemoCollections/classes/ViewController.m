//
//  ViewController.m
//  slideViewController
//
//  Created by 王俊仁 on 15/7/11.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "BlocksKit.h"
#import "ReactiveCocoa.h"
#import "POP+MCAnimate.h"
#import "QTSelectionView.h"

@interface ViewController () <QTSelectionViewDelegate,QTSelectionViewDataSource,UITableViewDelegate,UITableViewDataSource>

/**
 *  顶部选择view
 */
@property (nonatomic, weak) QTSelectionView *selectionView;
/**
 *  底部ScrollView
 */
@property (nonatomic, weak) UIScrollView *tableScrollView;

@property (nonatomic, weak) UITableView *tableView1;
@property (nonatomic, weak) UITableView *tableView2;
@property (nonatomic, weak) UITableView *tableView3;


@end

@implementation ViewController

#pragma mark - 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupSubviews];

    self.view.backgroundColor = [UIColor blackColor];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_selectionView scrollToIndex:19];
    });
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    _tableView1.frame = CGRectMake(0*320, 0, _tableScrollView.bounds.size.width, _tableScrollView.bounds.size.height);
    _tableView2.frame = CGRectMake(1*320, 0, _tableScrollView.bounds.size.width, _tableScrollView.bounds.size.height);
    _tableView3.frame = CGRectMake(2*320, 0, _tableScrollView.bounds.size.width, _tableScrollView.bounds.size.height);


    _tableScrollView.contentSize = CGSizeMake(3*320, 0);
}

- (void)setupSubviews
{
    //初始化顶部选择view
    {
        QTSelectionView *selectionView = [[QTSelectionView alloc] initWithFrame:CGRectMake(0, 50, 320, 50)];
        selectionView.delegate = self;
        selectionView.dataSource = self;
        _selectionView = selectionView;
        _selectionView.scrollable = NO;
        [self.view addSubview:selectionView];

    }

    //初始化底部tableView
    {
        UIScrollView *tableScrollView = [[UIScrollView alloc] init];
        [self.view addSubview:tableScrollView];
        _tableScrollView = tableScrollView;
        tableScrollView.backgroundColor = [UIColor purpleColor];
        _tableScrollView.pagingEnabled = YES;
//        _tableScrollView.showsHorizontalScrollIndicator = NO;

        UITableView *tableView1 = [[UITableView alloc] init];
        UITableView *tableView2 = [[UITableView alloc] init];
        UITableView *tableView3 = [[UITableView alloc] init];

        tableView1.tag = 10001;
        tableView2.tag = 10002;
        tableView3.tag = 10003;

        _tableView1 = tableView1;
        _tableView2 = tableView2;
        _tableView3 = tableView3;

        _tableView1.dataSource = self;
        _tableView2.dataSource = self;
        _tableView3.dataSource = self;

        _tableView1.delegate = self;
        _tableView2.delegate = self;
        _tableView3.delegate = self;

        [_tableScrollView addSubview:_tableView1];
        [_tableScrollView addSubview:_tableView2];
        [_tableScrollView addSubview:_tableView3];

        //添加约束
        {


            [_tableScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(_tableScrollView.superview);
                make.top.mas_equalTo(_selectionView.mas_bottom);
            }];

        }

    }

}


#pragma mark - <QTSelectionViewDelegate,QTSelectionViewDataSource>

- (NSInteger)numberOfSelectionsInSelectionView:(QTSelectionView *)selectionView
{
    return 3;
}

- (CGSize)sizeForSelectionsInSelectionView:(QTSelectionView *)selectionView atIndex:(NSInteger)index
{
    return CGSizeMake(320/3, 50);
}

- (void)selectionView:(QTSelectionView *)selectionView didSelectedFrom:(UIView *)fromView onIndex:(NSInteger)from toView:(UIView *)toView onIndex:(NSInteger)toIndex
{

    UILabel *fl = (UILabel *)fromView;
    UILabel *tl = (UILabel *)toView;

    fl.textColor = [UIColor blackColor];
    tl.textColor = [UIColor redColor];

    NSLog(@"from %zd to %zd", from,toIndex);
    NSLog(@"from %@ to %@", fromView,toView);
}

- (NSInteger)marginForEachSelectionsInSelectionView:(QTSelectionView *)selectionView
{
    return 0;
}

- (UIView *)markViewForSelectionView:(QTSelectionView *)selectionView
{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, 100, 8);
    view.backgroundColor = [UIColor blueColor];
    view.layer.cornerRadius = 4;
    view.clipsToBounds = YES;
    return view;
}
#pragma mark - <UITableViewDelegate,UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

static int count = 0;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d", count++);
    static NSString *ID = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%zd", indexPath.row];
    return cell;
}

@end


















