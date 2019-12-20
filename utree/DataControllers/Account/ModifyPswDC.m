//
//  ModifyPswDC.m
//  utree
//
//  Created by 科研部 on 2019/10/29.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ModifyPswDC.h"
#import "ResetPswApi.h"
#import "VerifyCodeApi.h"
#import "RegexTool.h"
#import "MD5Util.h"
@implementation ModifyPswDC


- (void)requestVerifyCode:(NSString *)account WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    if ([RegexTool isMobileNumberClassification:account]) {

        VerifyCodeApi *api = [[VerifyCodeApi alloc]initWithAccount:account usage:USAGE_SETPWD];
        
        [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
            if (success) {
                success([[UTResult alloc]initWithSuccess:successMsg.responseData]);
            }
        } onFailure:^(FailureMsg * _Nonnull message) {
            if (failure) {
                failure([[UTResult alloc]initWithFailure:message.message]);
            }
        }];
        
    }else{
        if (failure) {
            failure([[UTResult alloc]initWithFailure:@"手机号码不正确"]);
        }
    }
}

- (void)requestUpdatePassword:(NSString *)account newPassword:(NSString *)password code:(NSString *)code WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    NSString *encodePsw = [MD5Util md5DigestWithString:password];
    ResetPswApi *api = [[ResetPswApi alloc]initWithPhone:account code:code newPassword:encodePsw];
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        if (success) {
            success(successMsg.responseData);
        }
    } onFailure:^(FailureMsg * _Nonnull message) {
        if (failure) {
            failure([[UTResult alloc]initWithFailure:message.message]);
        }
    }];
}

@end