//
//  QTParentViewController.m
//  DemoCollections
//
//  Created by mima on 15/11/28.
//  Copyright © 2015年 王俊仁. All rights reserved.
//

#import "QTParentViewController.h"
#import "QTFirstController.h"
#import "QTSecondController.h"
#import "QTThirdController.h"
#import "UIBarButtonItem+BlocksKit.h"

@interface QTParentViewController ()

@property (nonatomic, weak) UIViewController *currentController;

@property (nonatomic, assign, getter=isAnimating) BOOL animating;

@end

@implementation QTParentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    QTFirstController *fst = [[QTFirstController alloc] init];
    QTSecondController *sec = [[QTSecondController alloc] init];
    QTThirdController *thd = [[QTThirdController alloc] init];
    
    fst.view.backgroundColor = RandomColor;
    sec.view.backgroundColor = RandomColor;
    thd.view.backgroundColor = RandomColor;
    
    [self addChildViewController:fst];
    [self addChildViewController:sec];
    [self addChildViewController:thd];
    
    
    [self.view addSubview:fst.view];
    self.currentController = fst;
    
    [self setupNavigationItem];
    
}

- (void)setupNavigationItem
{
    self.navigationItem.rightBarButtonItems = @[
                                                [self createItemWithIndex:0],
                                                [self createItemWithIndex:1],
                                                [self createItemWithIndex:2],
                                                ];
}

- (UIBarButtonItem *)createItemWithIndex:(int)index
{
    
    __weak typeof(self) ws = self;
    return [[UIBarButtonItem alloc] bk_initWithTitle:[NSString stringWithFormat:@"%d", index] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [ws click:index];
    }];
    
}

- (void)click:(int)index
{
    if (self.isAnimating || self.currentController == self.childViewControllers[index]) return;
    
    self.animating = YES;
    
    UIViewController *from = self.currentController;
    UIViewController *to = self.childViewControllers[index];
    
    [to willMoveToParentViewController:self];
    [to isMovingToParentViewController];
    
    [from isMovingFromParentViewController];
    
    to.view.frame = CGRectApplyAffineTransform(to.view.frame, CGAffineTransformMakeTranslation(to.view.frame.size.width, 0));
    [self transitionFromViewController:from toViewController:to duration:.35 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        to.view.backgroundColor = RandomColor;
        to.view.frame = from.view.frame;
        from.view.frame = CGRectApplyAffineTransform(from.view.frame, CGAffineTransformMakeTranslation(-to.view.frame.size.width, 0));
    } completion:^(BOOL finished) {
        if (finished) {
            self.currentController = self.childViewControllers[index];
            from.view.frame = self.view.frame;
            to.view.frame = self.view.frame;
            
            [to didMoveToParentViewController:self];
            
            self.animating = NO;
        }
    }];
}

@end









