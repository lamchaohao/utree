//
//  NoticeDetailDC.m
//  utree
//
//  Created by 科研部 on 2019/12/2.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "NoticeDetailDC.h"
#import "CheckParentApi.h"
#import "ParentCheckModel.h"
#import "RemindCheckApi.h"
#import "DeleteWorkApi.h"
#import "WorkClassListApi.h"
#import "UTClassModel.h"
#import "SetReadApi.h"
#import "RemindAgainApi.h"

@implementation NoticeDetailDC

-(void)requestParentCheckDetail:(NSString *)noticeId checkStaus:(NSNumber *)isCheck WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    CheckParentApi *api = [[CheckParentApi alloc]initWithNoticeId:noticeId classId:[self getCurrentClassId] isCheck:isCheck];
    
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        
        [ParentCheckModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                       @"parentList" : @"UTParent"
                       // @"list" : [StuDropRecordModel class]
                   };
        }];
        
        NSArray *parentsCheckModels = [ParentCheckModel mj_objectArrayWithKeyValuesArray:successMsg.responseData];
        if (success) {
            success([[UTResult alloc]initWithSuccess:parentsCheckModels]);
        }
    } onFailure:^(FailureMsg * _Nonnull message) {
        if (failure) {
            failure([[UTResult alloc]initWithFailure:message.message]);
        }
    }];
    
}


-(void)requestOneKeyRemind:(NSString *)remindId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    RemindCheckApi *api = [[RemindCheckApi alloc]initWithRemindId:remindId classId:[self getCurrentClassId] from:1];
    
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


- (void)requestDeleteNoticeById:(NSString *)noticeId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    DeleteWorkApi *api = [[DeleteWorkApi alloc]initWithId:noticeId isNotice:YES];
    
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

-(void)requestClassListById:(NSString *)workId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    WorkClassListApi *api = [[WorkClassListApi alloc]initWithWorkId:workId isNotice:YES];
    
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        NSArray *dictArray =  successMsg.responseData;
        NSArray *classArray = [UTClassModel mj_objectArrayWithKeyValuesArray:dictArray];
        if (success) {
            success([[UTResult alloc]initWithSuccess:classArray]);
        }
    } onFailure:^(FailureMsg * _Nonnull message) {
        if (failure) {
            failure([[UTResult alloc]initWithFailure:message.message]);
        }
    }];
}

-(void)setNoticeReadWithWorkId:(NSString *)workId
{
    SetReadApi *api = [[SetReadApi alloc]initWithWorkId:workId type:1];
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        
    } onFailure:^(FailureMsg * _Nonnull message) {
        
    }];
}

- (void)remindStuParentAgain:(NSString *)studentId noticeId:(nonnull NSString *)noticeId
{
    RemindAgainApi *api = [[RemindAgainApi alloc]initWithWorkId:noticeId stuId:studentId workType:1];
    
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        
    } onFailure:^(FailureMsg * _Nonnull message) {
        
    }];
}

@end
