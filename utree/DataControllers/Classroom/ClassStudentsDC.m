//
//  ClassStudentsDC.m
//  utree
//
//  Created by 科研部 on 2019/10/30.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ClassStudentsDC.h"
#import "UTCache.h"
#import "TeachClassApi.h"
#import "UTClassModel.h"
#import "StudentListApi.h"
#import "UTStudent.h"
@implementation ClassStudentsDC

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
            [self fetchStudentListWithSuccess:success failure:failure];
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

-(void)requestStudentListWithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
     if(![UTCache readClassId]){
         [self fetchClassListWithSuccess:success failure:failure];
     }else{
         [self fetchStudentListWithSuccess:success failure:failure];
     }
    
}

-(void)fetchStudentListWithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    NSString *classID = [UTCache readClassId];
    StudentListApi *api = [[StudentListApi alloc]initWithClassId:classID];
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        NSArray *dictArray =  successMsg.responseData;
        NSArray *studentList = [UTStudent mj_objectArrayWithKeyValuesArray:dictArray];
        if (success) {
            success([[UTResult alloc]initWithSuccess:studentList]);
        }
    } onFailure:^(FailureMsg * _Nonnull message) {
        if (failure) {
            failure([[UTResult alloc]initWithFailure:message.message]);
        }
    }];
}


@end
