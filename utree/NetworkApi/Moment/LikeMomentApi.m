//
//  LikeMomentApi.m
//  utree
//
//  Created by 科研部 on 2019/11/20.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "LikeMomentApi.h"

@implementation LikeMomentApi

{
    NSString *circleId;
}

- (instancetype)initWithMomentId:(NSString *)momentId
{
    self = [super init];
    if (self) {
        circleId = momentId;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"tmobile/schoolCircle/clickLike";
}

- (id)requestArgument
{
    return @{@"schoolCircleId":circleId};
}

@end
