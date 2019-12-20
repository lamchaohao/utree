//
//  DeleteMomentApi.m
//  utree
//
//  Created by 科研部 on 2019/11/26.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "DeleteMomentApi.h"

@implementation DeleteMomentApi

{
    NSString *momentId;
}

- (instancetype)initWithMomentId:(NSString *)circleId
{
    self = [super init];
    if (self) {
        momentId =circleId;
    }
    return self;
}


- (NSString *)requestUrl
{
    return @"tmobile/schoolCircle/delSchoolCircle";
}



- (id)requestArgument
{
    return @{
        @"schoolCircleId":momentId
    };
}

@end
