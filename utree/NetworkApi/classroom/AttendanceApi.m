//
//  AttendanceApi.m
//  utree
//
//  Created by 科研部 on 2019/10/31.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "AttendanceApi.h"

@implementation AttendanceApi
{
    NSString *_classID;
}

- (instancetype)initWithClassId:(NSString *)clazzId
{
    self = [super init];
    if (self) {
        _classID = clazzId;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"tmobile/class/getStudentsAttendance";
}

- (id)requestArgument
{
    return @{@"classId":_classID};
}

@end
