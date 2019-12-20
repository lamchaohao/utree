//
//  NoticeListApi.m
//  utree
//
//  Created by 科研部 on 2019/11/15.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "NoticeListApi.h"

@implementation NoticeListApi

{
    NSString *_classId;
    NSNumber *_limit;
    NSString *_noticeId;
    BOOL _myself;
    BOOL _isRequestMore;
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

- (instancetype)initWithMoreWithClassId:(NSString *)classId isMydata:(BOOL)isMine limitNum:(NSNumber *)limit lastNoticeId:(NSString *)lastNoticeId
{
    self = [super init];
    if (self) {
        _isRequestMore= YES;
        _classId = classId;
        _myself = isMine;
        _noticeId = lastNoticeId;
        _limit = limit;
    }
    return self;
}


- (NSString *)requestUrl
{
    return @"tmobile/task/noticeList";
}


- (id)requestArgument
{
    if (_isRequestMore) {
        return @{@"classId":_classId,
                 @"limit":_limit,
                 @"noticeId":_noticeId,
                 @"myself":@(_myself)
        };
    }else{
        return @{@"classId":_classId,
                 @"myself":@(_myself)
        };
    }
    
    
}

@end
