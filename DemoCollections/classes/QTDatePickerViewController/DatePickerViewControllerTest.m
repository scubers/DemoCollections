//
//  DatePickerViewControllerTest.m
//  DemoCollections
//
//  Created by mima on 15/11/13.
//  Copyright © 2015年 王俊仁. All rights reserved.
//

#import "DatePickerViewControllerTest.h"
#import "QTCalendarViewController.h"

@implementation DatePickerViewControllerTest

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    
    QTCalendarViewController *vc = [[QTCalendarViewController alloc] initWithDate:[NSDate date] complete:^(QTCalendarViewController *controller, NSDate *date) {
        NSLog(@"%@", date);
    }];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    nav.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(action:)];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)action:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
