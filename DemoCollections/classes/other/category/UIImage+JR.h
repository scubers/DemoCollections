//
//  UIImage+JR.h
//  Weibo
//
//  Created by 王俊仁 on 15/4/18.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JR)

/**
 *  伸缩图片，默认拉伸最中间
 */
+ (UIImage *)resizedImageWithName:(NSString *)name;

/**
 *  拉伸图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name left:(double)left top:(double)top;

/**
 *  根据图片，获取其圆形图片
 */
+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

@end
