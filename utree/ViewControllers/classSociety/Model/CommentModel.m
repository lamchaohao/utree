//
//  CommentModel.m
//  utree
//
//  Created by 科研部 on 2019/11/21.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
   if ([property.name isEqualToString:@"createTime"]) {
        NSString *subValue = [oldValue stringByReplacingOccurrencesOfString:@".000+" withString:@"+"];
        return [self getLocalDateFormateUTCDate:subValue];
    }

    return oldValue;
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
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];

    return dateString;
}


@end