//
//  GroupDetailByIdApi.m
//  utree
//
//  Created by 科研部 on 2019/11/5.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "GroupDetailByIdApi.h"

@implementation GroupDetailByIdApi

{
    NSString *_groupId;
    NSString *_classId;
}

- (instancetype)initWithGroupId:(NSString *)groupId clazzId:(NSString *)clazzId
{
    self = [super init];
    if (self) {
        _groupId = groupId;
        _classId = clazzId;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"tmobile/class/getGroupById";
}

- (id)requestArgument
{
    return @{
        @"teachClassId":_classId,
        @"groupId":_groupId
    };
}

@end
