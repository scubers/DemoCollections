//
//  DynamicController.m
//  DemoCollections
//
//  Created by 王俊仁 on 15/7/24.
//  Copyright (c) 2015年 王俊仁. All rights reserved.
//

#import "DynamicController.h"
#import "NewtonsCradleView.h"

@interface DynamicController() <UICollisionBehaviorDelegate, UIDynamicAnimatorDelegate>

@property (nonatomic, strong) UIDynamicAnimator *animator;

@property (nonatomic, strong) UIPushBehavior *pushBehavior;

@property (nonatomic, strong) UIGravityBehavior *gravity;

@property (nonatomic, strong) UICollisionBehavior *collision;

@property (nonatomic, strong) UIAttachmentBehavior *attachment;

@property (nonatomic, strong) UISnapBehavior *snap;

@property (nonatomic, strong) UIPushBehavior *push;

@property (nonatomic, assign) CGVector vector;


@property (nonatomic, weak) UIView *centerCircle;

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
    UIView *box = [[UIView alloc] initWithFrame:CGRectMake(arc4random_uniform(200), 0, 80, 80)];

    box.layer.cornerRadius = 40;
    box.clipsToBounds = YES;

    box.backgroundColor = [UIColor colorWithRed:arc4random_uniform(200)/255.0 green:arc4random_uniform(200)/255.0 blue:arc4random_uniform(200)/255.0 alpha:1];

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

#pragma mark - test Method

- (void)advanceDemo
{
    UIView *ball = [self createBall];

    ball.center = self.view.center;

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panBall:)];

    [ball addGestureRecognizer:pan];

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

- (void)pushDemo
{
    UIView *ball = [self createBall];

    ball.center = self.view.center;

    [self.push addItem:ball];



    NSLog(@"%d, %f, %f, %@", self.push.active, self.push.angle, self.push.magnitude, NSStringFromCGVector(self.push.pushDirection));

    self.push.magnitude = 2;
    self.push.angle = M_PI_2;

    [self.collision addItem:ball];

    [self.animator addBehavior:self.collision];
    [self.animator addBehavior:self.push];


}

- (void)snapDemo
{
    UIView *ball = [self createBall];

    [self.gravity addItem:ball];

    CGPoint point = CGPointMake(arc4random_uniform(320), arc4random_uniform(568));

    UISnapBehavior *behavior = [[UISnapBehavior alloc] initWithItem:ball snapToPoint:point];

    [self.animator addBehavior:behavior];
}

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
        [self.gravity addItem:obj];
        [self.collision addItem:obj];
    }];


    // 3.将物理仿真行为添加到物理仿真器中
    [self.animator addBehavior:self.gravity];
    [self.animator addBehavior:self.collision];

}

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

    NSLog(@"%f,%f,%f", att.length, att.damping, att.frequency);

    [self.animator addBehavior:att];
}

#pragma mark - Getter Setter

- (UIDynamicAnimator *)animator {
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

@end










