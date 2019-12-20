//
//  StuMedalApi.m
//  utree
//
//  Created by 科研部 on 2019/11/7.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "StuMedalApi.h"

@implementation StuMedalApi

{
    NSString *_stuId;
}

- (instancetype)initWithStudentId:(NSString *)stuId
{
    self = [super init];
    if (self) {
        _stuId = stuId;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"tmobile/class/getStudentMetalList";
}


-(id)requestArgument
{
    return @{
        @"studentId":_stuId
    };
}

@end
