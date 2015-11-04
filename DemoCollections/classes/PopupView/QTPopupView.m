//
//  QTPopupView.m
//  DemoCollections
//
//  Created by 王俊仁 on 15/11/3.
//  Copyright © 2015年 王俊仁. All rights reserved.
//

#import "QTPopupView.h"

@interface QTPopupView()

@property (nonatomic, strong) NSMutableArray *titles;

@end

@implementation QTPopupView

#pragma mark - lifecycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
    }
    return self;
}

- (instancetype)initWithTitles:(NSArray *)titles inView:(UIView *)view contentSize:(CGSize)contentSize
{
    if (self = [super init])
    {

    }
    return self;
}

@end












