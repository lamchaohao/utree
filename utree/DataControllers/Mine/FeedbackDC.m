//
//  FeedbackDC.m
//  utree
//
//  Created by 科研部 on 2019/12/26.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "FeedbackDC.h"
#import "FeedbackApi.h"
@implementation FeedbackDC


-(void)submitFeedbackWithContent:(NSString *)content withSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    FeedbackApi *api = [[FeedbackApi alloc]initWithContent:content];
    
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        if (success) {
            success([[UTResult alloc]initWithSuccess:successMsg.responseData]);
        }
    } onFailure:^(FailureMsg * _Nonnull message) {
        if (failure) {
            failure([[UTResult alloc]initWithFailure:message.message]);
        }
    }];
    
}

@end
