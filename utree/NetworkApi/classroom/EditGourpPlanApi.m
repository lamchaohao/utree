//
//  EditGourpPlanApi.m
//  utree
//
//  Created by 科研部 on 2019/11/1.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "EditGourpPlanApi.h"

@implementation EditGourpPlanApi

{
    NSString *_groupPlanId;
    NSString *_name;
    NSString *_classId;
}
- (instancetype)initWithName:(NSString *)groupName classId:(NSString *)clazzId
{
    self = [super init];
       if (self) {
           _classId = clazzId;
           _name = groupName;
       }
       return self;
}

- (instancetype)initWithName:(NSString *)groupName classId:(NSString *)clazzId planId:(NSString *)planId
{
    self = [super init];
    if (self) {
        _groupPlanId = planId;
        _classId = clazzId;
        _name = groupName;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"tmobile/class/addGroupPlan";
}

- (id)requestArgument
{
    if (_groupPlanId) {
        return @{
            @"groupPlanId":_groupPlanId,
            @"name":_name,
            @"classId":_classId
        };
    }else{
        return @{
            @"name":_name,
            @"classId":_classId
        };
    }
    
}

@end
