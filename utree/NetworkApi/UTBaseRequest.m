//
//  UTBaseRequest.m
//  utree
//
//  Created by 科研部 on 2019/10/24.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTBaseRequest.h"
#import "MMAlertView.h"
#import "AppDelegate.h"
@implementation UTBaseRequest

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (void)startWithValidateBlock:(OnResponseBlock)successBlock onFailure:(OnFailureBlock)onFail
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *response = [request responseObject];
        NSLog(@"responseJson = %@", response);
        if(request.response.statusCode==200){
            NSNumber *code = [response objectForKey:@"code"];
            //先进行一次校验
            switch (code.intValue) {
                case 10000:
                    if (successBlock) {
                        id result = [response objectForKey:@"result"];
                        if (result==nil) {
                            result =[response objectForKey:@"msg"];
                        }
                        successBlock([[SuccessMsg alloc]initWithResponseData:result]);
                    }
                    break;
                case 11002:
                    [self reLogin];
                    break;
                default:
                {
                    NSString *reason =  [response objectForKey:@"result"];
                    NSLog(@"reason-%@",reason);
                    if ([self isBlankString:reason]) {
                        reason =[response objectForKey:@"msg"];
                    }
                    if (onFail) {
                       onFail([[FailureMsg alloc]initWithMessage:reason]);
                    }
                }
                    break;
            }
             
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"statusCode=%ld,str=%@",request.responseStatusCode,request.responseString);
        if (onFail) {
            onFail([[FailureMsg alloc]initWithMessage:@"网络暂时出了问题哦,请重试"]);
        }
    }];
}

-(void)reLogin
{
    MMAlertView *alertView = [[MMAlertView alloc]initWithConfirmTitle:@"登录过期" detail:@"请重新登录"];
    [alertView showWithBlock:^(MMPopupView *view, BOOL show) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate toLoginVC];
    }];
}

- (BOOL)isBlankString:(NSString *)str {
    NSString *string = str;
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    
    return NO;
}

@end
