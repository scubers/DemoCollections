//
//  QTCalendarViewController.m
//  DemoCollections
//
//  Created by mima on 15/11/13.
//  Copyright © 2015年 王俊仁. All rights reserved.
//

#import "NSDate+Extension.h"
#import "QTCalendarViewController.h"
#import "Masonry.h"

#define func_random_color() [UIColor colorWithRed:(float)(arc4random()%10000)/10000.0 green:(float)(arc4random()%10000)/10000.0 blue:(float)(arc4random()%10000)/10000.0 alpha:(float)(arc4random()%10000)/10000.0]

#pragma mark - QTDateButton ------------------------------------------------------------------------

static NSString *QTDateButtonDidClickNotification        = @"QTDateButtonDidClickNotification";
static NSString *QTDateButtonDidClickNotificationDateKey = @"QTDateButtonDidClickNotificationDateKey";

@interface QTDateButton : UIButton

@property (nonatomic, strong) NSDate *date;

- (void)setupNotificationCenter;

@end

@implementation QTDateButton

static NSDate *globalDate = nil;
#pragma mark - 生命周期
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupSelf];
        
    }
    return self;
}

- (void)setupSelf
{
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
}

- (void)setupNotificationCenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handler:) name:QTDateButtonDidClickNotification object:nil];
}

- (void)handler:(NSNotification *)noti
{
    NSDate *date = noti.userInfo[QTDateButtonDidClickNotificationDateKey];
    
    self.selected = [date sameDayWithDate:self.date];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 事件响应
- (void)click:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:QTDateButtonDidClickNotification object:nil userInfo:@{QTDateButtonDidClickNotificationDateKey : self.date}];
    globalDate = self.date;
}

#pragma mark - Getter Setter
- (void)setDate:(NSDate *)date
{
    _date = date;
    
    self.userInteractionEnabled = !(!date);
    
    self.selected = (date == globalDate);
    
    if (!date)
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    if (date)
        [self setTitle:[NSString stringWithFormat:@"%zd", date.day] forState:UIControlStateNormal];
    else
        [self setTitle:nil forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    self.backgroundColor = self.isSelected ? [UIColor lightGrayColor] : [UIColor whiteColor];
}

@end

#pragma mark - QTDateLinesView ---------------------------------------------------------------------

typedef enum
{
    QTDateLinesViewTypeTitle = 1,
    QTDateLinesViewTypeDate
}QTDateLinesViewType;

@interface QTDateLinesView : UIView

@property (nonatomic, assign) QTDateLinesViewType type;

@property (nonatomic, strong) NSMutableArray<UIButton *> *dateButtons;

@property (nonatomic, strong) NSMutableArray<NSDate *> *dates;

- (instancetype)initWithType:(QTDateLinesViewType)type;


@end

@implementation QTDateLinesView

#pragma mark - 生命周期
- (instancetype)initWithType:(QTDateLinesViewType)type
{
    if (self = [super init])
    {
        self.type = type;
        [self setupSubviews];
        self.clipsToBounds = YES;

    }
    return self;
}

- (void)setupSubviews
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i < 7; i++)
    {
        QTDateButton *button = [QTDateButton buttonWithType:UIButtonTypeCustom];
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        if (_type == QTDateLinesViewTypeTitle)
        {
            NSString *string;
            switch (i) {
                case 0:
                    string = @"日";
                    break;
                case 1:
                    string = @"一";
                    break;
                case 2:
                    string = @"二";
                    break;
                case 3:
                    string = @"三";
                    break;
                case 4:
                    string = @"四";
                    break;
                case 5:
                    string = @"五";
                    break;
                case 6:
                    string = @"六";
                    break;
                default:
                    break;
            }
            [button setTitle:string forState:UIControlStateNormal];
        }
        else
        {
            __weak typeof(button) bt = button;
            [button addTarget:bt action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            [button setupNotificationCenter];
        }
        
        [self addSubview:button];
        [self.dateButtons addObject:button];
    }
//    [self autolayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self caculateFrames];
}

- (void)caculateFrames
{
    [self.dateButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat width = self.bounds.size.width / 7;
        CGFloat height = self.bounds.size.height;
        CGFloat x = x = idx * width;
        CGFloat y = 0;
        
        obj.frame = CGRectMake(x, y, width, height);
    }];
}

- (void)autolayout
{
    __block UIButton *lastButton;
    [self.dateButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!lastButton)
        {
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.mas_equalTo(obj.superview);
            }];
        }
        else
        {
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(obj.superview);
                make.left.mas_equalTo(lastButton.mas_right);
                if(idx == (self.dateButtons.count - 1))
                {
                    make.right.mas_equalTo(obj.superview);
                }
                make.width.mas_equalTo(lastButton);
            }];
        }
        lastButton = obj;
    }];
}

#pragma mark - Getter Setter
- (NSMutableArray<UIButton *> *)dateButtons
{
    if (!_dateButtons) {
        _dateButtons = [NSMutableArray array];
    }
    return _dateButtons;
}

- (void)setDates:(NSMutableArray<NSDate *> *)dates
{
    _dates = dates;
    
    __block int day = (int)dates.firstObject.weekday;
    __block int i = 0;
    [self.dateButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        QTDateButton *button = (QTDateButton *)obj;
        if ((idx + 1) == day && i < self.dates.count)
        {
            button.date = dates[i];
            day++;
            i++;
        }
        else
        {
            button.date = nil;
        }
    }];

}

@end


#pragma mark - QTCalendarViewCell ------------------------------------------------------------------

#define QTCalendarViewCellMargin 5
@interface QTCalendarViewCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray<__kindof NSDate *> *dates; ///< 每个月所有的日期;



@property (nonatomic, strong) UIView       *shadowView;
@property (nonatomic, strong) UIView       *background;
@property (nonatomic, strong) UILabel      *titleLabel;
@property (nonatomic, strong) UIView       *weekDayView;
@property (nonatomic, strong) UIView       *dateView;


@property (nonatomic, strong) CAShapeLayer *coverLayer;

@property (nonatomic, strong) NSMutableArray<UIView *> *dateLines;

+ (CGFloat)cellHeightWithDates:(NSMutableArray<NSDate *> *)dates;

@end

@implementation QTCalendarViewCell

#pragma mark - 生命周期
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setupSubviews];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setupSubviews
{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    {
        _shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        _shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
        _shadowView.layer.shadowOffset = CGSizeMake(4, 4);
        _shadowView.layer.shadowOpacity = 1;
        _shadowView.layer.shadowRadius = 4;
        [self.contentView addSubview:_shadowView];
    }
    
    {
        _background = [[UIView alloc] init];
        _background.layer.cornerRadius = 3;
        _background.clipsToBounds      = YES;
        _background.layer.borderColor  = [UIColor lightGrayColor].CGColor;
        _background.layer.borderWidth  = 0.5;
        _background.backgroundColor    = [UIColor whiteColor];
        [self.contentView addSubview:_background];
    }
    
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor       = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor colorWithRed:248/255.0 green:174/255.0 blue:12/255.0 alpha:1];
        _titleLabel.textAlignment   = NSTextAlignmentCenter;
        [_background addSubview:_titleLabel];
    }
    
    {
        _weekDayView = [[QTDateLinesView alloc] initWithType:QTDateLinesViewTypeTitle];
        _weekDayView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
        [_background addSubview:_weekDayView];
    }
    
    {
        _dateView = [[UIView alloc] init];
        [_background addSubview:_dateView];
    }
    
    {
        _dateLines = [NSMutableArray array];
        for (int i = 0; i < 6; i++)
        {
            QTDateLinesView *line = [[QTDateLinesView alloc] initWithType:QTDateLinesViewTypeDate];
            [_background addSubview:line];
            [_dateLines addObject:line];
        }
    }
    
    [self drawCover];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self caculateFrames];
}

- (void)autolayout
{
    [_background mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_background.superview).insets(UIEdgeInsetsMake(QTCalendarViewCellMargin, QTCalendarViewCellMargin, QTCalendarViewCellMargin, QTCalendarViewCellMargin));
    }];
    
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(_titleLabel.superview);
        
        //设定基准高度,压力原则, 计算出父控件的bounds;
        make.height.mas_equalTo(30);
    }];
    
    [_weekDayView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_weekDayView.superview);
        make.top.mas_equalTo(_titleLabel.mas_bottom);
        
        // 约束高度
        make.height.mas_equalTo(_titleLabel);
    }];

    __block UIView *lastLine;
    [self.dateLines enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!lastLine)
        {
            [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(obj.superview);
                make.top.mas_equalTo(_weekDayView.mas_bottom);
                // 约束高度
                make.height.mas_equalTo(_weekDayView);
            }];
        }
        else
        {
            [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(obj.superview);
                make.top.mas_equalTo(lastLine.mas_bottom);
                
                if (idx == (self.dateLines.count - 1))
                {
                    make.bottom.mas_equalTo(obj.superview);
                }
                
                // 约束高度
                make.height.mas_equalTo(lastLine);
            }];
        }
        
        lastLine = obj;
    }];
}

#define BaseLineHeight 30
- (void)caculateFrames
{
    __block CGFloat x = 0;
    __block CGFloat y = 0;
    __block CGFloat width = 0;
    __block CGFloat height = 0;
    
    __block CGRect rect = self.bounds;
    
    x      = QTCalendarViewCellMargin;
    y      = QTCalendarViewCellMargin;
    width  = rect.size.width - (2 * QTCalendarViewCellMargin);
    height = rect.size.height - (2 * QTCalendarViewCellMargin);
    _background.frame = CGRectMake(x, y, width, height);
    _shadowView.frame = CGRectInset(_background.frame, 3, 3);
    
    x      = 0;
    y      = 0;
    width  = _background.bounds.size.width;
    height = BaseLineHeight;
    _titleLabel.frame = CGRectMake(x, y, width, height);
    
    x      = _titleLabel.origin.x;
    y      = _titleLabel.frame.origin.y + _titleLabel.frame.size.height;
    width  = _titleLabel.frame.size.width;
    height = _titleLabel.frame.size.height;
    _weekDayView.frame = CGRectMake(x, y, width, height);
    
    __block UIView *lastView;
    int lineNum = [QTCalendarViewCell lineNumberWithDates:self.dates];
    [self.dateLines enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!lastView)
        {
            x      = _weekDayView.origin.x;
            y      = _weekDayView.frame.origin.y + _weekDayView.frame.size.height;
            width  = _weekDayView.frame.size.width;
            height = _weekDayView.frame.size.height;
            obj.frame = CGRectMake(x, y, width, height);
        }
        else
        {
            x      = lastView.origin.x;
            y      = lastView.frame.origin.y + lastView.frame.size.height;
            width  = lastView.frame.size.width;
            height = lastView.frame.size.height;

            if (idx > lineNum)
            {
                height = 0;
            }
            obj.frame = CGRectMake(x, y, width, height);
        }
        lastView = obj;
    }];
    
}

- (void)drawCover
{
    [_coverLayer removeFromSuperlayer];
    
    _coverLayer = [CAShapeLayer layer];
    [_background.layer addSublayer:_coverLayer];
    
    _coverLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 2 * QTCalendarViewCellMargin, 8 * BaseLineHeight);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    
    
    [self.dateLines enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 横线
        CGFloat x = _coverLayer.frame.size.width;
        CGFloat y = 2 * BaseLineHeight + (BaseLineHeight * (idx + 1));
        [path moveToPoint:CGPointMake(0, y)];
        [path addLineToPoint:CGPointMake(x, y)];
        
        // 竖线
        x = (_coverLayer.frame.size.width / (obj.subviews.count)) * (idx + 1);
        y = _coverLayer.frame.size.height;
        [path moveToPoint:CGPointMake(x, 2 * BaseLineHeight)];
        [path addLineToPoint:CGPointMake(x, y)];
        
    }];
    
    [_coverLayer setLineDashPattern:@[@(3), @(3)]];
    
    _coverLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    _coverLayer.lineWidth   = 0.2;
    _coverLayer.strokeStart = 0;
    _coverLayer.strokeEnd   = 1;
    
    _coverLayer.path        = path.CGPath;
    
}

#pragma mark - 公共方法
+ (CGFloat)cellHeightWithDates:(NSMutableArray<NSDate *> *)dates
{
    int lineNum = [QTCalendarViewCell lineNumberWithDates:dates];
    return (2 * QTCalendarViewCellMargin) + ((3 + lineNum) * BaseLineHeight);
}

#pragma mark - 私有方法
+ (int)lineNumberWithDates:(NSMutableArray<NSDate *> *)dates
{
    int base = (int)(dates.count - (7 - dates.firstObject.weekday + 1));
    if (base <= 0) return 0;
    
//    int lineNum = (int)((dates.count - (7 - dates.firstObject.weekday + 1)) % 7 ? ((dates.count - (7 - dates.firstObject.weekday + 1)) / 7+1):(dates.count - (7 - dates.firstObject.weekday + 1)) / 7);
    int lineNum = (int)ceil(base / 7.0);
    return lineNum;
}


#pragma mark - Getter Setter
- (void)setDates:(NSMutableArray<__kindof NSDate *> *)dates
{
    _dates = dates;
    
    _titleLabel.text = [NSString stringWithFormat:@"%zd年%2zd月", dates.firstObject.year, dates.firstObject.month];
    
    __block int count = 0;
    int lineNum = [QTCalendarViewCell lineNumberWithDates:dates];
    [self.dateLines enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        QTDateLinesView *view = (QTDateLinesView *)obj;
        if (idx > lineNum)
        {
            *stop = YES;
            return ;
        }
        
        if (count < self.dates.count && (count + (7 - self.dates[count].weekday + 1)) < self.dates.count) {
            view.dates = [[self.dates subarrayWithRange:NSMakeRange(count, (7 - self.dates[count].weekday + 1))] mutableCopy];
            count = count + (int)(7 - self.dates[count].weekday + 1);
        }
        else
        {
            view.dates = [[self.dates subarrayWithRange:NSMakeRange(count, self.dates.count - count)] mutableCopy];
        }
                
    }];
    
    [self caculateFrames];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}

@end


#pragma mark - QTCalendarViewController ------------------------------------------------------------

@interface QTCalendarViewController()

@property (nonatomic, strong) NSMutableArray<__kindof NSMutableArray<NSDate *> *> *monthDates;

@property (nonatomic, strong) NSDate *selectedDate;

@property (nonatomic, copy) QTCalendarViewControllerCompleteBlock completeBlock;

@end

@implementation QTCalendarViewController

- (instancetype)initWithComplete:(QTCalendarViewControllerCompleteBlock)complete
{
    return [[QTCalendarViewController alloc] initWithDate:nil complete:complete];
}

- (instancetype)initWithDate:(NSDate *)date complete:(QTCalendarViewControllerCompleteBlock)complete
{
    if (self = [super init])
    {
        _completeBlock = complete;
        _selectedDate = date;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshDateSource];
    [self setupTableView];
    [self setupNotification];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:QTDateButtonDidClickNotification object:nil userInfo:@{QTDateButtonDidClickNotificationDateKey : self.selectedDate}];
}


- (void)setupTableView
{
    [self.tableView registerClass:[QTCalendarViewCell class] forCellReuseIdentifier:NSStringFromClass([QTCalendarViewCell class])];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setupNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectDate:) name:QTDateButtonDidClickNotification object:nil];
}


- (void)didSelectDate:(NSNotification *)noti
{
    self.selectedDate = noti.userInfo[QTDateButtonDidClickNotificationDateKey];
    if (_completeBlock)
    {
        _completeBlock(self, self.selectedDate);
    }
    else if(_delegate && [_delegate respondsToSelector:@selector(calendarViewController:didSelectedDate:)])
    {
        [_delegate calendarViewController:self didSelectedDate:self.selectedDate];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)refreshDateSource
{
    NSDate *date;
    if (!self.monthDates.count)
    {
        date = [NSDate date];
        [self.monthDates addObject:[self currentMonthDatesWithStartDate:date]];
        [self refreshDateSource];
    }
    else
    {
        for (int i = 0; i < 10; i++)
        {
            NSDate *theEndDateOfLastMonth = self.monthDates.lastObject.lastObject;
            date = theEndDateOfLastMonth.tomorrow;
            [self.monthDates addObject:[self currentMonthDatesWithStartDate:date]];
        }
    }
}

- (NSMutableArray *)currentMonthDatesWithStartDate:(NSDate *)startDate
{
    NSMutableArray<NSDate *> *array = [NSMutableArray array];
    
    [array addObject:startDate];
    
    while (array.lastObject.month == array.lastObject.tomorrow.month)
    {
        [array addObject:array.lastObject.tomorrow];
    }
    
    return array;
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.monthDates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QTCalendarViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QTCalendarViewCell class]) forIndexPath:indexPath];
    
    cell.dates = self.monthDates[indexPath.row];
    
    if (indexPath.row == (self.monthDates.count - 1))
    {
        [self refreshDateSource];
        [self.tableView reloadData];
    }
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < -120) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat abc = [QTCalendarViewCell cellHeightWithDates:self.monthDates[indexPath.row]];
    NSLog(@"%f", abc);
    return [QTCalendarViewCell cellHeightWithDates:self.monthDates[indexPath.row]];
}

#pragma mark - Getter Setter
- (NSMutableArray<NSMutableArray<NSDate *> *> *)monthDates
{
    if (!_monthDates) {
        _monthDates = [NSMutableArray array];
    }
    return _monthDates;
}


@end







