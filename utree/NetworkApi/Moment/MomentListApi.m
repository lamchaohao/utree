//
//  MomentListApi.m
//  utree
//
//  Created by 科研部 on 2019/11/20.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "MomentListApi.h"

@implementation MomentListApi


{
    BOOL _isRequestMore;
    NSString *_schoolCircleId;
    NSNumber *_limit;
    BOOL _myself;
}

- (instancetype)initWithFirstTime:(BOOL)mySelf limit:(NSNumber *)limit
{
    self = [super init];
    if (self) {
        _isRequestMore = NO;
        _myself = mySelf;
        _limit = limit;
    }
    return self;
}

- (instancetype)initWithMore:(BOOL)mySelf limit:(NSNumber *)limit lastId:(NSString *)lastId
{
    self = [super init];
    if (self) {
        _isRequestMore = YES;
        _myself = mySelf;
        _limit=limit;
        _schoolCircleId = lastId;
    }
    return self;
}


- (NSString *)requestUrl
{
    return @"tmobile/schoolCircle/circleList";
}


- (id)requestArgument
{
    
    if (_isRequestMore) {
        return @{@"schoolCircleId":_schoolCircleId,
                 @"limit":_limit,
                 @"myself":@(_myself)
        };
    }else{
        return @{@"myself":@(_myself),@"limit":_limit};
    }
    
}


@end
