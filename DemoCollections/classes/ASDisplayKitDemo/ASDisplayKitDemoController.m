//
//  ASDisplayKitDemoController.m
//  DemoCollections
//
//  Created by mima on 15/11/28.
//  Copyright © 2015年 王俊仁. All rights reserved.
//

#import "ASDisplayKitDemoController.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface ASDisplayKitDemoController() <ASCollectionViewDelegate, ASCollectionViewDataSource>

@property (nonatomic, strong) ASCollectionView *collectionView;

@end

@implementation ASDisplayKitDemoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupSubviews];
    
}

- (void)setupSubviews
{
    UICollectionViewLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    _collectionView = [[ASCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout asyncDataFetching:YES];
    
    _collectionView.asyncDataSource = self;
    _collectionView.asyncDelegate = self;
    
    [self.view addSubview:_collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (ASCellNode *)collectionView:(ASCollectionView *)collectionView nodeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end







