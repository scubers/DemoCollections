//
//  TestViewController.m
//  DemoCollections
//
//  Created by mima on 15/8/5.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "TestViewController.h"
#import "UIView+Extension.h"
#import "Masonry.h"
#import "ReactiveCocoa.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>

@interface TestViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITextView *tv;

@property (nonatomic, weak) UIButton *btn;

@end

@implementation TestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.backgroundColor = [UIColor blackColor];
    
    [btn setTitle:@"定积分" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"t_ico_rose"] forState:UIControlStateNormal];
    
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    btn.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7);
    [self.view addSubview:btn];
    _btn = btn;
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 30));
        make.center.mas_equalTo(btn.superview);
    }];

}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    static BOOL flag = YES;

    if (flag)
    {
        [_btn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_btn.superview).offset(-100);
        }];
    }
    else
    {
        [_btn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_btn.superview).offset(100);
        }];
    }

    flag = !flag;

    [UIView animateWithDuration:2 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}



- (void)dealloc
{
    NSLog(@"");
}


@end
