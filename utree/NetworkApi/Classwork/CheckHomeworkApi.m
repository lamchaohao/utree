//
//  CheckHomeworkApi.m
//  utree
//
//  Created by 科研部 on 2019/12/3.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "CheckHomeworkApi.h"

@implementation CheckHomeworkApi

{
    NSString *_taskId;
    NSString *_classId;
    NSNumber *_isCheck;
}

- (instancetype)initWithWorkId:(NSString *)workId classId:(NSString *)classId isCheck:(NSNumber *)isCheck
{
    self = [super init];
    if (self) {
        _taskId = workId;
        _classId = classId;
        _isCheck = isCheck;
    }
    return self;
}


- (NSString *)requestUrl
{
    return @"tmobile/task/studentTaskDetail";
}

- (id)requestArgument
{
    return @{@"workId":_taskId,
             @"classId" :_classId,
             @"isCheckOrSubmit":@(_isCheck.boolValue)
    };
}

@end
