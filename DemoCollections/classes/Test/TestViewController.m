//
//  TestViewController.m
//  DemoCollections
//
//  Created by mima on 15/8/5.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "TestViewController.h"
#import "UIView+Extension.h"

@interface TestViewController ()

@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation TestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor purpleColor];
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    NSString *str = [UIView digView:ipc.view level:0];
    
    NSLog(@"%@", str);
    
    
    
}




@end
