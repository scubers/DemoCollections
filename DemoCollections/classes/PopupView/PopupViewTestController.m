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

    if (point.x < 100) {
        return;
    }

    QTPopupView *popview = [[QTPopupView alloc] initWithTitles:@[@"黑名单",@"举报",@"打人"] inView:self.view atPoint:point contentSize:CGSizeMake(100, 150)];

    popview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    popview.itemRowHieght = 30;
    popview.itemFontSize = 13;
    popview.arrowPosition = 0.3;
}

@end
