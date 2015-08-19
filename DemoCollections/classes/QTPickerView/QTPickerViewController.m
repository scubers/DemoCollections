//
//  QTPickerViewController.m
//  DemoCollections
//
//  Created by 王俊仁 on 15/7/19.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "QTPickerViewController.h"
#import "Masonry.h"
#import "BlocksKit.h"
#import "ReactiveCocoa.h"
#import "POP+MCAnimate.h"
#import "QTPickerView.h"
#import "QTSelectionView.h"

@interface QTPickerViewController () <QTPickerViewDateSource,QTPickerViewDelegate,QTSelectionViewDelegate,QTSelectionViewDataSource>

@property (nonatomic, strong) QTPickerView *pickerView;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation QTPickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    

//    QTPickerView *pickerView = [[QTPickerView alloc] initWithPickerMode:QTPickerModeCustomize];
    QTPickerView *pickerView = [[QTPickerView alloc] initWithPickerMode:QTPickerModeDate
                                                              withBlock:^(QTPickerView *pickerView, BOOL isConfirm) {
        if (isConfirm)
        {
            UIPickerView *pv = (UIPickerView *)pickerView.pickerView;
            NSLog(@"%.2zd小时，%@分钟",[pv selectedRowInComponent:0], [pv selectedRowInComponent:2] == 0 ? @"00": @"30");
            [pickerView hide];
        }
        else
        {
            NSLog(@"取消");
            [pickerView hide];
        }
    }];

    pickerView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    pickerView.delegate        = self;
    pickerView.dataSource      = self;
//    pickerView.frame           = CGRectMake(0, 0, 300, 250);
    pickerView.heightForMiddleBar = 44;
    pickerView.heightForBottomView = 44;

    [self.view addSubview:pickerView];
    _pickerView = pickerView;


    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];

    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.mas_equalTo(btn.superview);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@", _pickerView);
    [_pickerView showWithDirection:QTPickerAnimateDirectionTop];
}

- (void)dealloc
{
    [_timer invalidate];
}

#pragma mark - <QTPickerViewDateSource,QTPickerViewDelegate>

- (UIView *)viewForMiddleBarInPickerView:(QTPickerView *)pickerView
{
    QTSelectionView *sv = [[QTSelectionView alloc] init];

    sv.dataSource = self;
    sv.delegate   = self;

    sv.scrollable = NO;

    return sv;

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return 24;
            break;

        case 1:
            return 1;
            break;

        case 2:
            return 2;
            break;

        case 3:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [NSString stringWithFormat:@"%.2zd",row];
            break;

        case 1:
            return @"小时";
            break;

        case 2:
            return row ? @"30" : @"00";
            break;

        case 3:
            return @"分钟";
            break;
        default:
            return nil;
            break;
    }
}



@end













