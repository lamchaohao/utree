//
//  MyClassDC.m
//  utree
//
//  Created by 科研部 on 2019/12/6.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "MyClassDC.h"
#import "TeachClassApi.h"
#import "UTClassModel.h"
@implementation MyClassDC

//带领班级
-(void)requestLeadClassListWithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    TeachClassApi *api = [[TeachClassApi alloc]init];
        [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
            NSArray *classArray = [UTClassModel mj_objectArrayWithKeyValuesArray:successMsg.responseData];
            NSMutableArray *leadClasses = [[NSMutableArray alloc]init];
            for (UTClassModel *model in classArray) {
                if(model.headTeacher.boolValue){
                    [leadClasses addObject:model];
                }
            }
            if (success) {
                success([[UTResult alloc]initWithSuccess:leadClasses]);
            }
        } onFailure:^(FailureMsg * _Nonnull message) {
            if (failure) {
                failure([[UTResult alloc]initWithFailure:message.message]);
            }
        }];
}

//任教班级
- (void)requestTeachClassListWithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
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




@end
