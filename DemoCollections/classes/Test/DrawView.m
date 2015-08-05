//
//  DrawView.m
//  DemoCollections
//
//  Created by mima on 15/8/5.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "DrawView.h"
#import <QuartzCore/QuartzCore.h>

@interface DrawView()

@end

@implementation DrawView

#pragma mark - 生命周期

#pragma mark - 生命周期
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
//        [self setupSubviews];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
}

@end
