//
//  UnreadApi.m
//  utree
//
//  Created by 科研部 on 2020/1/13.
//  Copyright © 2020 科研部. All rights reserved.
//

#import "UnreadApi.h"

@implementation UnreadApi
{
    NSString *classID;
}

- (instancetype)initWithClassId:(NSString *)clsId
{
    self = [super init];
    if (self) {
        classID =clsId;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"tmobile/class/checkUnread";
}

- (id)requestArgument
{
    return @{@"classId":classID};
}

@end
