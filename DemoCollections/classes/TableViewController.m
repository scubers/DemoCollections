//
//  TableViewController.m
//  DemoCollections
//
//  Created by 王俊仁 on 15/7/19.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "TableViewController.h"
#import "QTTestViewController.h"
#import "QTTagListTestViewController.h"
#import "QTPickerViewController.h"
#import "NSDate+Extension.h"
#import "DynamicController.h"
#import "QTActionSheetViewController.h"
#import "BlocksKit+UIKit.h"
#import "RecommendTestViewController.h"
#import "QTAlertViewViewController.h"
#import "TestViewController.h"
#import "ViewController.h"

@interface TableViewController ()

@property (nonatomic, strong) NSArray *classArray;

@end

@implementation TableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _classArray = @[
                    @{@"QTSelectionView" : [QTTestViewController class]},
                    @{@"QTTagListView" : [QTTagListTestViewController class]},
                    @{@"QTPickerView" : [QTPickerViewController class]},
                    @{@"DynamicDemo" : [DynamicController class]},
                    @{@"QTActionSheet" : [QTActionSheetViewController class]},
                    @{@"QTRecommendView" : [RecommendTestViewController class]},
                    @{@"QTAlertView" : [QTAlertViewViewController class]},
                    @{@"TEST" : [TestViewController class]},
                    @{@"WindowExtension" : [ViewController class]},
                    ];
    
    UISwipeGestureRecognizer *swipe = [UISwipeGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        NSLog(@"======");
    }];
    
    [self.view addGestureRecognizer:swipe];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"左边" style:UIBarButtonItemStylePlain target:self action:nil];

    self.navigationItem.leftBarButtonItem = item;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UINavigationBar *nb = self.navigationController.navigationBar;

    [nb setBackgroundImage:[UIImage imageNamed:@"abc"] forBarMetrics:UIBarMetricsCompact];

    nb.backgroundColor = [UIColor redColor];

    NSLog(@"------->%@ %@", NSStringFromCGRect(nb.frame), nb.backgroundColor);

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithWhite:255/255.0 alpha:.1];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.classArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }

    cell.textLabel.text = [self.classArray[indexPath.row] allKeys].lastObject;

    cell.backgroundColor = [UIColor purpleColor];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *controller = [[((Class)[self.classArray[indexPath.row] allValues].lastObject) alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
