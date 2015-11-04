//
//  QTQRScanViewController.m
//  DemoCollections
//
//  Created by mima on 15/10/12.
//  Copyright © 2015年 王俊仁. All rights reserved.
//

#import "QTQRScanViewController.h"

#import <AVFoundation/AVFoundation.h>
#import "ZXingObjC.h"
#import "Masonry.h"
#import "ReactiveCocoa.h"

@interface QTQRScanViewController()<AVCaptureMetadataOutputObjectsDelegate,ZXCaptureDelegate>

@property (nonatomic, copy  ) QRScanCompleteBlock      completeBlock;
@property (nonatomic, copy  ) QRZxingScanCompleteBlock zxingCompleteBlock;

/**
 *  原生需要参数
 */
@property (nonatomic        ) AVCaptureSession           *captureSession;
@property (nonatomic        ) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) UIView                     *scanFrameView;
@property (nonatomic        ) BOOL                       lastResult;

/**
 *  zxing参数
 */
@property (nonatomic, strong) ZXCapture *capture;

/**
 *  是否使用ios7原生的二维码
 */
@property (nonatomic, assign, getter=isOriginal) BOOL original;

@end

@implementation QTQRScanViewController

- (instancetype)initWithCompleteBlock:(QRScanCompleteBlock)block
{
    if (self = [super init])
    {
        _completeBlock = block;
        _original = YES;
    }
    return self;
}

- (instancetype)initByZxingWithCompleteBlock:(QRZxingScanCompleteBlock)block
{
    if (self = [super init])
    {
        _zxingCompleteBlock = block;
        _original = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.isOriginal)
    {
        [self startReading];
    }
    else
    {
        [self startReadingByZXing];
    }
}


#pragma mark - Zxing扫描
- (void)startReadingByZXing
{
    self.capture = [[ZXCapture alloc] init];
    self.capture.camera = self.capture.back;
    self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    self.capture.rotation = 90.0f;
    
    self.capture.layer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.capture.layer];
    
    self.capture.delegate = self;
    self.capture.layer.frame = self.view.bounds;
    
    [self customUI4Zxing];
    
}

- (void)customUI4Zxing
{
    // 确定扫描范围
    CGRect rect = CGRectMake(self.view.center.x - 100, self.view.center.y - 100, 200, 200);
    NSLog(@"%@", NSStringFromCGRect(rect));
    
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    
    UIView *up = [[UIView alloc] init];
    UIView *left = [[UIView alloc] init];
    UIView *down = [[UIView alloc] init];
    UIView *right = [[UIView alloc] init];
    
    [view addSubview:up];
    [view addSubview:left];
    [view addSubview:down];
    [view addSubview:right];
    
    up.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    left.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    down.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    right.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    [up mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(up.superview);
        make.height.mas_equalTo(rect.origin.y);
    }];
    [left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left.superview);
        make.top.mas_equalTo(up.mas_bottom);
        make.height.mas_equalTo(rect.size.height);
        make.width.mas_equalTo(rect.origin.x);
    }];
    [right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(left.superview);
        make.top.mas_equalTo(up.mas_bottom);
        make.width.mas_equalTo(left);
        make.height.mas_equalTo(rect.size.height);
    }];
    [down mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(down.superview);
        make.top.mas_equalTo(left.mas_bottom);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:button];
    
    button.backgroundColor = [UIColor purpleColor];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.centerX.mas_equalTo(button.superview);
        make.bottom.mas_equalTo(button.superview).offset(-30);
    }];

    // 设置识别区域
    CGAffineTransform captureSizeTransform = CGAffineTransformMakeScale(360 / self.view.frame.size.width, 480 / self.view.frame.size.height);
    self.capture.scanRect = CGRectApplyAffineTransform(rect, captureSizeTransform);
    NSLog(@"%@", NSStringFromCGRect(self.capture.scanRect));
    
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
    
    if (self.zxingCompleteBlock)
    {
        self.zxingCompleteBlock(self, result);
    }
    
}


#pragma mark - ios原生的二维码扫描
- (BOOL)startReading
{
    // 获取 AVCaptureDevice 实例
    NSError * error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 初始化输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    // 创建会话
    _captureSession = [[AVCaptureSession alloc] init];
    // 添加输入流
    [_captureSession addInput:input];
    // 初始化输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    // 设置读取的范围
    
    // 添加输出流
    [_captureSession addOutput:captureMetadataOutput];
    
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    // 设置元数据类型 AVMetadataObjectTypeQRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // 创建输出对象
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    _videoPreviewLayer.frame = self.view.frame;
    [self.view.layer addSublayer:_videoPreviewLayer];
    // 开始会话
    [_captureSession startRunning];
    
    return YES;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    if (metadataObjects != nil && [metadataObjects count] > 0)
    {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSString *result;
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode])
        {
            result = metadataObj.stringValue;
            NSLog(@"%@", result);
            if (self.completeBlock)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _completeBlock(self,metadataObj);
                });
            }
            [self stopReading];
            
        } else {
            NSLog(@"不是二维码");
        }
    }
}

- (void)stopReading
{
    // 停止会话
    [_captureSession stopRunning];
    _captureSession = nil;
    
}

- (void)dealloc
{
    NSLog(@"");
}


@end
