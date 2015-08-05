//
//  QTAlertView.h
//  DemoCollections
//
//  Created by mima on 15/8/4.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define QTAlertViewTitleHeight 120
#define QTAlertViewButtonHeight 55
#define QTAlertViewTextFieldHeight 44

@class QTAlertView;

typedef enum
{
    QTAlertViewModeDefault,
    QTAlertViewModePassword,
    QTAlertViewModeUsernameAndPassword,
    QTAlertViewModeCustmized
    
} QTAlertViewMode;

typedef void(^QTAlertViewHandler)(QTAlertView *alertView, NSInteger index);

@protocol QTAlertViewDelegate <NSObject>

@optional
- (UIView *)custmizedViewForAlertView:(QTAlertView *)alertView;
- (UIView *)titleViewForAlertView:(QTAlertView *)alertView;

- (CGFloat)alertView:(QTAlertView *)alertView heightForCustmizedView:(UIView *)custmizedView;


@end

@interface QTAlertView : UIView

@property (nonatomic, weak            ) id<QTAlertViewDelegate> delegate;
@property (nonatomic, weak, readonly  ) UIView              *custmizedView;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                         mode:(QTAlertViewMode)mode
                      handler:(QTAlertViewHandler)handler;

- (CGFloat)caculateAlertViewHeight;

- (NSString *)username;
- (NSString *)password;

- (void)show;
- (void)hide;


@end
