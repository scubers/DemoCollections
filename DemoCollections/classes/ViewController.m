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
#import "QTMultiTableView.h"

@interface ViewController () <QTSelectionViewDelegate,QTSelectionViewDataSource,UITableViewDelegate,UITableViewDataSource, QTMultiTableViewDataSource>

/**
 *  顶部选择view
 */
@property (nonatomic, weak) QTSelectionView *selectionView;
/**
 *  底部ScrollView
 */
@property (nonatomic, weak) QTMultiTableView *multiTableView;



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

    {
        QTMultiTableView *multiTableView = [[QTMultiTableView alloc] init];
        _multiTableView = multiTableView;
        _multiTableView.dataSource = self;
        multiTableView.backgroundColor = [UIColor blueColor];
        [self.view addSubview:multiTableView];

        [multiTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(multiTableView.superview);
            make.top.mas_equalTo(_selectionView.mas_bottom);
        }];
    }

}


#pragma mark - <QTSelectionViewDelegate,QTSelectionViewDataSource>

- (NSInteger)numberOfSelectionsInSelectionView:(QTSelectionView *)selectionView
{
    return 3;
}

- (CGSize)selectionView:(QTSelectionView *)selectionView sizeForSelectionsAtIndex:(NSInteger)index
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
#pragma mark - <QTMultiTableViewDataSource,QTMultiTableViewDelegate>

- (NSInteger)numberOfTableViewInMultiTableView:(QTMultiTableView *)multiTableView
{
    return 3;
}


@end


















