//
//  NotificationDC.m
//  utree
//
//  Created by 科研部 on 2019/12/24.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "NotificationDC.h"
#import "MessageInfoApi.h"
#import "WrapNoticeMsgModel.h"
@implementation NotificationDC


-(void)requestFirstNotification:(BOOL)isSystemNotice WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    MessageInfoApi *api = [[MessageInfoApi alloc]initWithFirst:[NSNumber numberWithBool:isSystemNotice]];
    [self handleResultWith:api successCallback:success failure:failure];
    
}

-(void)requestMoreNotice:(BOOL)isSystemNotice lastId:(NSString *)lastId limit:(int)limit WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    MessageInfoApi *api = [[MessageInfoApi alloc]initWithMore:[NSNumber numberWithBool:isSystemNotice] lastId:lastId limit:[NSNumber numberWithInt:limit]];
    [self handleResultWith:api successCallback:success failure:failure];
}

-(void)handleResultWith:(MessageInfoApi *)api successCallback:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        [WrapNoticeMsgModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                       @"list" : @"NoticeMessageModel"
                   };
        }];
        
        WrapNoticeMsgModel *wrapModel = [WrapNoticeMsgModel mj_objectWithKeyValues:successMsg.responseData];
        if (success) {
            success([[UTResult alloc]initWithSuccess:wrapModel]);
        }
    } onFailure:^(FailureMsg * _Nonnull message) {
        if (failure) {
            failure([[UTResult alloc]initWithFailure:message.message]);
        }
    }];
}


@end
