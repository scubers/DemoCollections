//
//  QTPopupView.m
//  DemoCollections
//
//  Created by 王俊仁 on 15/11/3.
//  Copyright © 2015年 王俊仁. All rights reserved.
//

#import "QTPopupView.h"

#pragma mark - QTPopupViewCell
@interface QTPopupViewCell : UITableViewCell

@end

@implementation QTPopupViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end

#pragma mark - QTPopupView

#define BorderMargin 5

@interface QTPopupView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *background;

@property (nonatomic, strong) NSMutableArray *titles;

@end

@implementation QTPopupView

#pragma mark - lifecycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupSubviews];
        self.backgroundColor = [UIColor blackColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (instancetype)initWithTitles:(NSArray *)titles inView:(UIView *)view atPoint:(CGPoint)point contentSize:(CGSize)contentSize
{
    if (self = [super init])
    {
        _titles = [titles mutableCopy];

        self.frame = CGRectMake(point.x - contentSize.width/2, point.y, contentSize.width, contentSize.height);

        [view addSubview:self];

    }
    return self;
}

- (void)setupSubviews
{
    _background = [[UIView alloc] init];

    _tableView = [[UITableView alloc] init];

    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource      = self;
    _tableView.delegate        = self;
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[QTPopupViewCell class] forCellReuseIdentifier:NSStringFromClass([QTPopupViewCell class])];

    [self addSubview:_background];
    [_background addSubview:_tableView];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    NSLog(@"%@", NSStringFromCGRect(rect));

    CGContextRef context = UIGraphicsGetCurrentContext();

    [_background.backgroundColor setFill];

    CGContextMoveToPoint(context, rect.size.width * (_arrowPosition?:0.5), 0);

    CGContextAddLineToPoint(context, rect.size.width * (_arrowPosition?:0.5) - 3, BorderMargin);
    CGContextAddLineToPoint(context, rect.size.width * (_arrowPosition?:0.5) + 3, BorderMargin);
    CGContextAddLineToPoint(context, rect.size.width * (_arrowPosition?:0.5), 0);

    CGContextFillPath(context);

}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (_arrowPosition)
    {
        CGFloat x = (0.5 - _arrowPosition) * self.bounds.size.width;
        self.frame = CGRectMake(self.frame.origin.x + x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    }

    _background.frame = CGRectMake(BorderMargin, BorderMargin, self.bounds.size.width - 2*BorderMargin, self.bounds.size.height - 2*BorderMargin);
    _tableView.frame  = _background.bounds;

    _background.layer.cornerRadius = 3;
    _background.clipsToBounds      = YES;
}

#pragma mark - Touch事件
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!CGRectContainsPoint(self.bounds, point))
    {
        [self dismiss];
        return [[UIView alloc] init];
    }
    return [super hitTest:point withEvent:event];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QTPopupViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QTPopupViewCell class]) forIndexPath:indexPath];

    cell.textLabel.text = _titles[indexPath.row];
    if (_itemFontSize) cell.textLabel.font = [UIFont systemFontOfSize:_itemFontSize];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _itemRowHieght ?: 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(popupView:didSelectItemAtIndex:)])
    {
        [_delegate popupView:self didSelectItemAtIndex:indexPath];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 公共方法
- (void)dismiss
{
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.1;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
        });
    }];
}

#pragma mark - Getter Setter

- (void)setItemFontSize:(CGFloat)itemFontSize
{
    _itemFontSize = itemFontSize;
    [_tableView reloadData];
}
- (void)setItemRowHieght:(CGFloat)itemRowHieght
{
    _itemRowHieght = itemRowHieght;
    [_tableView reloadData];
}

- (void)setTableView:(UITableView *)tableView
{
    [_tableView removeFromSuperview];
    _tableView = tableView;
    [_background addSubview:_tableView];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:[UIColor clearColor]];
    _background.backgroundColor = backgroundColor;
    [self setNeedsDisplay];
}

- (void)setArrowPosition:(CGFloat)arrowPosition
{
    if (arrowPosition < 0 || arrowPosition > 1)  return;

    _arrowPosition = arrowPosition;
    [self setNeedsDisplay];
}

@end












