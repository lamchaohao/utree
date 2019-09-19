//
//  SJDateConvertTool.m
//  utree
//
//  Created by 科研部 on 2019/8/16.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "SJDateConvertTool.h"

@implementation SJDateConvertTool



/**
 获取现在的时间戳
 
 @return 现在的时间戳
 */
+ (long)getThePresentTimeStamp
{
    NSDate *date = [NSDate date];
    long timeStamp = [date timeIntervalSince1970];
    
    return timeStamp;
}
/**
 获取现在的时间
 
 @param dateDisplayType 转换类型
 @param customTypeString 自定义类型，如果不需要的话设置nil
 @return 现在的时间
 */
+ (NSString *)getThePresentTimeWithDateDisplayType:(DateDisplayType)dateDisplayType
                                  customTypeString:(NSString *)customTypeString
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat: [self getDateDisplayTypeWithType:dateDisplayType customTypeString:customTypeString]];
    
    NSDate *date = [NSDate date];
    
    NSString *timeString = [dateformatter stringFromDate:date];
    
    return timeString;
}

/**
 时间戳转换成字符串
 
 @param timeStamp 时间戳
 @param dateDisplayType 转换类型
 @param customTypeString 自定义类型，如果不需要的话设置nil
 @return 字符串日期
 */
+ (NSString *)dateConvertTimeStampToStringWithTimeStamp:(long)timeStamp
                                        dateDisplayType:(DateDisplayType)dateDisplayType
                                       customTypeString:(NSString *)customTypeString
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat: [self getDateDisplayTypeWithType:dateDisplayType customTypeString:customTypeString]];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    
    NSString *timeString = [dateformatter stringFromDate:date];
    
    return timeString;
}

/**
 字符串转换成时间戳
 
 @param timeString 时间字符串
 @param dateDisplayType 转换类型
 @param customTypeString 自定义类型，如果不需要的话设置nil
 @return 时间戳
 */
+ (long)dateConvertStringToTimeStampWithTimeString:(NSString *)timeString
                                   dateDisplayType:(DateDisplayType)dateDisplayType
                                  customTypeString:(NSString *)customTypeString
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat: [self getDateDisplayTypeWithType:dateDisplayType customTypeString:customTypeString]];
    
    NSDate *date = [dateformatter dateFromString:timeString];
    
    long timeStamp = [date timeIntervalSince1970];
    
    return timeStamp;
}


/**
 字符串转换成字符串  （完整时间转换成小时间,，例如：yyyy-MM-dd HH:mm:ss -> HH:mm）
 
 @param timeString 时间字符串
 @param dateDisplayType 转换类型（期望输入的类型）
 @param customTypeString 自定义类型，如果不需要的话设置nil
 @return 时间戳
 */
+ (NSString *)dateConvertStringToStringWithTimeString:(NSString *)timeString
                                      dateDisplayType:(DateDisplayType)dateDisplayType
                                     customTypeString:(NSString *)customTypeString
{
    //  时间戳
    long timeStap = [self dateConvertStringToTimeStampWithTimeString:timeString dateDisplayType:dateDisplayType customTypeString:customTypeString];
    
    //  时间字符串
    NSString *newTimeString = [self dateConvertTimeStampToStringWithTimeStamp:timeStap dateDisplayType:dateDisplayType customTypeString:customTypeString];
    
    return newTimeString;
}



/**
 时间戳转换成字符串  （多少时间之内的，类似朋友圈的发布时间显示）
 
 @param timeStamp 时间戳
 @param hour 设置多少小时以内显示分钟
 @return 时间字符串
 */
+ (NSString *)dateConvertTimeStampToLatelyStringWithTimeStamp:(long)timeStamp
                                                         hour:(NSInteger)hour
{
    //  获取现在的时间戳
    long nowTimeStamp = [self getThePresentTimeStamp];
    long diffTimeStamp = nowTimeStamp - timeStamp;
    
    //  显示的日期
    NSString *dateString = @"";
    
    if(diffTimeStamp >= 24*60*60)
    {
        //  一天前，显示日期
        dateString = [self dateConvertTimeStampToStringWithTimeStamp:timeStamp dateDisplayType:DateDisplayType_Date customTypeString:nil];
    }
    else if(diffTimeStamp >= 60*60*hour)
    {
        //  一天内，但是hour小时外，显示今天的小时
        NSInteger hourString = (NSInteger)(diffTimeStamp/(60*60));
        dateString = [NSString stringWithFormat:@"%ld小时前",(long)hourString];
    }
    else if(diffTimeStamp >= 60*60)
    {
        //  1小时至hour小时之间
        
        //  小时
        NSInteger beforeHour = (NSInteger)(diffTimeStamp/(60*60));
        //  分钟
        NSInteger beforeMinute = (NSInteger)((diffTimeStamp - beforeHour*60*60)/60);
        dateString = [NSString stringWithFormat:@"%ld小时%ld分钟前",(long)beforeHour,(long)beforeMinute];
    }
    else if(diffTimeStamp >= 1*60)
    {
        //  一小时至一分钟之内
        NSInteger beforeMinute = (NSInteger)(diffTimeStamp/60);
        dateString = [NSString stringWithFormat:@"%ld分钟前",(long)beforeMinute];
    }
    else
    {
        //  一分钟之内
        dateString = @"刚刚";
    }
    
    return dateString;
}



/**
 获取多少天之前之后的日期时间
 
 @param timeString 时间字符串
 @param dateDisplayType 转换类型
 @param customTypeString 自定义类型，如果不需要的话设置nil
 @param dayNum 天数
 @param directionType 之前之后方向
 @return 日期时间字符串
 */
+ (NSString *)gainPreviousDateWithBeginTimeString:(NSString *)timeString
                                  dateDisplayType:(DateDisplayType)dateDisplayType
                                 customTypeString:(NSString *)customTypeString
                                           dayNum:(NSInteger)dayNum
                                    directionType:(PreviousDateDirectionType)directionType
{
    //  获取时间戳
    long timeStamp = [self dateConvertStringToTimeStampWithTimeString:timeString dateDisplayType:dateDisplayType customTypeString:customTypeString];
    
    //  时间差
    long timeDiff = dayNum*24*60*60;
    
    //  新的时间戳
    long newTimeStamp ;
    if(directionType == PreviousDateDirectionType_Before)
    {
        //  之前
        newTimeStamp = timeStamp - timeDiff;
    }
    else
    {
        //  之后
        newTimeStamp = timeStamp + timeDiff;
    }
    
    //  获取时间字符串
    NSString *newTimeString = [self dateConvertTimeStampToStringWithTimeStamp:newTimeStamp dateDisplayType:dateDisplayType customTypeString:customTypeString];
    
    return newTimeString;
    
}



/**
 获取转换类型
 
 @param dateDisplayType 转换类型
 @param customTypeString 自定义类型，如果不需要的话设置nil
 @return 转换类型
 */
+ (NSString *)getDateDisplayTypeWithType:(DateDisplayType)dateDisplayType
                        customTypeString:(NSString *)customTypeString
{
    NSString *timeTypeString = nil;
    
    switch (dateDisplayType)
    {
        case DateDisplayType_Default:
        {
            timeTypeString = @"yyyy-MM-dd HH:mm:ss";
            break;
        }
        case DateDisplayType_Date:
        {
            timeTypeString = @"yyyy-MM-dd";
            break;
        }
        case DateDisplayType_Time:
        {
            timeTypeString = @"HH:mm";
            break;
        }
        case DateDisplayType_Custom:
        {
            //  自定义类型不正确的话设置默认类型
            timeTypeString = customTypeString ? customTypeString : @"yyyy-MM-dd HH:mm:ss";
            break;
        }
        default:
        {
            //  找不到的话设置默认类型
            timeTypeString = @"yyyy-MM-dd HH:mm:ss";
            break;
        }
    }
    return timeTypeString;
}

@end

