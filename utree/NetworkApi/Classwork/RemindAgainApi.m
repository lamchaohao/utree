//
//  RemindAgainApi.m
//  utree
//
//  Created by 科研部 on 2020/1/17.
//  Copyright © 2020 科研部. All rights reserved.
//

#import "RemindAgainApi.h"

@implementation RemindAgainApi


{
    NSString *_workId;
    NSString *_studentId;
    int _workType;
}

- (instancetype)initWithWorkId:(NSString *)workId stuId:(NSString *)stuId workType:(int)type
{
    self = [super init];
    if (self) {
        _workId = workId;
        _workType = type;
        _studentId = stuId;
    }
    return self;
}


- (NSString *)requestUrl
{
    return @"tmobile/task/remindSMS";
}

- (id)requestArgument
{
    return @{
        @"id":_workId,
        @"studentId":_studentId,
        @"method":@(_workType)//通知（1）/作业（2）的发送方法
    };
}

@end
