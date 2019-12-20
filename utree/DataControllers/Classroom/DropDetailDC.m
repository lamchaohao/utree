//
//  DropDetailDC.m
//  utree
//
//  Created by 科研部 on 2019/11/6.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "DropDetailDC.h"
#import "StudentTreeApi.h"
#import "StuTreeModel.h"
#import "StuMedalApi.h"
#import "StuMedalModel.h"
#import "StuDropRecordModel.h"
#import "WrapDropRecordModel.h"
#import "DropRecordApi.h"
@implementation DropDetailDC


-(void)requestStudentTreeData:(NSString *)stuId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    StudentTreeApi *api = [[StudentTreeApi alloc]initWithStudentId:stuId];
        
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        StuTreeModel *stuTree = [StuTreeModel mj_objectWithKeyValues:successMsg.responseData];
        if (success) {
            success([[UTResult alloc]initWithSuccess:stuTree]);
        }
    } onFailure:^(FailureMsg * _Nonnull message) {
        if (failure) {
            failure([[UTResult alloc]initWithSuccess:message.message]);
        }
    }];
    
}

-(void)requestMedalData:(NSString *)studentId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    StuMedalApi *api = [[StuMedalApi alloc]initWithStudentId:studentId];
    
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        
        NSArray *medalList = [StuMedalModel mj_objectArrayWithKeyValuesArray:successMsg.responseData];
        
        if (success) {
            success([[UTResult alloc]initWithSuccess:medalList]);
        }
        
    } onFailure:^(FailureMsg * _Nonnull message) {
        
        if (failure) {
            failure([[UTResult alloc]initWithFailure:message.message]);
        }
        
    }];
    
}
#pragma mark 获取水滴记录
-(void)requestDropRecordFirst:(NSString *)stuId dateZone:(NSNumber *)dateType WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    DropRecordApi *api = [[DropRecordApi alloc]initWithStuId:stuId dateZone:dateType limit:[NSNumber numberWithInt:30]];
    
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {

        [WrapDropRecordModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                       @"list" : @"StuDropRecordModel"
                       // @"list" : [StuDropRecordModel class]
                   };
        }];
        [StuDropRecordModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                       @"recordDescription" : @"description"
                   };
        }];
        WrapDropRecordModel *wrapModel = [WrapDropRecordModel mj_objectWithKeyValues:successMsg.responseData];
        
        if (success) {
            success([[UTResult alloc]initWithSuccess:wrapModel]);
        }
        
    } onFailure:^(FailureMsg * _Nonnull message) {
        if (failure) {
            failure([[UTResult alloc]initWithFailure:message.message]);
        }
    }];
}

-(void)requestMoreDropRecordWithStuId:(NSString *)stuId dateZone:(NSNumber *)dateType lastDropId:(NSString *)dropId limit:(NSNumber *)limit WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    DropRecordApi *api = [[DropRecordApi alloc]initWithStuId:stuId dateZone:dateType lastDropId:dropId limit:limit];
    
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {

        [WrapDropRecordModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                       @"list" : @"StuDropRecordModel"
                       // @"list" : [StuDropRecordModel class]
                   };
        }];
        [StuDropRecordModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                       @"recordDescription" : @"description"
                   };
        }];
        
        WrapDropRecordModel *wrapModel = [WrapDropRecordModel mj_objectWithKeyValues:successMsg.responseData];
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
