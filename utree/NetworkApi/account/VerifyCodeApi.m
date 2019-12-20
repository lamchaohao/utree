//
//  VerifyCodeApi.m
//  utree
//
//  Created by 科研部 on 2019/10/23.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "VerifyCodeApi.h"

@implementation VerifyCodeApi

{
    NSString *_account ;
    VerifyCodeMethod _usage ;

}

//REGISTER（注册用）、LOGIN（登录用）、SETPWD（修改密码用）、CHANGEPHONE（更换手机号码）

- (id)initWithAccount:(NSString *)account usage:(VerifyCodeMethod)usage
{
    self = [super init];
    if (self) {
        _account = account;
        _usage = usage;
    }
    return self;
    
}

- (NSString *)requestUrl
{
    return @"/tmobile/base/getVerification";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}


- (id)requestArgument {
    VerifyCodeMethod forWhat = _usage;
    NSString *method = @"";
    switch (forWhat) {
        case USAGE_REGISTER:
            method= @"REGISTER";
            break;
        case USAGE_SETPWD:
            method= @"SETPWD";
            break;
        case USAGE_LOGIN:
            method= @"LOGIN";
            break;
        case USAGE_CHANGEPHONE:
            method= @"CHANGEPHONE";
            break;
        default:
            break;
    }
    NSLog(@"method:%@",method);
    return @{
        @"account": _account,
        @"method":method
    };
}


@end
