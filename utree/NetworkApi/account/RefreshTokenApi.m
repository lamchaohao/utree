//
//  RefreshTokenApi.m
//  utree
//
//  Created by 科研部 on 2019/10/24.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "RefreshTokenApi.h"

@implementation RefreshTokenApi
{
    NSString *_access_token;
}

-(id)initWithToken:(NSString *)token
{
    self = [super init];
    if (self) {
        _access_token = token;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"tmobile/base/refreshToken";
}

-(YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument
{
    return @{@"token":_access_token};
}

@end
