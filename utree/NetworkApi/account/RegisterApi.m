//
//  RegisterApi.m
//  utree
//
//  Created by 科研部 on 2019/10/23.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "RegisterApi.h"

@implementation RegisterApi

{
    NSString *_username;
    NSString *_password;
    NSString *_verifyCode;
}

- (id)initWithUsername:(NSString *)username password:(NSString *)password code:(NSString *)code
{
    self = [super init];
    if (self) {
        _username = username;
        _password = password;
        _verifyCode = code;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"/tmobile/base/register";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}


- (id)requestArgument {
    
    return @{
        @"account": _username,
        @"password": _password,
        @"verification":_verifyCode
    };
}


@end
