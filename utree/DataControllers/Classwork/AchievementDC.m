//
//  AchievementDC.m
//  utree
//
//  Created by 科研部 on 2019/12/9.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "AchievementDC.h"
#import "AchievementListApi.h"
#import "WrapAchievementModel.h"
#import "StudentScoreListApi.h"
#import "ScoreModel.h"

@implementation AchievementDC

-(void)requestAchievementListWithLastId:(NSString *)lastId limit:(NSNumber *)limit isMySelf:(BOOL)isMine WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    AchievementListApi *api = [[AchievementListApi alloc]initWithMoreClassId:[self getCurrentClassId] isMine:isMine limit:limit lastId:lastId];
    
     [self handleApi:api WithSuccess:success failure:failure];
}

-(void)requestAchievementListWithFirstTimeisMySelf:(BOOL)isMine WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    AchievementListApi *api = [[AchievementListApi alloc]initWithFirstTimeClassId:[self getCurrentClassId] isMine:isMine];
    [self handleApi:api WithSuccess:success failure:failure];
}

-(void)handleApi:(AchievementListApi *)api WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        [WrapAchievementModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                       @"list" : @"AchievementModel",
                       @"scoreList":[ScoreModel class]
                   };
        }];
        
        WrapAchievementModel *wrapModel = [WrapAchievementModel mj_objectWithKeyValues:successMsg.responseData];
        if (success) {
            success([[UTResult alloc]initWithSuccess:wrapModel]);
        }
    } onFailure:^(FailureMsg * _Nonnull message) {
        if (failure) {
            failure([[UTResult alloc]initWithFailure:message.message]);
        }
    }];
}

-(void)requestStudentScoreListWithExamId:(NSString *)examId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    StudentScoreListApi *api = [[StudentScoreListApi alloc]initWithClassId:[self getCurrentClassId] examId:examId];
    
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        NSArray *scores = [ScoreModel mj_objectArrayWithKeyValuesArray:[successMsg.responseData objectForKey:@"list"]];
        if (success) {
            success([[UTResult alloc]initWithSuccess:scores]);
        }
    } onFailure:^(FailureMsg * _Nonnull message) {
        if (failure) {
            failure([[UTResult alloc]initWithFailure:message.message]);
        }
    }];
    
}

@end
