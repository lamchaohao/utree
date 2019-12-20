//
//  GroupPlanListApi.m
//  utree
//
//  Created by 科研部 on 2019/11/1.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "GroupPlanListApi.h"

@implementation GroupPlanListApi
{
    NSString *_classId ;
}

-(instancetype)initWithClassId:(NSString *)classId
{
    self = [super init];
    if (self) {
        _classId = classId;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"tmobile/class/getGroupPlan";
}

-(id)requestArgument
{
    return @{@"teachClassId":_classId};
}

@end
