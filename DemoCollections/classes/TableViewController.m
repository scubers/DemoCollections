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

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSDate *date = [NSDate date];

    NSLog(@"%@",[[[date yesterday] yesterday] yesterday]);

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

        default:
            break;
    }

}

@end
