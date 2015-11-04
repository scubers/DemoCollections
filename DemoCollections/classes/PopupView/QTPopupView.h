//
//  QTPopupView.h
//  DemoCollections
//
//  Created by 王俊仁 on 15/11/3.
//  Copyright © 2015年 王俊仁. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QTPopupView : UIView

@property (nonatomic, strong) UITableView *tableView;

- (instancetype)initWithTitles:(NSArray *)titles
                        inView:(UIView *)view
                   contentSize:(CGSize)contentSize;

@end
