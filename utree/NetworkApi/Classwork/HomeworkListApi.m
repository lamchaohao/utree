//
//  HomeworkListApi.m
//  utree
//
//  Created by 科研部 on 2019/11/27.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "HomeworkListApi.h"

@implementation HomeworkListApi


{
    NSString *_classId;
    NSNumber *_limit;
    NSString *_workId;
    BOOL _myself;
    BOOL _isRequestMore;
}

- (NSString *)requestUrl
{
    return @"tmobile/task/studentTaskList";
}



- (instancetype)initWithFirstClassId:(NSString *)classId isMydata:(BOOL)isMine
{
    self = [super init];
    if (self) {
        _classId = classId;
        _myself = isMine;
        _isRequestMore= NO;
    }
    return self;
}

- (instancetype)initWithMoreWithClassId:(NSString *)classId isMydata:(BOOL)isMine limitNum:(NSNumber *)limit lastTaskId:(NSString *)lastTaskId
{
    self = [super init];
    if (self) {
        _isRequestMore= YES;
        _classId = classId;
        _myself = isMine;
        _workId = lastTaskId;
        _limit = limit;
    }
    return self;
}

- (id)requestArgument
{
    if (_isRequestMore) {
        return @{@"classId":_classId,
                 @"limit":_limit,
                 @"workId":_workId,
                 @"myself":@(_myself)
        };
    }else{
        return @{@"classId":_classId,
                 @"myself":@(_myself)
        };
    }
    
    
}


@end
