//
//  UIImage+JR.m
//  Weibo
//
//  Created by 王俊仁 on 15/4/18.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "UIImage+JR.h"

@implementation UIImage (JR)

+ (UIImage *)resizedImageWithName:(NSString *)name
{
    return [self resizedImageWithName:name left:0.5 top:0.5];
}


+ (UIImage *)resizedImageWithName:(NSString *)name left:(double)left top:(double)top
{
    UIImage *image = [self imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}

+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    // 1.加载原图
    UIImage *oldImage = [UIImage imageNamed:name];
    
    // 2.开启上下文
    CGFloat imageW = oldImage.size.width + 2 * borderWidth;
    CGFloat imageH = oldImage.size.height + 2 * borderWidth;
    
    imageW = MIN(imageW, imageH);
    CGSize imageSize = CGSizeMake(imageW, imageW);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    // 3.取得当前的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 4.画边框(大圆)
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5; // 大圆半径
    CGFloat centerX = bigRadius; // 圆心
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx); // 画圆
    
    // 5.小圆
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    
    // 6.画图
    [oldImage drawInRect:CGRectMake(borderWidth, borderWidth, oldImage.size.width, oldImage.size.height)];
    
    // 7.取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 8.结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)trangleWithColor:(UIColor *)color andSize:(CGSize)size
{
    // 1.开启上下文
    CGFloat imageW = size.width;
    CGFloat imageH = size.height;
    
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    // 2.取得当前的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 设置画画颜色
    [color set];
    
    // 3.创建路线
    CGMutablePathRef path = CGPathCreateMutable();

    // 4.画三角形
    CGPathMoveToPoint(path, NULL, imageW / 2, 0);
    CGPathAddLineToPoint(path, NULL, 0, imageH);
    CGPathAddLineToPoint(path, NULL, imageW, imageH);
    CGPathAddLineToPoint(path, NULL, imageW / 2, 0);
    
    // 5.在上下文中添加路线
    CGContextAddPath(ctx, path);
    // 6.画线到上下文
    CGContextFillPath(ctx);
  
    // 7.取图
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 8.结束上下文
    UIGraphicsEndImageContext();
    
    return image;

}

+ (UIImage *)imageWithView:(UIView *)view inRect:(CGRect)rect
{
    if (UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    }
    else
    {
        UIGraphicsBeginImageContext(view.frame.size);
    }
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    UIRectClip(rect);
    
    [view.layer renderInContext:context];
    
    UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    //压缩图片
    
    
    if (UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    }
    else
    {
        UIGraphicsBeginImageContext(rect.size);
    }
    
    [fullImage drawInRect:rect];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}

@end










