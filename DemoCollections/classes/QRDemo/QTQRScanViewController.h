//
//  QTQRScanViewController.h
//  DemoCollections
//
//  Created by mima on 15/10/12.
//  Copyright © 2015年 王俊仁. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVMetadataMachineReadableCodeObject, QTQRScanViewController, ZXResult;

typedef void(^QRScanCompleteBlock)(QTQRScanViewController *scanController,AVMetadataMachineReadableCodeObject *object);
typedef void(^QRZxingScanCompleteBlock)(QTQRScanViewController *scanController,ZXResult *object);

@interface QTQRScanViewController : UIViewController

- (instancetype)initWithCompleteBlock:(QRScanCompleteBlock)block;

- (instancetype)initByZxingWithCompleteBlock:(QRZxingScanCompleteBlock)block;

@end
