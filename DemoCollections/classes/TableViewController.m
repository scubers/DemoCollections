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

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    

}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%f,%f", self.tableView.contentSize.height,self.view.height - 64);
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%zd", indexPath.row];

    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"QTSelectionView";
        }break;

        case 1:
        {
            cell.textLabel.text = @"QTTagListView";
        }break;

        case 2:
        {
            cell.textLabel.text = @"QTPickerView";
        }break;

        case 3:
        {
            cell.textLabel.text = @"DynamicDemo";
        }break;
            
        case 4:
        {
            cell.textLabel.text = @"QTActionSheet";
        }break;
        case 5:
        {
            cell.textLabel.text = @"QTRecommendView";
        }break;
        case 6:
        {
            cell.textLabel.text = @"QTAlertView";
        }break;
        case 7:
        {
            cell.textLabel.text = @"TEST";
        }break;
        default:
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            QTTestViewController *tc = [[QTTestViewController alloc] init];
            [self.navigationController pushViewController:tc animated:YES];
        }break;

        case 1:
        {
            QTTagListTestViewController *tc = [[QTTagListTestViewController alloc] init];

            [self.navigationController pushViewController:tc animated:YES];
        }break;

        case 2:
        {
            QTPickerViewController *pv = [[QTPickerViewController alloc] init];

            [self.navigationController pushViewController:pv animated:YES];
        }break;

        case 3:
        {
            DynamicController *dc = [[DynamicController alloc] init];

            [self.navigationController pushViewController:dc animated:YES];
        }break;
            
        case 4:
        {
            QTActionSheetViewController *dc = [[QTActionSheetViewController alloc] init];
            
            [self.navigationController pushViewController:dc animated:YES];
        }break;
            
        case 5:
        {
            RecommendTestViewController *dc = [[RecommendTestViewController alloc] init];
            
            [self.navigationController pushViewController:dc animated:YES];
        }break;
            
        case 6:
        {
            QTAlertViewViewController *dc = [[QTAlertViewViewController alloc] init];
            
            [self.navigationController pushViewController:dc animated:YES];
        }break;
            
        case 7:
        {
            TestViewController *dc = [[TestViewController alloc] init];
            
            [self.navigationController pushViewController:dc animated:YES];
        }break;

        default:
            break;
    }

}

@end
