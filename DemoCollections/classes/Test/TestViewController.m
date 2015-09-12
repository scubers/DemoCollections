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
#import <objc/runtime.h>
#import "BlocksKit.h"




@interface TestViewController ()
<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate,
NSURLConnectionDelegate, UITextViewDelegate>

@property (nonatomic, strong) UITextView *tv;

@property (nonatomic, weak) UIButton *btn;

@property (nonatomic, assign) NSUInteger cursorLocation;

@property (nonatomic, strong) id content;

@end

@implementation TestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *view1 = [[UIView alloc] init];
    
    view1.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:view1];
    
    
    UIView *view2 = [[UIView alloc] init];
    view2.backgroundColor = [UIColor yellowColor];
    
    [view1 addSubview:view2];
    
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view1).offset(10);
        make.bottom.mas_equalTo(view1).offset(-10);
        make.left.mas_equalTo(view1).offset(10);
        make.right.mas_equalTo(view1).offset(-10);
        
        
    }];
    
    
    CGFloat h = [view2 systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    NSLog(@"%f", h);
    
}





- (void)dealloc
{
    NSLog(@"");
}


@end
