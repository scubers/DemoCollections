//
//  QTInvitationConfirmViewController.h
//  DemoCollections
//
//  Created by mima on 15/11/14.
//  Copyright © 2015年 王俊仁. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QTInvitationConfirmViewController, QTInvitation;

typedef enum
{
    QTInvitationConfirmViewControllerStatusNormal,
    QTInvitationConfirmViewControllerStatusLoading,
    QTInvitationConfirmViewControllerStatusError
}QTInvitationConfirmViewControllerStatus;

typedef void(^QTConfirmBlock)(QTInvitationConfirmViewController *controller, QTInvitation *invitation);


@interface QTInvitationConfirmViewController : UIViewController

@property (nonatomic, assign) QTInvitationConfirmViewControllerStatus status;


- (instancetype)initWithInvitation:(QTInvitation *)invitation extraRose:(int)extraRose block:(QTConfirmBlock)block;
- (void)setStatus:(QTInvitationConfirmViewControllerStatus)status animated:(BOOL)animated;


@end
