//
//  ChangePhoneNumApi.m
//  utree
//
//  Created by 科研部 on 2019/12/26.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ChangePhoneNumApi.h"

@implementation ChangePhoneNumApi

{
    NSString *_codeStr;
    NSString *_newPhone;
    NSString *_newCode;
}

- (NSString *)requestUrl
{
    return @"tmobile/base/changePhoneNum";
}

- (instancetype)initWithOldCode:(NSString *)oldCode newPhone:(NSString *)phone andNewCode:(NSString *)newCode
{
    self = [super init];
    if (self) {
        _codeStr = oldCode;
        _newPhone = phone;
        _newCode = newCode;
    }
    return self;
}

- (id)requestArgument
{
    return @{@"oldVerification":_codeStr,
             @"newPhone":_newPhone,
             @"newVerification":_newCode
    };
}


@end
