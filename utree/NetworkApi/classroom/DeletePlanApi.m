//
//  DeletePlanApi.m
//  utree
//
//  Created by 科研部 on 2019/11/4.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "DeletePlanApi.h"

@implementation DeletePlanApi
{
    NSString *_planId;
}

- (instancetype)initWithPlanId:(NSString *)planId
{
    self = [super init];
    if (self) {
        _planId = planId;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"tmobile/class/deleteGroupPlan";
}

- (id)requestArgument
{
    return @{@"groupPlanId":_planId};
}

@end
