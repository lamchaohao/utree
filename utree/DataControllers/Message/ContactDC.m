//
//  ContactDC.m
//  utree
//
//  Created by 科研部 on 2019/12/6.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ContactDC.h"
#import "UTParent.h"
#import "ParentContactApi.h"
#import "TeachClassApi.h"
#import "UTClassModel.h"
#import "ParentInfoApi.h"
@interface ContactDC ()

@end

@implementation ContactDC

-(void)requestParentListByClassId:(NSString *)classId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    
    ParentContactApi *api = [[ParentContactApi alloc]initWithClassId:classId];
    
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        NSArray *dictArray = [successMsg.responseData objectForKey:@"list"];
        NSArray *parentArray =[UTParent mj_objectArrayWithKeyValuesArray:dictArray];
        if (success) {
            success([[UTResult alloc]initWithSuccess:parentArray]);
        }
    } onFailure:^(FailureMsg * _Nonnull message) {
        if (failure) {
            success([[UTResult alloc]initWithFailure:message.message]);
        }
    }];
    
}

-(void)requestClassListWithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    TeachClassApi *api = [[TeachClassApi alloc]init];
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
         NSArray *classArray = [UTClassModel mj_objectArrayWithKeyValuesArray:successMsg.responseData];
        if (success) {
            success([[UTResult alloc]initWithSuccess:classArray]);
        }
    } onFailure:^(FailureMsg * _Nonnull message) {
        if (failure) {
            failure([[UTResult alloc]initWithFailure:message.message]);
        }
    }];
}

-(void)requestParentDataByParentId:(NSString *)parentId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    ParentInfoApi *api = [[ParentInfoApi alloc]initWithParentId:parentId];
    
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        [UTParent mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                       @"studentList" : @"UTStudent"
                       // @"list" : [StuDropRecordModel class]
                   };
        }];
        
        UTParent *parentData = [UTParent mj_objectWithKeyValues:successMsg.responseData];
        if (success) {
            success([[UTResult alloc]initWithSuccess:parentData]);
        }
        
    } onFailure:^(FailureMsg * _Nonnull message) {
        if (failure) {
            failure([[UTResult alloc]initWithFailure:message.message]);
        }
    }];
}

@end
