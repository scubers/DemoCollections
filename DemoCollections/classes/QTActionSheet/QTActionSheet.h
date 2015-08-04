//
//  QTActionSheet.h
//  DemoCollections
//
//  Created by mima on 15/7/28.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QTActionSheet;

typedef void(^QTActionSheetHandler)(QTActionSheet *actionSheet, NSUInteger index);

@interface QTActionSheet : UIView

- (instancetype)initWithTitle:(NSString *)title
                      handler:(QTActionSheetHandler)handler
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles;

- (CGFloat)heightForActionSheet;

- (void)show;
- (void)hide;

@end
