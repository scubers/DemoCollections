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

    [self setupSubviews];

}

- (void)setupSubviews
{
    QTTagListView *tag = [[QTTagListView alloc] init];

    tag.frame           = CGRectMake(0, 100, 320, 200);
    tag.tagTitles       = [NSMutableArray arrayWithArray:@[@"猪肉sdfsdf猪肉sdfsdf猪肉sdfsd",@"猪肉",@"猪sdf肉",@"猪肉",@"猪肉",@"猪sdf肉",@"猪肉",@"猪sdf肉",@"猪肉"]];
    tag.delegate        = self;

    _tagListView = tag;
    [self.view addSubview:tag];




}

#pragma mark - QTTagListViewDelegate
- (void)tagListView:(QTTagListView *)tagListView didSelectedAtIndex:(NSInteger)index
{
    NSLog(@"选择 --%@", [_tagListView.tagTitles objectAtIndex:index]);
}

- (void)tagListView:(QTTagListView *)tagListView didDeselectedAtIndex:(NSInteger)index
{
    NSLog(@"取消 --%@", [_tagListView.tagTitles objectAtIndex:index]);
}

@end


















