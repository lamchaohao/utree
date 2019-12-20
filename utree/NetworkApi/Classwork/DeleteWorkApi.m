//
//  DeleteWorkApi.m
//  utree
//
//  Created by 科研部 on 2019/12/4.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "DeleteWorkApi.h"

@implementation DeleteWorkApi

{
    BOOL _isNotice;
    NSString *_workId;
}

- (instancetype)initWithId:(NSString *)workId isNotice:(BOOL)isNotice
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
    if (_isNotice) {
        return @"tmobile/task/deleteNotice";
    }else{
        return @"tmobile/task/delStudentTask";
    }
}

- (id)requestArgument
{
    if(_isNotice){
        return @{@"noticeId":_workId};
    }else{
        return @{@"workId":_workId};
    }
}

@end
