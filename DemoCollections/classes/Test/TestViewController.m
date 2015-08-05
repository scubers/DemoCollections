//
//  TestViewController.m
//  DemoCollections
//
//  Created by mima on 15/8/5.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "TestViewController.h"
#import "DrawView.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    DrawView *view = [[DrawView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:view];
    
}


@end
