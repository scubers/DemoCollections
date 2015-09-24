//
//  ViewController.m
//  WindowExtension
//
//  Created by 王俊仁 on 15/9/23.
//  Copyright © 2015年 王俊仁. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "UIWindow+Extension.h"
#import "TableViewController.h"


#define func_random_color()                     [UIColor colorWithRed:(float)(arc4random()%10000)/10000.0 green:(float)(arc4random()%10000)/10000.0 blue:(float)(arc4random()%10000)/10000.0 alpha:(float)(arc4random()%10000)/10000.0]



@interface ViewController ()

@end

@implementation ViewController

static int temp = 0;
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor purpleColor];

    UIButton *pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    [pushBtn setTitle:@"push" forState:UIControlStateNormal];
    pushBtn.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    pushBtn.bounds = CGRectMake(0, 0, 80, 30);
    [self.view addSubview:pushBtn];
    [pushBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];



    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setTitle:@"pushControllers" forState:UIControlStateNormal];
    button2.center = CGPointMake(self.view.frame.size.width / 4, self.view.frame.size.height / 2);
    button2.bounds = CGRectMake(0, 0, 80, 30);
    [self.view addSubview:button2];
    [button2 addTarget:self action:@selector(click2:) forControlEvents:UIControlEventTouchUpInside];


    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button3 setTitle:@"popToRoot" forState:UIControlStateNormal];
    button3.bounds = CGRectMake(0, 0, 80, 30);
    button3.center = CGPointMake(self.view.frame.size.width / 4, self.view.frame.size.height / 4);
    [self.view addSubview:button3];
    [button3 addTarget:self action:@selector(click3:) forControlEvents:UIControlEventTouchUpInside];


    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button4 setTitle:@"popTo2" forState:UIControlStateNormal];
    button4.bounds = CGRectMake(0, 0, 80, 30);
    button4.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 4);
    [self.view addSubview:button4];
    [button4 addTarget:self action:@selector(click4:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *button5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button5 setTitle:@"pop" forState:UIControlStateNormal];
    button5.bounds = CGRectMake(0, 0, 80, 30);
    button5.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 5);
    [self.view addSubview:button5];
    [button5 addTarget:self action:@selector(click5:) forControlEvents:UIControlEventTouchUpInside];


    UIImageView *imgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imgView.image = [UIImage imageNamed:@"abc"];
    [self.view insertSubview:imgView atIndex:0];


    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, 30, 30)];

    label.text = [NSString stringWithFormat:@"%d", temp];
    label.backgroundColor = [UIColor yellowColor];

    [self.view addSubview:label];

}

- (void)click4:(id)sender
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIViewController *controller = [delegate.window.stackControllers objectAtIndex:1];

    [delegate.window popToController:controller animated:YES];

}

- (void)click3:(id)sender
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    [delegate.window popToRootControllerWithAnimated:NO];

}
- (void)click2:(id)sender
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    NSMutableArray *array = delegate.window.stackControllers;

    NSLog(@"--->%zd", array.count);

    array = [[array subarrayWithRange:NSMakeRange(0, 3)] mutableCopy];

    [delegate.window setControllers:array animated:YES];

}


- (void)click:(id)sender
{
    temp++;

    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    NSLog(@"%zd", delegate.window.subviews.count);

    ViewController *vc = [[ViewController alloc] init];
    vc.view.backgroundColor = func_random_color();

//    UITableViewController *tvc = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];

    [delegate.window pushController:nav animated:YES];

//    TableViewController *tvc = [[TableViewController alloc] init];
//
//    [delegate.window pushController:[[UINavigationController alloc] initWithRootViewController:tvc] animated:YES];


}


- (void)click5:(id)sender
{
    NSLog(@"=-=-=-=-=-=-=-=-=-=%@", self);

    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    [delegate.window popControllerWithAnimated:YES];
}

@end







