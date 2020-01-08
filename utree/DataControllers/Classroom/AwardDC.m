//
//  AwardDC.m
//  utree
//
//  Created by 科研部 on 2019/11/11.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "AwardDC.h"
#import "AwardItemsApi.h"
#import "AwardModel.h"
#import "AwardStuApi.h"
#import "UTStudent.h"
#import "UTCache.h"
@implementation AwardDC

-(NSMutableDictionary *)requestAwardItemsFromCache
{
    NSArray *items =[UTCache readAwardItemsJson];
    if (!items) {
        return nil;
    }
    NSArray *awardItems = [AwardModel mj_objectArrayWithKeyValuesArray:items];

    NSMutableDictionary *sortdic = [[NSMutableDictionary alloc]init];
    for (int type=1; type<6; type++) {
        NSMutableArray *sortAwardItems = [[NSMutableArray alloc]init];
        for (AwardModel *model in awardItems) {
            if (model.excitationType.intValue==type) {
                [sortAwardItems addObject:model];
            }
        }
        [sortdic setObject:sortAwardItems forKey:[NSString stringWithFormat:@"%d",type]];
    }
    return sortdic;
}

- (void)requestAwardItemsWithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    AwardItemsApi *api = [[AwardItemsApi alloc]init];
    
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        [UTCache saveAwardItems:successMsg.responseData];
        NSArray *items =[AwardModel mj_objectArrayWithKeyValuesArray:successMsg.responseData];
        NSMutableDictionary *sortdic = [[NSMutableDictionary alloc]init];
        for (int type=1; type<6; type++) {
            NSMutableArray *sortAwardItems = [[NSMutableArray alloc]init];
            for (AwardModel *model in items) {
                if (model.excitationType.intValue==type) {
                    [sortAwardItems addObject:model];
                }
            }
            [sortdic setObject:sortAwardItems forKey:[NSString stringWithFormat:@"%d",type]];
        }
        
        if (success) {
            success([[UTResult alloc]initWithSuccess:sortdic]);
        }
        
    } onFailure:^(FailureMsg * _Nonnull message) {
        if (failure) {
            failure([[UTResult alloc]initWithFailure:message.message]);
        }
    }];
    
}


-(void)requestAwardStudents:(NSArray *)stuList awardId:(NSString *)awardId  WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    NSString *idListStr = @"";
    for (int i=0; i<stuList.count;i++) {
        UTStudent *student = [stuList objectAtIndex:i];
        idListStr = [idListStr stringByAppendingString:student.studentId];
        if (i!=(stuList.count-1)) {
            idListStr = [idListStr stringByAppendingString:@","];
        }
    }
    AwardStuApi *api = [[AwardStuApi alloc]initWithStuList:idListStr awardId:awardId classId:[self getCurrentClassId]];
    
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

-(void)requestAwardGroupId:(NSString *)groupId awardId:(NSString *)awardId  WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    AwardStuApi *api = [[AwardStuApi alloc]initWithGroup:groupId awardId:awardId classId:[self getCurrentClassId]];
    
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
