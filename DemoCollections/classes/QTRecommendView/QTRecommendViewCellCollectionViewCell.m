//
//  QTRecommendViewCellCollectionViewCell.m
//  DemoCollections
//
//  Created by mima on 15/8/3.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "QTRecommendViewCellCollectionViewCell.h"

@implementation QTRecommendViewCellCollectionViewCell

#pragma mark - 生命周期
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupSubviews];
        
        self.backgroundColor = RandomColor;
    }
    return self;
}

- (void)setupSubviews
{
    
}

@end
