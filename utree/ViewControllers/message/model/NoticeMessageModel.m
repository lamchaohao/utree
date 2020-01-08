//
//  NoticeMessageModel.m
//  utree
//
//  Created by 科研部 on 2019/12/24.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "NoticeMessageModel.h"

@implementation NoticeMessageModel


- (NSString *)createTime
{
    NSString *subValue = [_createTime stringByReplacingOccurrencesOfString:@".000+" withString:@"+"];
   NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    NSDate *dateFormatted = [dateFormatter dateFromString:subValue];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];

    return dateString;
}

@end
