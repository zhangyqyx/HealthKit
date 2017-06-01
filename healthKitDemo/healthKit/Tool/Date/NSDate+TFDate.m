//
//  NSDate+TFDate.m
//  封装
//
//  Created by 张永强 on 17/4/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "NSDate+TFDate.h"

@implementation NSDate (TFDate)

+ (NSDateFormatter *)TF_sharedDateFormatter {
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"locale"];
    });
    return dateFormatter;
}

+ (NSCalendar *)TF_sharedCalendar {
    static NSCalendar *calendar;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [NSCalendar currentCalendar];
    });
    return calendar;
}

#pragma mark -- 获取日、月、年、小时、分钟、秒
//天
- (NSUInteger)TF_day {
    return [NSDate TF_day:self];
}
+(NSUInteger)TF_day:(NSDate *)date {
    NSCalendar *calendar = [NSDate TF_sharedCalendar];
   
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitDay) fromDate:date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSDayCalendarUnit) fromDate:date];
#endif
    return [dayComponents day];
}

//月
- (NSUInteger)TF_month {
    return [NSDate TF_month:self];
}
+ (NSUInteger)TF_month:(NSDate *)date {
    NSCalendar *calendar = [NSDate TF_sharedCalendar];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitMonth) fromDate:date];
#else
    NSDateComponents *dayComponents =[calendar components:(NSMonthCalendarUnit) fromDate:date];
#endif
    return [dayComponents month];
}

//年
- (NSUInteger)TF_year {
    return [NSDate TF_year:self];
}
+ (NSUInteger)TF_year:(NSDate *)date {
    NSCalendar *calendar = [NSDate TF_sharedCalendar];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitYear) fromDate:date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSYearCalendarUnit) fromDate:date];;
#endif
    return [dayComponents year];
}

//时
- (NSUInteger)TF_hour {
    return [NSDate TF_hour:self];
}
+ (NSUInteger)TF_hour:(NSDate *)date {
    NSCalendar *calendar = [NSDate TF_sharedCalendar];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitHour) fromDate:date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSHourCalendarUnit) fromDate:date];;
#endif
    return [dayComponents hour];
}
//分
- (NSUInteger)TF_minute {
    return [NSDate TF_minute:self];
}
+ (NSUInteger)TF_minute:(NSDate *)date {
    NSCalendar *calendar = [NSDate TF_sharedCalendar];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitMinute) fromDate:date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSMinuteCalendarUnit) fromDate:date];;
#endif
    return [dayComponents minute];
}
//秒
- (NSUInteger)TF_second {
    return [NSDate TF_second:self];
}
+ (NSUInteger)TF_second:(NSDate *)date {
    NSCalendar *calendar = [NSDate TF_sharedCalendar];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitSecond) fromDate:date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSSecondCalendarUnit) fromDate:date];;
#endif
    return [dayComponents second];
}
#pragma mark -- 判断闰月年
- (BOOL)TF_isLeapYear {
    return [NSDate TF_isLeapYear:self];
}
+ (BOOL)TF_isLeapYear:(NSDate *)date {
    NSInteger year = [date TF_year];
    if ( (year % 4 == 0 && year % 100 != 0)||(year % 400 == 0)) {
        return YES;
    }
    return NO;
}
#pragma mark -- 一年中有多少天，距离当前日期几天前

- (NSUInteger)TF_daysAgo {
    return [NSDate TF_daysAgo:self];
}
+ (NSUInteger)TF_daysAgo:(NSDate *)date {
    NSCalendar *calendar = [NSDate TF_sharedCalendar];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *components = [calendar components:(NSCalendarUnitDay)
                                               fromDate:date
                                                 toDate:[NSDate date]
                                                options:0];
#else
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit)
                                               fromDate:date
                                                 toDate:[NSDate date]
                                                options:0];
#endif
    
    return [components day];

}

- (NSUInteger)TF_daysInYear {
    return [NSDate TF_daysInYear:self];
}
+ (NSUInteger)TF_daysInYear:(NSDate *)date {
    return [NSDate TF_isLeapYear:date]?366:365;
}

#pragma mark -- 判断有几周
- (NSUInteger)TF_weekForYear {
    return [NSDate TF_weekForYear:self];
}
+ (NSUInteger)TF_weekForYear:(NSDate *)date {
    NSUInteger i;
    NSUInteger year = [date TF_year];//2017
    for (i = 1;[[date TF_dateAfterDay:-7 * i] TF_year] == year; i++) {
    }
    return i;
}
- (NSUInteger)TF_weekForMonth {
    return [NSDate TF_weekFotMonth:self];
}
+ (NSUInteger)TF_weekFotMonth:(NSDate *)date {
    return [[date TF_lastdayOfMonth] TF_weekForYear] -[[date TF_begindayOfMonth] TF_weekForYear] + 1;
}

#pragma mark -- 获取该月的第一天和最后一天日期
- (NSDate *)TF_begindayOfMonth {
    return [NSDate TF_begindayOfMonth:self];
}
+ (NSDate *)TF_begindayOfMonth:(NSDate *)date {
    return [self TF_dateAfterDate:date day:-[date TF_day] +1];
}
- (NSDate *)TF_lastdayOfMonth {
    return [NSDate TF_lastdayOfMonth:self];
}
+ (NSDate *)TF_lastdayOfMonth:(NSDate *)date {
    NSDate *lastDate = [self TF_begindayOfMonth:date];
    return [[NSDate TF_dateAfterDate:lastDate month:1] TF_dateAfterDay:-1];
}

#pragma mark -- 多长时间后的日期
//天
- (NSDate *)TF_dateAfterDay:(NSInteger)day {
    return [NSDate TF_dateAfterDate:self
                                day:day];
}
+ (NSDate *)TF_dateAfterDate:(NSDate *)date
                         day:(NSInteger)day {
    if (date == nil) {
        return nil;
    }
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSCalendar *calendar = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
    NSCalendar *calendar = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSGregorianCalendar];
#endif
    NSDateComponents *compomentsAdd = [[NSDateComponents alloc] init];
    [compomentsAdd setDay:day];
    NSDate *afterDate = [calendar dateByAddingComponents:compomentsAdd
                                                  toDate:date
                                                 options:0];
    return afterDate;
}
//月
- (NSDate *)TF_dateAfterMonth:(NSInteger)month {
    
    return [NSDate TF_dateAfterDate:self month:month];
}

+ (NSDate *)TF_dateAfterDate:(NSDate *)date month:(NSInteger)month {
    if (date == nil) {
        return nil;
    }
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSCalendar *calendar = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
    NSCalendar *calendar = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
#endif
    NSDateComponents *compomentsAdd = [[NSDateComponents alloc] init];
    [compomentsAdd setMonth:month];
    NSDate *afterDate = [calendar dateByAddingComponents:compomentsAdd
                                                  toDate:date
                                                 options:0];
    return afterDate;
}
//年
- (NSDate *)TF_dateAfterYear:(NSInteger)year {
    return [NSDate TF_dateAfterDate:self year:year];
}
+ (NSDate *)TF_dateAfterDate:(NSDate *)date year:(NSInteger)year {
    if (date == nil) {
        return nil;
    }
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSCalendar *calendar = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
    NSCalendar *calendar = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSGregorianCalendar];
#endif
    NSDateComponents *compomentsAdd = [[NSDateComponents alloc] init];
    [compomentsAdd setYear:year];
    NSDate *afterDate = [calendar dateByAddingComponents:compomentsAdd
                                                  toDate:date
                                                 options:0];
    return afterDate;
}
//时
- (NSDate *)TF_dateAfterHour:(NSInteger)hour {
    
    return [NSDate TF_dateAfterDate:self hour:hour];
}
+ (NSDate *)TF_dateAfterDate:(NSDate *)date hour:(NSInteger)hour {
    if (date == nil) {
        return nil;
    }
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    //NSDayCalendarUnit
    NSCalendar *calendar = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
    NSCalendar *calendar = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSGregorianCalendar];
#endif
    NSDateComponents *compomentsAdd = [[NSDateComponents alloc] init];
    [compomentsAdd setHour:hour];
    
    NSDate *afterDate = [calendar dateByAddingComponents:compomentsAdd
                                                  toDate:date
                                                 options:0];
    return afterDate;
}
#pragma mark -- 时间格式的字符串
+ (NSString *)TF_getNewTimeFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    NSDate *date = [NSDate date];
    return [formatter stringFromDate:date];
}
- (NSString *)TF_ymdFormat {
    return [NSDate TF_ymdFormat];
}
- (NSString *)TF_hmsFormatIs24hour:(BOOL)is24hour {
    return [NSDate TF_hmsFormatIs24hour:is24hour];
}
- (NSString *)TF_ymd_hmsFormatIs24hour:(BOOL)is24hour {
    return [NSDate TF_ymd_hmsFormatIs24hour:is24hour];
}
+ (NSString *)TF_ymdFormat {
   return @"yyy-MM-dd";
}
+ (NSString *)TF_hmsFormatIs24hour:(BOOL)is24hour {
    if (is24hour) {
      return @"HH:mm:ss";
    }
  return @"hh:mm:ss";
}
+ (NSString *)TF_ymd_hmsFormatIs24hour:(BOOL)is24hour {
    if (is24hour) {
        return @"yyyy-MM-dd HH:mm:ss";
    }
   return @"yyyy-MM-dd hh:mm:ss";
}
+ (NSString *)TF_getTimeStamps {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMddHHmmss";
    return [dateFormatter stringFromDate:date];
}
+ (NSString *)TF_getNewTimeFormat:(NSString *)format
                             date:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter stringFromDate:date];
}


#pragma mark -- 判断时间早晚
+ (int)TF_compareDate:(NSDate *)oneday
   withAnotherDate:(NSDate *)anotherDay
withIsIncludeSecond:(BOOL)isIncludeSecond {
   
    NSDateFormatter *dateFormatter = [NSDate TF_sharedDateFormatter];
    NSString *oneDayStr;
    NSString *anotherDayStr;
    if (isIncludeSecond) {
        oneDayStr       = [NSDate TF_getNewTimeFormat:[NSDate TF_ymd_hmsFormatIs24hour:YES] date:oneday];
        anotherDayStr   = [NSDate TF_getNewTimeFormat:[NSDate TF_ymd_hmsFormatIs24hour:YES] date:anotherDay];
        [dateFormatter setDateFormat:[NSDate TF_ymd_hmsFormatIs24hour:YES]];
    }else {
        oneDayStr       = [NSDate TF_getNewTimeFormat:@"yyyy-MM-dd hh:mm" date:oneday];
        anotherDayStr   = [NSDate TF_getNewTimeFormat:@"yyyy-MM-dd hh:mm" date:anotherDay];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    }
  
    NSDate *Adate       = [dateFormatter dateFromString:oneDayStr];
    NSDate *Bdate       = [dateFormatter dateFromString:anotherDayStr];
    if (Adate == nil && Bdate == nil) {
        assert(@"有的时间传入为空,转换不正确");
    }
    NSComparisonResult result = [Adate compare:Bdate];
    if (result == NSOrderedDescending) {
        return  1;
    }else if (result == NSOrderedAscending) {
        return  -1;
    }else {
        return 0;
    }
}

- (BOOL)TF_isSameDay:(NSDate *)anotherDate {
    return [NSDate TF_isSameDay:self another:anotherDate];
}
+ (BOOL)TF_isSameDay:(NSDate *)oneDate
             another:(NSDate *)anotherDate {
    NSCalendar *calender                = [NSDate TF_sharedCalendar];
    NSDateComponents *oneComponents     = [calender components:NSCalendarUnitYear
                                                             | NSCalendarUnitMonth
                                                             | NSCalendarUnitDay
                                                  fromDate:oneDate];
    NSDateComponents *anotherComponents = [calender components:NSCalendarUnitYear
                                                             | NSCalendarUnitMonth
                                                             | NSCalendarUnitDay
                                                      fromDate:anotherDate];
    return (oneComponents.year == anotherComponents.year &&
            oneComponents.month == anotherComponents.month&&
            oneComponents.day == anotherComponents.day);
}

- (BOOL)TF_isToday {
    return [NSDate TF_isTodayWithDate:self];
}
+ (BOOL)TF_isTodayWithDate:(NSDate *)today {
    return [NSDate TF_isSameDay:[NSDate date] another:today];
}
#pragma mark -- 返回时间时间格式字符串
+ (NSString *)TF_timeWithDate:(NSDate *)date {
    NSString *currentDateStr            = [NSDate TF_getNewTimeFormat:@"MM-dd"];
    NSDate *tomorrowDate                = [NSDate TF_dateAfterDate:[NSDate date] day:1];
    NSDateFormatter *dateFormatter      = [NSDate TF_sharedDateFormatter];
    [dateFormatter setDateFormat:@"MM-dd"];
    NSString *tomorrowDateStr           = [dateFormatter stringFromDate:tomorrowDate];
    NSString *nowStr                    = [dateFormatter stringFromDate:date];
    if ([currentDateStr isEqualToString:nowStr]) {
        return @"今天";
    }else if ([tomorrowDateStr isEqualToString:nowStr]) {
        return @"明天";
    }else {
        return nowStr;
    }
}
+ (NSString *)TF_dateStringWithDelay:(NSTimeInterval)delay {
    [self TF_sharedDateFormatter].dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:delay*60*60];
    
    return [[self TF_sharedDateFormatter] stringFromDate:date];
}
- (NSString *)TF_dateDescription {
    NSUInteger units = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponents    = [[NSDate TF_sharedCalendar] components:units fromDate:self];
    NSDateComponents *thisComponents    = [[NSDate TF_sharedCalendar] components:units fromDate:[NSDate date]];
    if (dateComponents.year == thisComponents.year && dateComponents.month == thisComponents.month && dateComponents.day == thisComponents.day) {
        NSInteger  delay = (NSInteger)[[NSDate date] timeIntervalSinceDate:self];
        
        if (delay < 60) {
            return @"刚刚";
        }else if (delay < 3600) {
            return [NSString stringWithFormat:@"%ld 分钟前" , delay / 60];
        }
        return [NSString stringWithFormat:@"%ld 小时前" , delay / 3600];
    }else if (dateComponents.year == thisComponents.year && dateComponents.month == thisComponents.month && dateComponents.day != thisComponents.day) {
        if (thisComponents.day > dateComponents.day) {
            return [NSString stringWithFormat:@"%ld 天前" , thisComponents.day - dateComponents.day];
        }
    }else if (dateComponents.year == thisComponents.year && dateComponents.month != thisComponents.month ) {
        if (thisComponents.month > dateComponents.month) {
            return [NSString stringWithFormat:@"%ld 月前" , thisComponents.month - dateComponents.month];
        }
    }else if (dateComponents.year == thisComponents.year) {
        if (thisComponents.year > dateComponents.year) {
            return [NSString stringWithFormat:@"%ld 年前" , thisComponents.year - dateComponents.year];
        }
    }
    NSString *format = @"MM-dd HH:mm";
    if (dateComponents.year != thisComponents.year) {
        format = [@"yyyy-" stringByAppendingString:format];
    }
    [NSDate TF_sharedDateFormatter].dateFormat = format;
    return [[NSDate TF_sharedDateFormatter] stringFromDate:self];
}
#pragma mark -- 星期相关
- (NSUInteger)TF_weekDay {
    return [NSDate TF_weekDay:self];
}
+ (NSUInteger)TF_weekDay:(NSDate *)date {
    NSCalendar *calendar = [NSDate TF_sharedCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitDay
                                                         |NSCalendarUnitMonth
                                                         | NSCalendarUnitYear
                                                         | NSCalendarUnitWeekday)
                                               fromDate:date];
    return [components weekday];
}
- (NSString *)TF_dayFromWeekdayIsEnglish:(BOOL)isEnglish {
    return [NSDate TF_dayFromWeekday:self isEnglish:isEnglish];
}
+ (NSString *)TF_dayFromWeekday:(NSDate *)date isEnglish:(BOOL)isEnglish {
    switch ([date TF_weekDay]) {
        case 1:
            
            return isEnglish?@"Sunday":@"星期天";
            break;
        case 2:
            return isEnglish?@"Monday":@"星期一";
            break;
        case 3:
            return isEnglish?@"Tuerday":@"星期二";
            break;
        case 4:
            return isEnglish?@"Wednesday":@"星期三";
            break;
        case 5:
            return isEnglish?@"Thursday":@"星期四";
            break;
        case 6:
            return isEnglish?@"Friday":@"星期五";
            break;
        case 7:
            return isEnglish?@"Saturday":@"星期六";
            break;
        default:
            break;
    }
    return @"";
}
#pragma mark -- 其他
+ (NSDate *)TF_dateWithLocalEN_USString:(NSString *)dateStr format:(NSString *)format {
    NSDateFormatter *outPutFormatter = [NSDate TF_sharedDateFormatter];
    outPutFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [outPutFormatter setDateFormat:format];
    return [outPutFormatter dateFromString:dateStr];
}
+ (NSDate *)TF_dateWithString:(NSString *)dateStr format:(NSString *)format {
    NSDateFormatter *outPutFormatter = [NSDate TF_sharedDateFormatter];
    [outPutFormatter setDateFormat:format];
    return [outPutFormatter dateFromString:dateStr];
}
#pragma mark -- 获得当前本地时间
+ (NSDate *)TF_getCurrentDate{
    NSDate * date = [NSDate date];
    return [self TF_getLocationDate:date];
}
+ (NSDate *)TF_getLocationDate:(NSDate *)date {
    NSTimeZone *zone = [NSTimeZone systemTimeZone]; // 获得系统的时区
    NSTimeInterval time = [zone secondsFromGMTForDate:date];// 以秒为单位返回当前时间与系统格林尼治时间的差
    return  [date dateByAddingTimeInterval:time];// 然后把差的时间加上,就是当前系统准确的时间
}
@end
