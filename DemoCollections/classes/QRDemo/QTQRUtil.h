//
//  QTQRUtil.h
//  QTime
//
//  Created by mima on 15/10/12.
//  Copyright © 2015年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QTQRUtil : NSObject

#pragma mark - ios原生
+ (UIImage *)encodeMessage:(NSString *)message withSize:(CGFloat)size;

+ (UIImage *)changeColorForQRCode:(UIImage *)qrImage withColor:(UIColor *)color;

#pragma mark - ZXing
+ (UIImage *)encodeMessageByZxing:(NSString *)message withSize:(CGSize)size foregroundColor:(UIColor *)foregroundColor backgroundColor:(UIColor *)backgroundColor;


@end
