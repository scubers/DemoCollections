//
//  QTRecommendView.m
//  DemoCollections
//
//  Created by mima on 15/8/3.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "QTRecommendView.h"
#import "QTRecommendViewCell.h"
#import "Masonry.h"

@interface QTRecommendView() <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, weak  ) UILabel                    *titleLabel;

@property (nonatomic, weak  ) UICollectionView           *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowlayout;

@end

@implementation QTRecommendView

#pragma mark - 生命周期
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupSubviews];
        
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    }
    return self;
}

- (void)setupSubviews
{
    //初始化collectionView
    {
        
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        
        flowlayout.scrollDirection         = UICollectionViewScrollDirectionHorizontal;
        flowlayout.itemSize                = CGSizeMake(QTRecommendCellWidth, QTRecommendCellHeight);
        flowlayout.minimumLineSpacing      = 2;
        
        _flowlayout = flowlayout;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds
                                                              collectionViewLayout:flowlayout];
        
        collectionView.delegate                       = self;
        collectionView.dataSource                     = self;
        collectionView.backgroundColor                = [UIColor clearColor];
        collectionView.showsHorizontalScrollIndicator = NO;
        
        [collectionView registerClass:[QTRecommendViewCell class] forCellWithReuseIdentifier:QTRecommendViewCellID];
        
        [self addSubview:collectionView];
        _collectionView = collectionView;
    }
    
    //初始化标题view
    {
        UILabel *titleLabel = [[UILabel alloc] init];
        
        titleLabel.text            = @"你可能想约";
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font            = [UIFont systemFontOfSize:13];
        
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    {
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat width = self.frame.size.width;
        CGFloat height = 30;
        
        _titleLabel.frame = CGRectMake(10, y, width, height);
        
        x = 0;
        y = height;
        width = self.frame.size.width;
        height = QTRecommendCellHeight;
        
        _collectionView.frame = CGRectMake(x, y, width, height);
        
        self.bounds = CGRectMake(0, 0, self.frame.size.width, CGRectGetMaxY(_collectionView.frame));
    }
}

#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datas.count ? self.datas.count : 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QTRecommendViewCell *cell = [QTRecommendViewCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    
    if (self.datas.count)
    {
        
    }
    
    return cell;
}



@end
















