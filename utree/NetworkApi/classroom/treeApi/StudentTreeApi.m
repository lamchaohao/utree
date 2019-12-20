//
//  StudentTreeApi.m
//  utree
//
//  Created by 科研部 on 2019/11/6.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "StudentTreeApi.h"

@implementation StudentTreeApi

{
    NSString *_stuId;
}

- (instancetype)initWithStudentId:(NSString *)studentId
{
    self = [super init];
    if (self) {
        _stuId = studentId;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"tmobile/class/getStudentTree";
}

- (id)requestArgument
{
    return @{@"studentId":_stuId};
}

@end
