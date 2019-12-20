//
//  GroupPlanDC.m
//  utree
//
//  Created by 科研部 on 2019/11/1.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "GroupPlanDC.h"
#import "GroupPlanListApi.h"
#import "TeachClassApi.h"
#import "GroupPlanModel.h"
#import "UTClassModel.h"
#import "UTCache.h"
#import "EditGourpPlanApi.h"
#import "DeletePlanApi.h"
@implementation GroupPlanDC

-(void)requestGroupPlanListWithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    if (![UTCache readClassId]) {
        [self fetchClassListWithSuccess:success failure:failure];
    }else{
        [self fetchGroupPlanListWithSuccess:success failure:failure];
    }
    
}
#pragma mark 添加方案
-(void)requestAddGroupPlanFromName:(NSString *)name WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    EditGourpPlanApi *api = [[EditGourpPlanApi alloc]initWithName:name classId:[UTCache readClassId]];
    
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        if (success) {
            success([[UTResult alloc]initWithSuccess:@"创建成功"]);
        }
    } onFailure:^(FailureMsg * _Nonnull message) {
        if (failure) {
            failure([[UTResult alloc]initWithFailure:message.message]);
        }
    }];
    
}
#pragma mark 编辑方案名
-(void)editPlanName:(NSString *)name planId:(NSString *)planId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    EditGourpPlanApi *api = [[EditGourpPlanApi alloc]initWithName:name classId:[UTCache readClassId] planId:planId];
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

-(void)deletePlanByPlanId:(NSString *)planId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    DeletePlanApi *api = [[DeletePlanApi alloc]initWithPlanId:planId];
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

#pragma mark 根据班级id获取方案列表
-(void)fetchGroupPlanListWithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    GroupPlanListApi *api = [[GroupPlanListApi alloc]initWithClassId:[UTCache readClassId]];
    
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        NSArray *dictArray =  successMsg.responseData;
        [GroupPlanModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                @"planId":@"id",
                @"planName":@"name"
            };
        }];
        NSArray *planList = [GroupPlanModel mj_objectArrayWithKeyValuesArray:dictArray];
        [self savePlanDic:planList];
        if (success) {
            success([[UTResult alloc]initWithSuccess:planList]);
        }
    } onFailure:^(FailureMsg * _Nonnull message) {
        if(failure){
            failure([[UTResult alloc]initWithFailure:message.message]);
        }
    }];
    
}
#pragma mark 获取班级id信息
-(void)fetchClassListWithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    TeachClassApi *api = [[TeachClassApi alloc]init];
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        NSArray *dictArray =  successMsg.responseData;
        NSArray *classArray = [UTClassModel mj_objectArrayWithKeyValuesArray:dictArray];
        if(classArray.count>0){
            //如果之前没有选择班级,则需保存一个班级
            if(![UTCache readClassId]){
                UTClassModel *cOne = classArray[0];
                [UTCache saveClassId:cOne.classId className:cOne.className];
                
            }else{
                NSString *theSavedId= [UTCache readClassId];
                BOOL needToResave=YES;
                for (UTClassModel *clazz in classArray) {
                    //所保存的Id依旧有效,则不需要重新保存
                    if([clazz.classId isEqualToString:theSavedId])
                    {
                        needToResave = NO;
                    }
                }
                if(needToResave)
                {
                    UTClassModel *cOne = classArray[0];
                    [UTCache saveClassId:cOne.classId className:cOne.className];
                }
            }
            [self fetchGroupPlanListWithSuccess:success failure:failure];
        }else{
            //没有班级返回请求错误
           if(failure)
           {
               failure([[UTResult alloc]initWithFailure:@"没有班级"]);
           }
        }
    } onFailure:^(FailureMsg * _Nonnull message) {
        if(failure)
        {
            failure([[UTResult alloc]initWithFailure:message.message]);
        }
    }];
}

-(void)savePlanDic:(NSArray *)planList
{
    //如果没有,默认保存第一个方案
    if (![UTCache readGroupPlanCache]) {
        if (planList.count>0) {
            GroupPlanModel *model = [planList objectAtIndex:0];
            [UTCache saveGroupPlanId:model.planId planName:model.planName];
        }
        
    }else{//如果已经有保存,则更新数据
        if (planList.count>0) {
            NSDictionary *dic = [UTCache readGroupPlanCache];
            BOOL hasUpdate = NO;
            for (GroupPlanModel *model in planList) {
                if([model.planId isEqualToString:[dic objectForKey:@"groupPlanId"]])
                {
                    [UTCache saveGroupPlanId:model.planId planName:model.planName];
                    hasUpdate = YES;
                }
            }
            //如果删除了之前的，默认保存第一个
            if (!hasUpdate) {
                GroupPlanModel *model = [planList objectAtIndex:0];
                [UTCache saveGroupPlanId:model.planId planName:model.planName];
            }
        }
    }
    
}

@end
