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
#import "UIImage+JR.h"
#import "QTTagListView.h"


@interface ViewController () 

@end

@implementation ViewController

#pragma mark - 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupSubviews];
  
}

- (void)setupSubviews
{
    QTTagListView *tag = [[QTTagListView alloc] init];

    tag.backgroundColor = [UIColor purpleColor];

    tag.frame = CGRectMake(0, 100, 320, 200);

    tag.tagTitles = @[@"猪肉sdfsdf",@"猪肉",@"猪sdf肉",@"猪肉",@"猪肉",@"猪sdf肉",@"猪肉",@"猪sdf肉",@"猪肉"];

    [self.view addSubview:tag];
}

@end


















