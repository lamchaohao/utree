//
//  CheckParentApi.m
//  utree
//
//  Created by 科研部 on 2019/12/2.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "CheckParentApi.h"

@implementation CheckParentApi

{
    NSString *_noticeId;
    NSString *_classId;
    NSNumber *_isCheck;
}

- (instancetype)initWithNoticeId:(NSString *)noticeId classId:(NSString *)classId isCheck:(NSNumber *)isCheck
{
    self = [super init];
    if (self) {
        _noticeId = noticeId;
        _classId = classId;
        _isCheck = isCheck;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"tmobile/task/checkNoticeDetail";
}

- (id)requestArgument
{
    return @{@"noticeId":_noticeId,
             @"classId" :_classId,
             @"isCheck":@(_isCheck.boolValue)
    };
}

@end
