//
//  RecommendTestViewController.m
//  DemoCollections
//
//  Created by mima on 15/8/3.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "RecommendTestViewController.h"
#import "QTRecommendView.h"

@interface RecommendTestViewController ()



@end

@implementation RecommendTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor purpleColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    QTRecommendView *view = [[QTRecommendView alloc] initWithFrame:CGRectMake(0, 100, 320, 150)];
    
    [self.view addSubview:view];
    
}

@end








