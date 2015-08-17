//
//  QTActionSheetViewController.m
//  DemoCollections
//
//  Created by mima on 15/7/28.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "QTActionSheetViewController.h"
#import "QTActionSheet.h"

@interface QTActionSheetViewController ()<QTActionSheetDelegate>

@property (nonatomic, assign) BOOL flag;


@end

@implementation QTActionSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor purpleColor];

    
    
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    QTActionSheet *sheet = [[QTActionSheet alloc] initWithTitle:nil
                                                        handler:^(QTActionSheet *actionSheet, NSUInteger index) {
                                                            
                                                            NSLog(@"%zd", index);
                                                            
                                                            
                                                        } cancelButtonTitle:@"取消" otherButtonTitles:@[@"1",@"2"]];
    sheet.delegate = self;
    
    [sheet show];
}

- (UIView *)titleViewForActionSheet:(QTActionSheet *)actionSheet
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor yellowColor];
    return view;
}

- (CGFloat)heightForTitleViewInActionSheet:(QTActionSheet *)actionSheet
{
    return 100;
}



@end
