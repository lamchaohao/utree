//
//  UpdateAvatarApi.m
//  utree
//
//  Created by 科研部 on 2019/11/18.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UpdateAvatarApi.h"

@implementation UpdateAvatarApi

{
    NSDictionary *dict;
}

- (instancetype)initWithDataDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        dict=dic;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"tmobile/base/updateAvatar";
}


- (id)requestArgument
{
    return dict;
}

@end
