//
//  QTBounceMenuViewController.m
//  DemoCollections
//
//  Created by mima on 15/11/12.
//  Copyright © 2015年 王俊仁. All rights reserved.
//

#import "QTBounceMenuViewController.h"
#import "QTBounceMenuView.h"

#define func_random_color() [UIColor colorWithRed:(float)(arc4random()%10000)/10000.0 green:(float)(arc4random()%10000)/10000.0 blue:(float)(arc4random()%10000)/10000.0 alpha:(float)(arc4random()%10000)/10000.0]


@interface QTBounceMenuViewController() <QTBounceMenuViewDelegate>

@end

@implementation QTBounceMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    QTBounceMenuView *menu = [[QTBounceMenuView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    menu.delegate = self;
    
    menu.lineGap = 20;
    menu.baseItemSize = CGSizeMake(60, 60);
    menu.totalColumn = 3;
    menu.totalLine = 3;
    
    menu.contentInsets = UIEdgeInsetsMake(200, 40, 0, 40);
    
    [menu showAtView:self.view complete:^(QTBounceMenuView *bounceMenuView) {
        
    }];
    
}

#pragma mark - <QTBounceMenuViewDelegate>
- (NSInteger)numberOfItemForBounceMenuView:(QTBounceMenuView *)bounceMenuView
{
    return 19;
}

//- (CGRect)frameForItemInBounceMenuView:(QTBounceMenuView *)bounceMenuView atIndex:(NSInteger)index
//{
//    CGRect rect = bounceMenuView.bounds;
//    
//    CGFloat width  = 100;
//    CGFloat height = 100;
//    CGFloat x = 0;
//    CGFloat y = 0;
//    
//    int baseColumn = 3;
//    
//    int line = (int)index / baseColumn;
//    int column = (int)index % baseColumn;
//    
//    CGFloat columnGap = (rect.size.width - (baseColumn * width)) / (baseColumn - 1);
//    CGFloat lineGap = 4;
//    
//    x = column * (width + columnGap);
//    y = line * (height + lineGap);
//    
//    return CGRectMake(x, y, width, height);
//}

- (UIView *)bounceMenuView:(QTBounceMenuView *)bounceMenuView viewForItemAtIndex:(NSInteger)index
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = func_random_color();
    return view;
}

- (void)bounceMenuView:(QTBounceMenuView *)bounceMenuView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"%zd", index);
}

@end







