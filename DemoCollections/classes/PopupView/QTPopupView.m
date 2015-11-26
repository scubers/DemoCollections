//
//  QTPopupView.m
//  DemoCollections
//
//  Created by 王俊仁 on 15/11/3.
//  Copyright © 2015年 王俊仁. All rights reserved.
//

#import "QTPopupView.h"
#import "ReactiveCocoa.h"

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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.contentView.bounds;
    CGFloat height = rect.size.height - 10;
    self.imageView.frame = CGRectMake(10, 5, height, height);
    self.textLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + 10, 5, rect.size.width - CGRectGetMaxX(self.imageView.frame) - 10, height);
}

@end

#pragma mark - QTPopupView

#define BorderMargin 5

@interface QTPopupView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *background;

@property (nonatomic, strong) NSMutableArray<NSString *> *titles;
@property (nonatomic, strong) NSMutableArray<NSDictionary<NSString *, UIImage *> *> *selectionsInfo;

@property (nonatomic, assign) CGSize contentSize; ///< 指定的内容大小
@property (nonatomic, assign) CGPoint atPoint;  ///< 触发的点
@property (nonatomic, strong) UIView *hangView; ///< 显示pop的view




@property (nonatomic, copy) QTPopupViewCompleteBlock completeBlock;

@end

@implementation QTPopupView

#pragma mark - lifecycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupSubviews];
        
        // 初始化默认值
        _itemTextColor       = [UIColor whiteColor];
        _contentInsets       = UIEdgeInsetsMake(5, 0, 5, 0);
        _itemRowHieght       = 50;
        _itemFontSize        = 13;
        _arrowPosition       = 0.5;
        _arrowPointTo        = QTPopupViewArrowPointToTop;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        
        
    }
    return self;
}

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles
                        inView:(UIView *)view
                       atPoint:(CGPoint)point
                   contentSize:(CGSize)contentSize
                      complete:(QTPopupViewCompleteBlock)complete
{
    if (self = [super init])
    {
        _titles      = [titles mutableCopy];
        _atPoint     = point;
        _contentSize = contentSize;
        _hangView    = view;
    }
    return self;
}

- (instancetype)initWithTitleAndIcons:(NSArray<NSDictionary<NSString *, UIImage *> *> *)infos
                               inView:(UIView *)view
                              atPoint:(CGPoint)point
                          contentSize:(CGSize)contentSize
                             complete:(QTPopupViewCompleteBlock)complete
{
    self = [[QTPopupView alloc] initWithTitles:nil inView:view atPoint:point contentSize:contentSize complete:complete];
    if (self) {
        _selectionsInfo = [infos mutableCopy];
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

    CGContextRef context = UIGraphicsGetCurrentContext();
    [_background.backgroundColor setFill];
    
    // 根据方向画箭头
    switch (_arrowPointTo) {
        case QTPopupViewArrowPointToTop:
        {
            CGContextMoveToPoint(context, rect.size.width * (_arrowPosition?:0.5), 0);
            CGContextAddLineToPoint(context, rect.size.width * (_arrowPosition?:0.5) - 3, _background.origin.y);
            CGContextAddLineToPoint(context, rect.size.width * (_arrowPosition?:0.5) + 3, _background.origin.y);
            CGContextAddLineToPoint(context, rect.size.width * (_arrowPosition?:0.5), 0);
            break;
        }
        case QTPopupViewArrowPointToLeft:
        {
            CGContextMoveToPoint(context, 0, rect.size.height * (_arrowPosition?:0.5));
            CGContextAddLineToPoint(context, _background.origin.x, rect.size.height * (_arrowPosition?:0.5) - 3);
            CGContextAddLineToPoint(context, _background.origin.x,rect.size.height * (_arrowPosition?:0.5) + 3);
            CGContextAddLineToPoint(context, 0, rect.size.height * (_arrowPosition?:0.5));
            break;
        }
        case QTPopupViewArrowPointToBottom:
        {
            CGContextMoveToPoint(context, rect.size.width * (_arrowPosition?:0.5), rect.size.height);
            CGContextAddLineToPoint(context, rect.size.width * (_arrowPosition?:0.5) - 3, rect.size.height - _background.origin.y);
            CGContextAddLineToPoint(context, rect.size.width * (_arrowPosition?:0.5) + 3, rect.size.height - _background.origin.y);
            CGContextAddLineToPoint(context, rect.size.width * (_arrowPosition?:0.5), rect.size.height);
            break;
        }
        case QTPopupViewArrowPointToRight:
        {
            CGContextMoveToPoint(context, rect.size.width, rect.size.height * (_arrowPosition?:0.5));
            CGContextAddLineToPoint(context, rect.size.width - _background.origin.x, rect.size.height * (_arrowPosition?:0.5) - 3);
            CGContextAddLineToPoint(context, rect.size.width - _background.origin.x, rect.size.height * (_arrowPosition?:0.5) + 3);
            CGContextAddLineToPoint(context, rect.size.width, rect.size.height * (_arrowPosition?:0.5));
            break;
        }
        default:break;
    }

    CGContextFillPath(context);

}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self adjustSelfFrame];
    
    _background.frame = CGRectMake(BorderMargin, BorderMargin, self.bounds.size.width - 2*BorderMargin, self.bounds.size.height - 2*BorderMargin);
    
    _tableView.frame  = UIEdgeInsetsInsetRect(_background.bounds, self.contentInsets);

    _background.layer.cornerRadius = 3;
    _background.clipsToBounds      = YES;
}

- (void)adjustSelfFrame
{
    if (!_arrowPosition) _arrowPosition = 0.5;
    
    CGRect frame;
    
//    self.frame = CGRectMake(_atPoint.x - _contentSize.width/2, _atPoint.y, _contentSize.width, _contentSize.height);
    switch (_arrowPointTo) {
        case QTPopupViewArrowPointToTop:
        {
            frame = CGRectMake(_atPoint.x - ((_arrowPosition?:0.5) * _contentSize.width), _atPoint.y, _contentSize.width, _contentSize.height);
            break;
        }
        case QTPopupViewArrowPointToLeft:
        {
            frame = CGRectMake(_atPoint.x, _atPoint.y - ((_arrowPosition?:0.5) * _contentSize.height), _contentSize.width, _contentSize.height);
            break;
        }
        case QTPopupViewArrowPointToBottom:
        {
            frame = CGRectMake(_atPoint.x - ((_arrowPosition?:0.5) * _contentSize.width), _atPoint.y - _contentSize.height, _contentSize.width, _contentSize.height);
            break;
        }
        case QTPopupViewArrowPointToRight:
        {
            frame = CGRectMake(_atPoint.x - _contentSize.width, _atPoint.y - ((_arrowPosition?:0.5) * _contentSize.height), _contentSize.width, _contentSize.height);
            break;
        }
        default:break;
    }
    
    
    self.frame = frame;
    

}

#pragma mark - Touch事件
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect = [self.tableView convertRect:self.tableView.bounds toView:self];
    if (!CGRectContainsPoint(rect, point))
    {
        [self dismiss];
        return [[UIView alloc] init];
    }
    return [super hitTest:point withEvent:event];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_titles.count) {
        return _titles.count;
    }
    else if(_selectionsInfo.count)
    {
        return _selectionsInfo.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QTPopupViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QTPopupViewCell class]) forIndexPath:indexPath];

    if (_titles.count)
    {
        cell.textLabel.text = _titles[indexPath.row];
    }
    else if(_selectionsInfo.count)
    {
        NSDictionary *info = _selectionsInfo[indexPath.row];
        cell.textLabel.text = info.allKeys.firstObject;
        cell.imageView.image = info.allValues.firstObject;
    }
    
    if (_itemTextColor) {
        cell.textLabel.textColor = _itemTextColor;
    }
    
    if (_itemFontSize)
        cell.textLabel.font = [UIFont systemFontOfSize:_itemFontSize];
    
    cell.backgroundColor = func_random_color();

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _itemRowHieght ?: 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(_completeBlock)
    {
        _completeBlock(self, indexPath);
    }
    else if (_delegate && [_delegate respondsToSelector:@selector(popupView:didSelectItemAtIndex:)])
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

- (void)show
{
    [self.hangView addSubview:self];
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
    
    __weak typeof(self) ws = self;
    [[tableView rac_signalForSelector:@selector(selectRowAtIndexPath:animated:scrollPosition:)] subscribeNext:^(id x) {
        if (ws.completeBlock) {
            ws.completeBlock(ws, [x first]);
        }
        else
        {
            if (ws.delegate && [ws.delegate respondsToSelector:@selector(popupView:didSelectItemAtIndex:)]) {
                [ws.delegate popupView:ws didSelectItemAtIndex:[x first]];
            }
        }
    }];
    
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












