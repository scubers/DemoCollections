//
//  PopupViewTestController.m
//  DemoCollections
//
//  Created by 王俊仁 on 15/11/3.
//  Copyright © 2015年 王俊仁. All rights reserved.
//

#import "PopupViewTestController.h"
#import "QTPopupView.h"

@interface PopupViewTestController()

@end

@implementation PopupViewTestController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [touches.anyObject locationInView:self.view];

//    QTPopupView *popview = [[QTPopupView alloc] initWithTitles:@[@"黑名单",@"举报",@"打人"]
//                                                        inView:self.navigationController.view
//                                                       atPoint:point
//                                                   contentSize:CGSizeMake(100, 150)];
    
    QTPopupView *popview = [[QTPopupView alloc] initWithTitleAndIcons:@[
                                                                        @{@"黑名单": [UIImage imageNamed:@"p_ico_bar"]},
                                                                        @{@"打人": [UIImage imageNamed:@"p_ico_rice"]},
                                                                        @{@"你妹": [UIImage imageNamed:@"p_ico_cofee"]},
                                                                        ]
                                                               inView:self.navigationController.view
                                                              atPoint:point
                                                          contentSize:CGSizeMake(150, 200)
                                                             complete:nil];

    popview.itemTextColor = [UIColor whiteColor];
    popview.contentInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    popview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    popview.itemRowHieght = 50;
    popview.itemFontSize = 13;
    popview.arrowPosition = 0.3;
    popview.arrowPointTo = (arc4random_uniform(4));
    
    popview.alpha = 0.1;
    [UIView animateWithDuration:0.25 animations:^{
        [popview show];
        popview.alpha = 1;
    }];
    
}

@end
