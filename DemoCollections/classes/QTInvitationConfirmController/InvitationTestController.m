//
//  InvitationTestController.m
//  DemoCollections
//
//  Created by mima on 15/11/14.
//  Copyright © 2015年 王俊仁. All rights reserved.
//

#import "InvitationTestController.h"
#import "QTInvitationConfirmViewController.h"

@implementation InvitationTestController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor purpleColor];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    QTInvitationConfirmViewController *controller = [[QTInvitationConfirmViewController alloc] init];
    [self presentViewController:controller animated:NO completion:nil];
}

@end
