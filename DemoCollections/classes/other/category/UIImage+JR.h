//
//  UIImage+JR.h
//  Weibo
//
//  Created by 王俊仁 on 15/4/18.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JR)

+ (UIImage *)resizedImageWithName:(NSString *)name;

+ (UIImage *)resizedImageWithName:(NSString *)name left:(double)left top:(double)top;

+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 *  返回一个三角形
 */
+ (UIImage *)trangleWithColor:(UIColor *)color andSize:(CGSize)size;

+ (UIImage *)imageWithView:(UIView *)view inRect:(CGRect)rect;

@end
