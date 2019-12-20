//
//  ParentContactApi.m
//  utree
//
//  Created by 科研部 on 2019/12/6.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ParentContactApi.h"

@implementation ParentContactApi

{
    NSString *_classId;
}

- (instancetype)initWithClassId:(NSString *)classId
{
    self = [super init];
    if (self) {
        _classId = classId;
    }
    return self;
}


- (NSString *)requestUrl
{
    return @"tmobile/msg/chatBook";
}

- (id)requestArgument
{
    return @{
        @"classId":_classId
    };
}

@end
