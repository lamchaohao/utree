//
//  VerifyOldPhoneApi.m
//  utree
//
//  Created by 科研部 on 2019/12/26.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "VerifyOldPhoneApi.h"

@implementation VerifyOldPhoneApi

{
    NSString *_codeStr;
}

- (NSString *)requestUrl
{
    return @"tmobile/base/verifyOldPhone";
}

- (instancetype)initWithCode:(NSString *)code
{
    self = [super init];
    if (self) {
        _codeStr = code;
    }
    return self;
}

- (id)requestArgument
{
    return @{@"verification":_codeStr};
}

@end
