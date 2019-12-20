//
//  AttendanceStatusApi.m
//  utree
//
//  Created by 科研部 on 2019/11/12.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "AttendanceStatusApi.h"
@implementation AttendanceStatusApi

{
    NSMutableDictionary *_wrapRequestStr;
}

- (instancetype)initWithRequestDictionary:(NSMutableDictionary *)dic
{
    self = [super init];
    if (self) {
        _wrapRequestStr = dic;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"tmobile/class/updateAttendance";
}

- (id)requestArgument
{
    return @{
        @"paramDo":[NSString stringWithFormat:@"%@",_wrapRequestStr]
    };
}

@end
