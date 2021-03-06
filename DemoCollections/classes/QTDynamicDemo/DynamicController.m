//
//  DynamicController.m
//  DemoCollections
//
//  Created by 王俊仁 on 15/7/24.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "DynamicController.h"
#import "NewtonsCradleView.h"
#import "BlocksKit+UIKit.h"

@interface DynamicController() <UICollisionBehaviorDelegate, UIDynamicAnimatorDelegate,
UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak  ) UITableView          *tableView;
@property (nonatomic, strong) UIDynamicAnimator    *tableViewAnimator;

@property (nonatomic, strong) UIDynamicAnimator    *animator;

@property (nonatomic, strong) UIDynamicBehavior    *behavior;

@property (nonatomic, strong) UIPushBehavior       *pushBehavior;

@property (nonatomic, strong) UIGravityBehavior    *gravity;

@property (nonatomic, strong) UICollisionBehavior  *collision;

@property (nonatomic, strong) UIAttachmentBehavior *attachment;

@property (nonatomic, strong) UISnapBehavior       *snap;

@property (nonatomic, strong) UIPushBehavior       *push;

@property (nonatomic, assign) CGVector             vector;


@property (nonatomic, weak  ) UIView               *centerCircle;

@end

@implementation DynamicController

#pragma mark - 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];


    [self advanceDemo];


}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

}



#pragma mark - 私有方法
- (UIView *)createBall
{
    UIView *box = [[UIView alloc] initWithFrame:CGRectMake(arc4random_uniform(200), 100, 80, 80)];

    box.layer.cornerRadius = 40;
    box.clipsToBounds = YES;

    box.backgroundColor = RandomColor;

    [self.view addSubview:box];
    return box;
}

#pragma mark - <UICollisionBehaviorDelegate>
- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p
{

}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{

}

#pragma mark - UIDynamicAnimatorDelegate
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{

}

- (void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator
{

}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];

//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        UIView *view = [self createBall];
        view.frame = CGRectMake(0, 0, 80, 80);
        view.backgroundColor = RandomColor;
        [cell.contentView addSubview:view];

        UIDynamicAnimator *animate = [[UIDynamicAnimator alloc] initWithReferenceView:cell];

//        UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:view snapToPoint:CGPointMake(320/2, 80/2)];

        UIGravityBehavior *gr = [[UIGravityBehavior alloc] initWithItems:@[view]];

        [animate addBehavior:gr];

//        [animate addBehavior:snap];



    }
    cell.textLabel.text = [NSString stringWithFormat:@"%zd", indexPath.row];



    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - test Method

/**
 *  类message.app的滚动动画
 */
- (void)tableViewDemo
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];

    tableView.dataSource = self;
    tableView.delegate   = self;

    [self.view addSubview:tableView];
    _tableView = tableView;


}

/**
 *  高级综合demo
 */
- (void)advanceDemo
{
    UIView *ball = [self createBall];

    ball.center = self.view.center;

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panBall:)];

    [ball addGestureRecognizer:pan];

    self.collision.collisionMode = UICollisionBehaviorModeEverything;
    [self.collision addItem:ball];

    [self.animator addBehavior:self.collision];
}

- (void)panBall:(UIPanGestureRecognizer *)recognizer
{

    if (recognizer.state == UIGestureRecognizerStateBegan)
    {

        [self.animator removeAllBehaviors];

        self.collision = nil;
        self.gravity   = nil;
        self.push      = nil;

        return;
    }



    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {

        NSLog(@"%@", NSStringFromCGVector(_vector));
        self.push.pushDirection = _vector;

        [self.push addItem:recognizer.view];
        [self.gravity addItem:recognizer.view];
        [self.collision addItem:recognizer.view];

        [self.animator addBehavior:self.collision];
        [self.animator addBehavior:self.push];
        [self.animator addBehavior:self.gravity];
        return;

    }

    if (recognizer.state == UIGestureRecognizerStateChanged) {

        CGPoint point = [recognizer translationInView:recognizer.view];

        CGFloat x = recognizer.view.center.x + point.x > (320 - 40)? 280:recognizer.view.center.x + point.x;
        x = recognizer.view.center.x + point.x < 40? 40:recognizer.view.center.x + point.x;

        CGFloat y = recognizer.view.center.y + point.y > 400? 400:recognizer.view.center.y + point.y;
        y = recognizer.view.center.y + point.y < 0? 0:recognizer.view.center.y + point.y;

        recognizer.view.center = CGPointMake(x, y);

        _vector = CGVectorMake(point.x * 0.3, point.y * 0.3);

        [recognizer setTranslation:CGPointZero inView:recognizer.view];
        return;
        
    }



}

/**
 *  推动力
 */
- (void)pushDemo
{
    UIView *ball = [self createBall];

    ball.center = self.view.center;

    [self.push addItem:ball];

    self.push.magnitude = 2;
    self.push.angle = M_PI_2;

    [self.collision addItem:ball];

    [self.animator addBehavior:self.collision];
    [self.animator addBehavior:self.push];


}

/**
 *  捕捉demo
 */
- (void)snapDemo
{

    UIView *ball1 = [self createBall];

    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:ball1 snapToPoint:CGPointMake(160, 260)];


    [self.animator addBehavior:snap];


}

/**
 *  重力demo
 */
- (void)gravityDemo
{
    NSMutableArray *boxs = [NSMutableArray array];

    for (int i = 0; i < 5; i++) {
        UIView *box = [[UIView alloc] initWithFrame:CGRectMake(arc4random_uniform(200), 0, 100, 100)];

        box.layer.cornerRadius = 50;
        box.clipsToBounds = YES;

        box.backgroundColor = [UIColor colorWithRed:arc4random_uniform(200)/255.0 green:arc4random_uniform(200)/255.0 blue:arc4random_uniform(200)/255.0 alpha:1];
        [self.view addSubview:box];

        [boxs addObject:box];
    }


    [boxs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx % 2) {
            [self.gravity addItem:obj];
            [self.collision addItem:obj];
        }
    }];


    // 3.将物理仿真行为添加到物理仿真器中
    [self.animator addBehavior:self.gravity];
    [self.animator addBehavior:self.collision];

}

/**
 *  粘附demo
 */
- (void)attachmentDemo
{
    UIView *ball = [self createBall];

    [self.gravity addItem:ball];

    [self.collision addItem:ball];

    [self.animator addBehavior:self.gravity];

    UIAttachmentBehavior *att = [[UIAttachmentBehavior alloc ] initWithItem:ball attachedToAnchor:CGPointMake(160, 140)];

    att.length = 0;
    att.frequency = 1;

    att.damping = 0.1;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        att.frequency = 0;
    });

    [self.animator addBehavior:att];
}

#pragma mark - Getter Setter

- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        _animator.delegate = self;
    }
    return _animator;
}

- (UIGravityBehavior *)gravity
{
    if (!_gravity) {
        _gravity = [[UIGravityBehavior alloc] init];
    }
    return _gravity;
}

- (UICollisionBehavior *)collision
{
    if (!_collision) {
        _collision = [[UICollisionBehavior alloc] init];
        _collision.translatesReferenceBoundsIntoBoundary = YES;
        _collision.collisionDelegate = self;
    }
    return _collision;
}

- (UIAttachmentBehavior *)attachment
{
    if (!_attachment) {
        _attachment = [[UIAttachmentBehavior alloc] init];
        _attachment.anchorPoint = self.centerCircle.center;
        
    }
    return _attachment;
}

- (UIView *)centerCircle
{
    if (!_centerCircle) {
        UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];

        circle.center = self.view.center;

        circle.backgroundColor    = [UIColor yellowColor];

        circle.layer.cornerRadius = 25;
        circle.clipsToBounds      = YES;

        [self.view addSubview:circle];
        _centerCircle = circle;
    }
    return _centerCircle;
}

- (UISnapBehavior *)snap
{
    if (!_snap) {
        _snap = [[UISnapBehavior alloc] init];
    }
    return _snap;
}

- (UIPushBehavior *)push
{
    if (!_push) {
        _push = [[UIPushBehavior alloc] initWithItems:nil mode:UIPushBehaviorModeInstantaneous];
    }
    return _push;
}

- (UIDynamicBehavior *)behavior
{
    if (!_behavior) {
        _behavior = [[UIDynamicBehavior alloc] init];
    }
    return _behavior;
}

@end










