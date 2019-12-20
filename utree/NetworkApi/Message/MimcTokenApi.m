//
//  MimcTokenApi.m
//  utree
//
//  Created by 科研部 on 2019/12/12.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "MimcTokenApi.h"

@implementation MimcTokenApi

{
    NSString *_accoutId;
}

- (instancetype)initWithAccountId:(NSString *)accountId
{
    self = [super init];
    if (self) {
        _accoutId = accountId;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"tmobile/mimc/fetch_mimc_token";
}

- (id)requestArgument
{
    return @{
        @"appAccount":_accoutId
    };
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (YTKResponseSerializerType)responseSerializerType
{
    return YTKResponseSerializerTypeHTTP;
}

@end
