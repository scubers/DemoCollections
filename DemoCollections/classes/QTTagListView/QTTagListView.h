//
//  QTTagListView.h
//  DemoCollections
//
//  Created by 王俊仁 on 15/7/18.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QTTagListView : UIView

@property (nonatomic, strong) NSArray  *tagTitles;

@property (nonatomic, assign) UIEdgeInsets contentInsets;


@property (nonatomic, assign) CGFloat rowMargin;
@property (nonatomic, assign) CGFloat columnMargin;

@property (nonatomic, assign) CGFloat tagHeight;

/**
 *  最多有多少列
 */
@property (nonatomic, assign) NSUInteger columns;

- (void)reloadTags;

@end
