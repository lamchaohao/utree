//
//  ResetPswApi.m
//  utree
//
//  Created by 科研部 on 2019/10/24.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ResetPswApi.h"

@implementation ResetPswApi
{
    NSString *_phone;
    NSString *_code ;
    NSString *_newPsw;
}


-(instancetype)initWithPhone:(NSString *)phone code:(NSString *)code newPassword:(NSString *)psw
{
    self = [super init];
    if (self) {
        _phone = phone;
        _code = code;
        _newPsw = psw;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"tmobile/base/resetPassword";
}

-(id)requestArgument
{
    return @{
        @"account":_phone,
        @"verification":_code,
        @"password":_newPsw
    };
}

@end
