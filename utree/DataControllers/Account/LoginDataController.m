//
//  LoginDataController.m
//  utree
//
//  Created by 科研部 on 2019/10/28.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "LoginDataController.h"
#import "RegisterApi.h"
#import "LoginApi.h"
#import "SmsLoginApi.h"
#import "RegexTool.h"
#import "UTCache.h"
#import "YTKNetwork.h"
#import "YTKUrlArgumentsFilter.h"
#import "MD5Util.h"
@implementation LoginDataController

#pragma mark 账户登录
-(void)requestPasswordLogin:(NSString *)account password:(NSString *)passwordStr WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failureBlock
{
    if (![RegexTool isMobileNumberClassification:account]) {
        [self.delegate showAlertMessage:@"" title:@"手机号码不正确"];

       return ;
    }
    if (passwordStr.length < 8) {
        [self.delegate showAlertMessage:@"" title:@"密码不能小于8位"];
        return;
    }
      NSString *encodePsw = [MD5Util md5DigestWithString:passwordStr];

    LoginApi *api = [[LoginApi alloc] initWithUsername:account password:encodePsw];
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        if (success) {
            NSString *token = [successMsg.responseData objectForKey:@"token"];
            [UTCache saveToken:token];
            NSDictionary *profile = [successMsg.responseData objectForKey:@"teacherDo"];
            [UTCache savePersonalProfile:profile];
            [self setupRequestFilters:token];
            UTResult *result = [[UTResult alloc]initWithSuccess:successMsg.responseData];
            success(result);
        }
    } onFailure:^(FailureMsg * _Nonnull message) {
        UTResult *result = [[UTResult alloc]initWithFailure:message.message];
        failureBlock(result);
    }];
}

#pragma mark 获取验证码
-(void)requestVerifyCodeForAccount:(NSString *)account usage:(VerifyCodeMethod)method WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{

    if ([RegexTool isMobileNumberClassification:account]) {

        VerifyCodeApi *api = [[VerifyCodeApi alloc] initWithAccount:account usage:method];
        
        [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
            if (success) {
                success([[UTResult alloc]initWithSuccess:successMsg.responseData]);
            }
        } onFailure:^(FailureMsg * _Nonnull message) {
            if([self.delegate respondsToSelector:@selector(showAlertMessage:title:)]){
                [self.delegate showAlertMessage:@"" title:message.message];
            }
        }];
        
    }else{
        if([self.delegate respondsToSelector:@selector(showAlertMessage:title:)]){
            [self.delegate showAlertMessage:@"" title:@"手机号码不正确"];
        }
    }
}

#pragma mark 注册
-(void)requestRegister:(NSString *)account password:(NSString *)passwordStr code:(NSString *)verifyCode WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    
    if (![RegexTool isMobileNumberClassification:account]) {
           [self.delegate showAlertMessage:@"" title:@"手机号码不正确"];
           return ;
       }
       if (passwordStr.length < 8) {
           [self.delegate showAlertMessage:@"" title:@"密码不能小于8位"];
           return;
       }
       if(verifyCode.length<6){
           [self.delegate showAlertMessage:@"" title:@"验证码错误"];
           return;
       }
    NSString *encodePsw = [MD5Util md5DigestWithString:passwordStr];
    RegisterApi *api = [[RegisterApi alloc] initWithUsername:account password:encodePsw code:verifyCode];
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        [self.delegate showAlertMessage:@"" title:@"注册成功"];
    } onFailure:^(FailureMsg * _Nonnull message) {
         [self.delegate showAlertMessage:@"" title:message.message];
    }];
}

//统一为网络请求加上一些参数
- (void)setupRequestFilters:(NSString *)token {
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    [config clearUrlFilter];
    YTKUrlArgumentsFilter *urlFilter = [YTKUrlArgumentsFilter filterWithArguments:@{@"token":token,@"version": appVersion}];
    [config addUrlFilter:urlFilter];
}


@end
