//
//  QRDemoViewController.m
//  DemoCollections
//
//  Created by mima on 15/10/12.
//  Copyright © 2015年 王俊仁. All rights reserved.
//

#import "QRDemoViewController.h"
#import "QTQRUtil.h"
#import "Masonry.h"
#import "ReactiveCocoa.h"
#import "QTQRScanViewController.h"
#import "ZXingObjC.h"


@import AVFoundation;

@interface QRDemoViewController () <AVCaptureMetadataOutputObjectsDelegate, ZXCaptureDelegate>

@property (nonatomic, strong) ZXCapture *capture;

@end

@implementation QRDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupQR];
    
    UIButton *startScan = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [self.view addSubview:startScan];
    [startScan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(startScan.superview);
    }];
    [[startScan rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self startReading];
    }];
    
    startScan = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [self.view addSubview:startScan];
    [startScan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(startScan.superview);
    }];
    [[startScan rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self startReadingByZXing];
    }];
    
}

- (void)startReading
{
    QTQRScanViewController *controller = [[QTQRScanViewController alloc] initWithCompleteBlock:^(QTQRScanViewController *scanController, AVMetadataMachineReadableCodeObject *object) {
        NSLog(@"%@", object);
        [scanController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:controller] animated:YES completion:nil];
}

- (void)startReadingByZXing
{
    QTQRScanViewController *controller = [[QTQRScanViewController alloc] initByZxingWithCompleteBlock:^(QTQRScanViewController *scanController, ZXResult *object) {
        [scanController dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"%@", [NSThread currentThread]);
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", object] delegate:nil cancelButtonTitle:@"adb" otherButtonTitles:nil];
        [al show];
        
        NSLog(@"%@", object);
        
//        object.resultMetadata
    }];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:controller] animated:YES completion:nil];
    
}

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result
{
    if (!result) return;
    
    // We got a result. Display information about the result onscreen.
    NSString *display = [NSString stringWithFormat:@"Scanned! content:%@", result.text];
    
    NSLog(@"%@", display);
    
    // Vibrate
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    [self.capture stop];
    
}

- (void)setupQR
{
    NSString *string = @"http://www.baidu.com/";
    UIImage *image = [QTQRUtil encodeMessage:string withSize:150];
    image = [QTQRUtil changeColorForQRCode:image withColor:[UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:1]];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    
    imgView.center = self.view.center;
    
    [self.view addSubview:imgView];
    
    
    
    NSError *error = nil;
    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix *result = [writer encode:@"http://www.sina.com.cn"
                                  format:kBarcodeFormatQRCode
                                   width:150
                                  height:150
                                   error:&error];
    
    ZXImage *zximage = [ZXImage imageWithMatrix:result onColor:[UIColor purpleColor].CGColor offColor:[UIColor clearColor].CGColor];
    
    CGImageRef image1 = [zximage cgimage];
    
    UIImageView *imgViewZxing = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:image1]];
    imgViewZxing.frame = CGRectMake(0, 64, 150, 150);
    
    [self.view addSubview:imgViewZxing];
    
    
}

@end
