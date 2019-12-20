//
//  RemindCheckApi.m
//  utree
//
//  Created by 科研部 on 2019/12/3.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "RemindCheckApi.h"

@implementation RemindCheckApi

{
    NSString *_workId;
    NSString *_classId;
    int _method;
}

- (instancetype)initWithRemindId:(NSString *)remindId classId:(NSString *)classId from:(int)source
{
    self = [super init];
    if (self) {
        _workId = remindId;
        _classId = classId;
        _method = source;
    }
    return self;
}


- (NSString *)requestUrl
{
    return @"tmobile/task/remindCheck";
}


- (id)requestArgument
{
    return @{
        @"id":_workId,
        @"classId":_classId,
        @"method":[NSNumber numberWithInt:_method]
    };
}

@end
