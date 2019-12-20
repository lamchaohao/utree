//
//  DeleteStuGroupApi.m
//  utree
//
//  Created by 科研部 on 2019/11/5.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "DeleteStuGroupApi.h"

@implementation DeleteStuGroupApi

{
    NSString *_groupId;
}

- (instancetype)initWithGroupId:(NSString *)groupId
{
    self = [super init];
    if (self) {
        _groupId = groupId;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"tmobile/class/deleteStudentGroup";
}

- (id)requestArgument
{
    return @{
        @"studentGroupId":_groupId
    };
}

@end
