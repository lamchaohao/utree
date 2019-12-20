//
//  StuDropRecordModel.m
//  utree
//
//  Created by 科研部 on 2019/11/7.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "StuDropRecordModel.h"
#import "SJDateConvertTool.h"
@implementation StuDropRecordModel

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"recordDescription"]) {
        if (oldValue == nil) return @"";
    } else if ([property.name isEqualToString:@"createTime"]) {
        NSString *subValue = [oldValue stringByReplacingOccurrencesOfString:@".000+" withString:@"+"];
        return [self getLocalDateFormateUTCDate:subValue];
    }

    return oldValue;
}

-(NSString *)getHourAndMinute
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateFormatted = [dateFormatter dateFromString:self.createTime];
    //输出格式
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
}

-(NSString *)getRecordDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateFormatted = [dateFormatter dateFromString:self.createTime];
    
    NSDate *dateNow = [NSDate date];
    
    //输出格式
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    
    NSInteger dayInterval = [SJDateConvertTool getDaysFrom:dateFormatted To:dateNow];
    
    if (dayInterval==1) {
        return @"昨天";
    }else if(dayInterval==0){
        return @"今天";
    }else if(dayInterval==2){
        return @"前天";
    }else{
        return dateString;
    }
   
    
}
 
- (NSString *)getUTCFormateLocalDate:(NSString *)localDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateFormatted = [dateFormatter dateFromString:localDate];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
}
  
//将UTC日期字符串转为本地时间字符串
//输入的UTC日期格式2013-08-03T04:53:51+0000
- (NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    NSDate *dateFormatted = [dateFormatter dateFromString:utcDate];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];

    return dateString;
}



@end
