//
//  DropRecordApi.m
//  utree
//
//  Created by 科研部 on 2019/11/7.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "DropRecordApi.h"

@implementation DropRecordApi

{
    NSString *_stuId;
    NSNumber *_dateZone;//时间范围：1今天，2本周，3本月，4上月，5本学期
    NSString *_dropId;//相同条件下，上一次获取的最后一条数据id
    NSNumber *_limit;
    BOOL _isRequestMore;
}
- (instancetype)initWithStuId:(NSString *)stuId dateZone:(NSNumber *)num limit:(NSNumber *)limit
{
    self = [super init];
    if (self) {
        _isRequestMore=NO;
        _stuId = stuId;
        _dateZone = num;
        _limit = limit;
    }
    return self;
}

- (instancetype)initWithStuId:(NSString *)stuId dateZone:(NSNumber *)num lastDropId:(NSString *)dropId limit:(NSNumber *)limit
{
    self = [super init];
    if (self) {
        _isRequestMore=YES;
        _stuId = stuId;
        _dateZone = num;
        _dropId = dropId;
        _limit = limit;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"tmobile/class/getStudentRewardRecord";
}

- (id)requestArgument
{
    if (_isRequestMore) {
        return @{
            @"studentId":_stuId,
            @"timeFrame":_dateZone,
            @"dropId":_dropId,
            @"limit":_limit
        };
    }else{
        return @{
            @"studentId":_stuId,
            @"timeFrame":_dateZone,
            @"limit":_limit
        };
    }
    
}


@end
