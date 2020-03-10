//
//  HomeworkDetailDC.m
//  utree
//
//  Created by 科研部 on 2019/12/3.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "HomeworkDetailDC.h"
#import "CheckHomeworkApi.h"
#import "ParentCheckModel.h"
#import "RemindCheckApi.h"
#import "DeleteWorkApi.h"
#import "WorkClassListApi.h"
#import "UTClassModel.h"
#import "SetReadApi.h"
#import "RemindAgainApi.h"

@implementation HomeworkDetailDC


-(void)requestHomeworkCheckDetail:(NSString *)workId checkStaus:(NSNumber *)isCheck WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    CheckHomeworkApi *api = [[CheckHomeworkApi alloc]initWithWorkId:workId classId:[self getCurrentClassId] isCheck:isCheck];
    
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
    RemindCheckApi *api = [[RemindCheckApi alloc]initWithRemindId:remindId classId:[self getCurrentClassId] from:2];
    
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


- (void)requestDeleteTaskById:(NSString *)workId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    DeleteWorkApi *api = [[DeleteWorkApi alloc]initWithId:workId isNotice:NO];
    
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
    WorkClassListApi *api = [[WorkClassListApi alloc]initWithWorkId:workId isNotice:NO];
    
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

- (void)setTaskReadWithWorkId:(NSString *)workId
{
    SetReadApi *api = [[SetReadApi alloc]initWithWorkId:workId type:2];
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        
    } onFailure:^(FailureMsg * _Nonnull message) {
        
    }];
}

- (void)workRemindStuParentAgain:(NSString *)studentId taskId:(nonnull NSString *)taskId
{
    RemindAgainApi *api = [[RemindAgainApi alloc]initWithWorkId:taskId stuId:studentId workType:2];
    
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        
    } onFailure:^(FailureMsg * _Nonnull message) {
        
    }];
}

@end
