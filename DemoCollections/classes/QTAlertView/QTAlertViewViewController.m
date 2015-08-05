//
//  QTAlertViewViewController.m
//  DemoCollections
//
//  Created by mima on 15/8/4.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "QTAlertViewViewController.h"
#import "QTAlertView.h"

@interface QTAlertViewViewController () <QTAlertViewDelegate>

@property (nonatomic, strong) QTAlertView *alertView;

@end

@implementation QTAlertViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor purpleColor];
    
    QTAlertView *view = [[QTAlertView alloc] initWithTitle:@"111" message:@"222" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] mode:QTAlertViewModeDefault handler:^(QTAlertView *alertView, NSInteger index) {
        NSLog(@"%ld", index);
    }];
    
    view.delegate = self;
    
    _alertView = view;

    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_alertView show];
}

- (CGFloat)alertView:(QTAlertView *)alertView heightForCustmizedView:(UIView *)custmizedView
{
    return 55;
}

- (UIView *)custmizedViewForAlertView:(QTAlertView *)alertView
{
    return [UIButton buttonWithType:UIButtonTypeContactAdd];
}


@end
