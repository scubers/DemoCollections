//
//  QTRecommendViewCell.h
//  DemoCollections
//
//  Created by mima on 15/8/3.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import <UIKit/UIKit.h>

#define QTRecommendViewCellID @"QTRecommendViewCellID"

#define QTRecommendCellWidth 120
#define QTRecommendCellHeight 150

@interface QTRecommendViewCell : UICollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;

@end
