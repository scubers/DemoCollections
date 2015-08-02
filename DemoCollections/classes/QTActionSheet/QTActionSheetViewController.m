//
//  QTActionSheetViewController.m
//  DemoCollections
//
//  Created by mima on 15/7/28.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "QTActionSheetViewController.h"
#import "QTActionSheet.h"

@interface QTActionSheetViewController ()

@property (nonatomic, assign) BOOL flag;


@end

@implementation QTActionSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor purpleColor];

    
    
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    QTActionSheet *sheet = [[QTActionSheet alloc] initWithTitle:@"你懂的"
                                                        handler:^(QTActionSheet *actionSheet, NSUInteger index, UIButton *button) {
                                                            
                                                            NSLog(@"%zd", index);
                                                            
                                                            
                                                        } cancelButtonTitle:@"取消" otherButtonTitles:@[@"1",@"2"]];
    
    [sheet show];
}



@end