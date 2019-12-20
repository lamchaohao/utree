//
//  ParentInfoApi.m
//  utree
//
//  Created by 科研部 on 2019/12/19.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ParentInfoApi.h"

@implementation ParentInfoApi

{
    NSString *_parentId;
}

- (instancetype)initWithParentId:(NSString *)parentId
{
    self = [super init];
    if (self) {
        _parentId = parentId;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"tmobile/msg/parentInfo";
}

- (id)requestArgument
{
    return @{
        @"parentId":_parentId
    };
}



@end
