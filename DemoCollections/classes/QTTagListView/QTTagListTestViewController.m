//
//  ViewController.m
//  slideViewController
//
//  Created by 王俊仁 on 15/7/11.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "QTTagListTestViewController.h"
#import "Masonry.h"
#import "BlocksKit.h"
#import "ReactiveCocoa.h"
#import "POP+MCAnimate.h"
#import "QTSelectionView.h"
#import "QTMultiTableView.h"
#import "UIImage+JR.h"
#import "QTTagListView.h"


@interface QTTagListTestViewController () <QTTagListViewDelegate>

@property (nonatomic, weak) QTTagListView *tagListView;

@end

@implementation QTTagListTestViewController

#pragma mark - 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = RandomColor;

    self.automaticallyAdjustsScrollViewInsets = NO;

    [self setupSubviews];

}

- (void)setupSubviews
{
    QTTagListView *tag = [[QTTagListView alloc] init];

    tag.frame           = CGRectMake(0, 100, 320, 200);
    tag.backgroundColor = [UIColor whiteColor];
    tag.tagTitles       = [NSMutableArray arrayWithArray:@[@"猪肉sdfsdf猪肉sdfsdf猪肉sdfsd",@"猪肉",@"猪sdf肉",@"猪肉",@"猪肉",@"猪sdf肉",@"猪肉",@"猪sdf肉",@"猪肉",@"猪肉",@"猪肉",@"猪肉",@"猪肉",@"猪肉",@"猪肉",@"猪肉",@"猪肉",@"猪肉",@"猪肉",@"猪肉",@"猪肉",@"猪肉",@"猪肉",@"猪肉",@"猪肉",@"猪肉",@"猪肉df",]];
    tag.delegate        = self;
    tag.contentInsets   = UIEdgeInsetsMake(0, 10, 0, 10);

    _tagListView = tag;
    [self.view addSubview:tag];




}

#pragma mark - QTTagListViewDelegate
- (void)tagListView:(QTTagListView *)tagListView didSelectedTag:(UIButton *)button atIndex:(NSInteger)index
{
    NSLog(@"选择 --%@", [_tagListView.tagTitles objectAtIndex:index]);
    [button setBackgroundColor:[UIColor redColor]];
}

- (void)tagListView:(QTTagListView *)tagListView didDeselectedTag:(UIButton *)button atIndex:(NSInteger)index
{
    NSLog(@"取消 --%@", [_tagListView.tagTitles objectAtIndex:index]);
    [button setBackgroundColor:[UIColor purpleColor]];
}

@end


















