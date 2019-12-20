//
//  GroupListApi.m
//  utree
//
//  Created by 科研部 on 2019/11/4.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "GroupListApi.h"

@implementation GroupListApi

{
    NSString *_classId;
    NSString *_planId;
}

- (instancetype)initWithClassId:(NSString *)classid planId:(NSString *)planid
{
    self = [super init];
    if (self) {
        _classId = classid;
        _planId = planid;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"tmobile/class/getGroupByPlan";
}

- (id)requestArgument
{
    return @{@"teachClassId":_classId,@"planId":_planId};
}

@end
