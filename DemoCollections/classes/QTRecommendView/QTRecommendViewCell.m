//
//  QTRecommendViewCell.m
//  DemoCollections
//
//  Created by mima on 15/8/3.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "QTRecommendViewCell.h"
#import "Masonry.h"

@interface QTRecommendViewCell()

@property (nonatomic, weak) UIImageView *headImgView;

@property (nonatomic, weak) UIView *bottomView;

@property (nonatomic, weak) UILabel *distanceLabel;
@property (nonatomic, weak) UILabel *timeLabel;

@end

@implementation QTRecommendViewCell

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
    //初始化
    {
        UIImageView *headImgView = [[UIImageView alloc] init];
        
        [self.contentView addSubview:headImgView];
        _headImgView = headImgView;
    }
    
    {
        UIView *bottomView = [[UIView alloc] init];
        
        bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        [self.contentView addSubview:bottomView];
        _bottomView = bottomView;
        
        
        {
            UILabel *distanceLabel = [[UILabel alloc] init];
            
            distanceLabel.textAlignment = NSTextAlignmentLeft;
            distanceLabel.textColor     = [UIColor whiteColor];
            distanceLabel.layer.opacity = 1;
            
            [bottomView addSubview:distanceLabel];
            _distanceLabel = distanceLabel;
            
            UILabel *timeLabel = [[UILabel alloc] init];
            
            timeLabel.textAlignment = NSTextAlignmentRight;
            timeLabel.textColor     = [UIColor whiteColor];
            
            [bottomView addSubview:timeLabel];
            _timeLabel = timeLabel;
        }
    }
    
    //设置约束
    {
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_headImgView.superview);
        }];
        
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(_bottomView.superview);
            make.height.mas_equalTo(30);
        }];
        
        [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(_distanceLabel.superview);
            make.left.mas_equalTo(_distanceLabel.superview).offset(5);
            make.right.mas_equalTo(_distanceLabel.superview.mas_centerX);
        }];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(_timeLabel.superview);
            make.left.mas_equalTo(_distanceLabel.mas_right);
            make.width.mas_equalTo(_distanceLabel);
        }];
    }
    
    _timeLabel.text     = @"09:00";
    _distanceLabel.text = @"0.5km";
    _headImgView.image  = [UIImage imageNamed:@"abc"];
}

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath
{
    QTRecommendViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:QTRecommendViewCellID forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[QTRecommendViewCell alloc] init];
    }
    return cell;
}

@end












