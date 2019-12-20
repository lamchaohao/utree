//
//  WorkClassListApi.m
//  utree
//
//  Created by 科研部 on 2019/12/5.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "WorkClassListApi.h"

@implementation WorkClassListApi

{
    BOOL _isNotice;
    NSString *_workId;
}

- (instancetype)initWithWorkId:(NSString *)workId isNotice:(BOOL)isNotice
{
    self = [super init];
    if (self) {
        _isNotice = isNotice;
        _workId = workId;
    }
    return self;
}

- (NSString *)requestUrl
{
    if(_isNotice)
        return @"tmobile/task/getNoticeClass";
    else{
        return @"tmobile/task/getStudentTaskClass";
    }
}

- (id)requestArgument
{
    if (_isNotice) {
        return @{@"noticeId":_workId};
    }else{
        return @{@"workId":_workId};
    }
}

@end
