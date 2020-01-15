//
//  NoticeModel.m
//  utree
//
//  Created by 科研部 on 2019/11/15.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "NoticeModel.h"

@implementation NoticeModel


- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"audio"]) {
        if (oldValue == nil) return [FileObject new];
    } else if ([property.name isEqualToString:@"createTime"]) {
        NSString *subValue = [oldValue stringByReplacingOccurrencesOfString:@".000+" withString:@"+"];
        return [self getLocalDateFormateUTCDate:subValue];
    }else if([property.name isEqualToString:@"picPath"]){
        
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
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];

    return dateString;
}


-(NSArray *)picList
{
    if(!_picList)
    {
        NSString *jsonStr = [NSString stringWithFormat:@"{\"pics\":%@}",_picPath];
        NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
        options:NSJSONReadingMutableContainers error:&err];

        if(err) {
           NSLog(@"json解析失败：%@",err);
        }else{
            _picList = [dic objectForKey:@"pics"];
        }
    
    }
    return _picList;
    
}

- (NSArray *)thumnails
{
    if (!_thumnails) {
        _thumnails = [[NSMutableArray alloc]init];
        for (NSString *picURL in self.picList) {
            //等比缩放，限定在矩形框内 将图缩略成原图质量的50%
            NSString *thumnailURL = [picURL stringByAppendingFormat:@"?x-oss-process=image/quality,q_50"];
            [_thumnails addObject:thumnailURL];
        }
    }
    return _thumnails;
}

@end
