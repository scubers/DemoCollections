//
//  NSDate+Common.m
//
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

/**
 *@Description:根据年份、月份、日期、小时数、分钟数、秒数返回NSDate
 *@Params:
 *  year:年份
 *  month:月份
 *  day:日期
 *  hour:小时数
 *  minute:分钟数
 *  second:秒数
 *@Return:
 */
+ (NSDate *)dateWithYear:(NSUInteger)year
                   Month:(NSUInteger)month
                     Day:(NSUInteger)day
                    Hour:(NSUInteger)hour
                  Minute:(NSUInteger)minute
                  Second:(NSUInteger)second
{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
    dateComponents.year = year;
    dateComponents.month = month;
    dateComponents.day = day;
    dateComponents.hour = hour;
    dateComponents.minute = minute;
    dateComponents.second = second;

    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}


/**
 *@Description:实现dateFormatter单例方法
 *@Params:nil
 *Return:相应格式的NSDataFormatter对象
 */
+ (NSDateFormatter *)defaultDateFormatterWithFormatYYYYMMddHHmmss
{
    static NSDateFormatter *staticDateFormatterWithFormatYYYYMMddHHmmss;
    if (!staticDateFormatterWithFormatYYYYMMddHHmmss) {
        staticDateFormatterWithFormatYYYYMMddHHmmss = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatYYYYMMddHHmmss setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    }

    return staticDateFormatterWithFormatYYYYMMddHHmmss;
}

+ (NSDateFormatter *)defaultDateFormatterWithFormatYYYYMMddHHmm
{
    static NSDateFormatter *staticDateFormatterWithFormatYYYYMMddHHmm;
    if (!staticDateFormatterWithFormatYYYYMMddHHmm) {
        staticDateFormatterWithFormatYYYYMMddHHmm = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatYYYYMMddHHmm setDateFormat:@"YYYY-MM-dd HH:mm"];
    }
    
    return staticDateFormatterWithFormatYYYYMMddHHmm;
}

+ (NSDateFormatter *)defaultDateFormatterWithFormatYYYYMMdd
{
    static NSDateFormatter *staticDateFormatterWithFormatYYYYMMddHHmmss;
    if (!staticDateFormatterWithFormatYYYYMMddHHmmss) {
        staticDateFormatterWithFormatYYYYMMddHHmmss = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatYYYYMMddHHmmss setDateFormat:@"YYYY-MM-dd"];
    }

    return staticDateFormatterWithFormatYYYYMMddHHmmss;
}


+ (NSDateFormatter *)defaultDateFormatterWithFormatMMddHHmm
{
    static NSDateFormatter *staticDateFormatterWithFormatMMddHHmm;
    if (!staticDateFormatterWithFormatMMddHHmm) {
        staticDateFormatterWithFormatMMddHHmm = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatMMddHHmm setDateFormat:@"MM-dd HH:mm"];
    }

    return staticDateFormatterWithFormatMMddHHmm;
}

+ (NSDateFormatter *)defaultDateFormatterWithFormatYYYYMMddHHmmInChinese
{
    static NSDateFormatter *staticDateFormatterWithFormatYYYYMMddHHmmssInChines;
    if (!staticDateFormatterWithFormatYYYYMMddHHmmssInChines) {
        staticDateFormatterWithFormatYYYYMMddHHmmssInChines = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatYYYYMMddHHmmssInChines setDateFormat:@"YYYY年MM月dd日 HH:mm"];
    }

    return staticDateFormatterWithFormatYYYYMMddHHmmssInChines;
}

+ (NSDateFormatter *)defaultDateFormatterWithFormatMMddHHmmInChinese
{
    static NSDateFormatter *staticDateFormatterWithFormatMMddHHmmInChinese;
    if (!staticDateFormatterWithFormatMMddHHmmInChinese) {
        staticDateFormatterWithFormatMMddHHmmInChinese = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatMMddHHmmInChinese setDateFormat:@"MM月dd日 HH:mm"];
    }

    return staticDateFormatterWithFormatMMddHHmmInChinese;
}


/**
 *@Description:获取当天的包括“年”，“月”，“日”，“周”，“时”，“分”，“秒”的NSDateComponents
 *@Params:nil
 *@Return:当天的包括“年”，“月”，“日”，“周”，“时”，“分”，“秒”的NSDateComponents
 */
- (NSDateComponents *)componentsOfDay
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
}


//  --------------------------NSDate---------------------------
/**
 *@Description:获得NSDate对应的年份
 *@Params:nil
 *@Return:NSDate对应的年份
 */
- (NSUInteger)year
{
    return [self componentsOfDay].year;
}

/**
 *@Description:获得NSDate对应的月份
 *@Params:nil
 *@Return:NSDate对应的月份
 */
- (NSUInteger)month
{
    return [self componentsOfDay].month;
}


/**
 *@Description:获得NSDate对应的日期
 *@Params:nil
 *@Return:NSDate对应的日期
 */
- (NSUInteger)day
{
    return [self componentsOfDay].day;
}


/****
 *@Description:获得NSDate对应的小时数
 *@Params:nil
 *@Return:NSDate对应的小时数
 ****/
- (NSUInteger)hour
{
    return [self componentsOfDay].hour;
}


/**
 *@Description:获得NSDate对应的分钟数
 *@Params:nil
 *@Return:NSDate对应的分钟数
 */
- (NSUInteger)minute
{
    return [self componentsOfDay].minute;
}


/**
 *@Description:获得NSDate对应的秒数
 *@Params:nil
 *@Return:NSDate对应的秒数
 */
- (NSUInteger)second
{
    return [self componentsOfDay].second;
}

/**
 *@Description:获得NSDate对应的星期
 *@Params:nil
 *@Return:NSDate对应的星期
 */
- (NSUInteger)weekday
{
    return [self componentsOfDay].weekday;
}

/**
 *@Description:获得NSDate对应的中文星期
 *@Params:nil
 *@Return:NSDate对应的星期
 */
- (NSString *)chineseWeekday
{
    switch (self.weekday) {
        case 1:
            return @"周日";
            break;
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        case 7:
            return @"周六";
            break;
        default:
            return nil;
            break;
    }
}

/**
 *@Description:获取当天是当年的第几周
 *@Params:nil
 *@Return:当天是当年的第几周
 */
- (NSUInteger)weekOfDayInYear
{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitWeekOfYear inUnit:NSCalendarUnitYear forDate:self];
}


/**
 *@Description:获得一般当天的工作开始时间
 *@Params:nil
 *@Return:一般当天的工作开始时间
 */
- (NSDate *)workBeginTime
{
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:flags fromDate:self];
    [components setHour:9];
    [components setMinute:30];
    [components setSecond:0];

    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

/**
 *@Description:获得一般当天的工作结束时间
 *@Params:nil
 *@Return:一般当天的工作结束时间
 */
- (NSDate *)workEndTime
{
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:flags fromDate:self];
    [components setHour:18];
    [components setMinute:0];
    [components setSecond:0];

    return [[NSCalendar currentCalendar] dateFromComponents:components];
}


/**
 *@Description:获取一小时后的时间
 *@Params:nil
 *@Return:一小时后的时间
 */
- (NSDate *)oneHourLater
{
    return [NSDate dateWithTimeInterval:3600 sinceDate:self];
}


/**
 *@Description:获得某一天的这个时刻
 *@Params:nil
 *@Return:某一天的这个时刻
 */
- (NSDate *)sameTimeOfDate
{
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:flags fromDate:self];
    [components setHour:[[NSDate date] hour]];
    [components setMinute:[[NSDate date] minute]];
    [components setSecond:[[NSDate date] second]];

    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

/**
 *@Description:判断与某一天是否为同一天
 *@Params:
 *  otherDate:某一天
 *@Return:YES-同一天；NO-不同一天
 */
- (BOOL)sameDayWithDate:(NSDate *)otherDate
{
    if (self.year == otherDate.year && self.month == otherDate.month && self.day == otherDate.day) {
        return YES;
    } else {
        return NO;
    }
}


/**
 *@Description:判断与某一天是否为同一周
 *@Params:
 *  otherDate:某一天
 *@Return:YES-同一周；NO-不同一周
 */
- (BOOL)sameWeekWithDate:(NSDate *)otherDate
{
    if (self.year == otherDate.year  && self.month == otherDate.month && self.weekOfDayInYear == otherDate.weekOfDayInYear) {
        return YES;
    } else {
        return NO;
    }
}

/**
 *@Description:判断与某一天是否为同一月
 *@Params:
 *  otherDate:某一天
 *@Return:YES-同一月；NO-不同一月
 */
- (BOOL)sameMonthWithDate:(NSDate *)otherDate
{
    if (self.year == otherDate.year && self.month == otherDate.month) {
        return YES;
    } else {
        return NO;
    }
}


/**
 *@Description:获取时间的字符串格式
 *@Params:nil
 *@Return:时间的字符串格式
 */
- (NSString *)stringOfDateWithFormatYYYYMMddHHmmss
{
    return [[NSDate defaultDateFormatterWithFormatYYYYMMddHHmmss] stringFromDate:self];
}

- (NSString *)stringOfDateWithFormatYYYYMMddHHmm
{
    return [[NSDate defaultDateFormatterWithFormatYYYYMMddHHmm] stringFromDate:self];
}

- (NSString *)stringOfDateWithFormatYYYYMMdd
{
    return [[NSDate defaultDateFormatterWithFormatYYYYMMdd] stringFromDate:self];
}

- (NSString *)stringOfDateWithFormatMMddHHmm
{
    return [[NSDate defaultDateFormatterWithFormatMMddHHmm] stringFromDate:self];
}

- (NSString *)stringOfDateWithFormatYYYYMMddHHmmInChinese
{
    return [[NSDate defaultDateFormatterWithFormatYYYYMMddHHmmInChinese] stringFromDate:self];
}

- (NSString *)stringOfDateWithFormatMMddHHmmInChinese
{
    return [[NSDate defaultDateFormatterWithFormatMMddHHmmInChinese] stringFromDate:self];
}

- (NSDate *)tomorrow
{
    return [NSDate dateWithTimeInterval:60 * 60 * 24 sinceDate:self];
}

- (NSDate *)yesterday
{
    return [NSDate dateWithTimeInterval:-60 * 60 * 24 sinceDate:self];
}

/**
 *  是否闰年
 */
- (BOOL)isLeapYear
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    df.dateFormat = @"yyyy";
    
    int year = [[df stringFromDate:self] intValue];
    
    if (year % 400 == 0)
    {
        return YES;
    }
    else
    {
        if (year % 4 == 0 && year % 100 != 0)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format
{
    static NSDateFormatter *formatter;
    if (!formatter)
    {
        formatter = [[NSDateFormatter alloc] init];
    }
    
    formatter.dateFormat = format;
    
    return [formatter dateFromString:string];
}


@end










