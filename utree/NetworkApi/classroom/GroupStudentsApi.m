//
//  GroupStudentsApi.m
//  utree
//
//  Created by 科研部 on 2019/11/4.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "GroupStudentsApi.h"

@implementation GroupStudentsApi

{
    NSString *_teachClassId;
    NSString *_planId;
}

- (instancetype)initWithClassId:(NSString *)classId planId:(NSString *)planId
{
    self = [super init];
    if (self) {
        _teachClassId = classId;
        _planId = planId;
    }
    return self;
}

- (NSString *)requestUrl{
    return @"tmobile/class/studentsWithGroupId";
}

- (id)requestArgument
{
    return @{
        @"teachClassId":_teachClassId,
        @"planId":_planId
    };
}


@end
