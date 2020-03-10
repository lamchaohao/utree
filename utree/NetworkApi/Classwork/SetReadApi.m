//
//  SetReadApi.m
//  utree
//
//  Created by 科研部 on 2020/1/16.
//  Copyright © 2020 科研部. All rights reserved.
//

#import "SetReadApi.h"

@implementation SetReadApi


{
    NSString *_workId;
    int _workType;
}

- (instancetype)initWithWorkId:(NSString *)workId type:(int)type
{
    self = [super init];
    if (self) {
        _workId =workId;
        _workType = type;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"tmobile/task/reading";
}

- (id)requestArgument
{
    return @{@"id":_workId,
             @"method":@(_workType)
    };
}

@end
