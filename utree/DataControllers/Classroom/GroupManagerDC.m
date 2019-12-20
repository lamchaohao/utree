//
//  GroupManagerDC.m
//  utree
//
//  Created by 科研部 on 2019/11/4.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "GroupManagerDC.h"
#import "GroupListApi.h"
#import "GroupModel.h"
#import "EditGroupApi.h"
#import "GroupStudentsApi.h"
#import "StuGMemberModel.h"
#import "DeleteStuGroupApi.h"
#import "GroupDetailByIdApi.h"
@interface GroupManagerDC()
@property(nonatomic,strong)NSMutableArray *studentsInsort;
@property(nonatomic,strong)NSMutableArray *groupTitleList;
@end

@implementation GroupManagerDC

#pragma mark 根据planId获取小组列表
-(void)requestGroupListByClassId:(NSString *)classId planId:(NSString *)planId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    if ([self isBlankString:classId]||[self isBlankString:planId]) {
        if (failure) {
            failure([[UTResult alloc]initWithFailure:@"请选择班级方案"]);
        }
        return;
    }
    GroupListApi *api = [[GroupListApi alloc]initWithClassId:classId planId:planId];
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        [GroupModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"studentDos":@"UTStudent"};
        }];
        NSArray<GroupModel *> *groupList = [GroupModel mj_objectArrayWithKeyValuesArray:successMsg.responseData];
        
        if (success) {
            success([[UTResult alloc] initWithSuccess:groupList]);
        }
    } onFailure:^(FailureMsg * _Nonnull message) {
        if (failure) {
            failure([[UTResult alloc]initWithFailure:message.message]);
        }
    }];
}

#pragma mark 新建小组
-(void)requestAddGroupByName:(NSString *)groupName planId:(NSString *)planId studentList:(NSArray *)stuIdList WithSuccess:(UTRequestCompletionBlock)success  failure:(UTRequestCompletionBlock)failure
{
    NSMutableArray *idList = [[NSMutableArray alloc]init];
    for (StuGMemberModel *stu in stuIdList) {
        [idList addObject:stu.studentId];
    }
    EditGroupApi *api = [[EditGroupApi alloc]initWithPlanId:planId gName:groupName idList:idList];
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

#pragma mark 编辑小组
-(void)requestEditGroupById:(NSString *)groupId  planId:(NSString *)planId studentList:(NSArray *)stuIdList WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    NSMutableArray *idList = [[NSMutableArray alloc]init];
    for (StuGMemberModel *stu in stuIdList) {
        [idList addObject:stu.studentId];
    }
    EditGroupApi *api =[[EditGroupApi alloc]initWithPlanId:planId groupId:groupId idList:idList];
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

#pragma mark 小组改名
-(void)requestRenameGroupById:(NSString *)groupId groupName:(NSString *)gName planId:(NSString *)planId studentList:(NSArray *)stuIdList WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    NSMutableArray *idList = [[NSMutableArray alloc]init];
    for (StuGMemberModel *stu in stuIdList) {
        [idList addObject:stu.studentId];
    }
    EditGroupApi *api = [[EditGroupApi alloc]initWithRename:gName groupId:groupId planId:planId idList:idList];
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

#pragma mark 请求学生列表，带分组信息的
-(void)requestStudentListInGroup:(NSString *)classId planId:(NSString *)planId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    GroupStudentsApi *api = [[GroupStudentsApi alloc]initWithClassId:classId planId:planId];
    
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        NSArray *students =[StuGMemberModel mj_objectArrayWithKeyValuesArray:successMsg.responseData];
            self.studentsInsort = [[NSMutableArray alloc]init];
            self.groupTitleList = [[NSMutableArray alloc]init];
            for (StuGMemberModel *student in students) {
                if ([self isBlankString:student.groupName]) {
                    student.groupName = @"未分组";
                    student.selectMode = 2;
                }
                //获取分组名list
                if(![self.groupTitleList containsObject:student.groupName]){
                  [self.groupTitleList addObject:student.groupName];
                }
             }
        //将学生按组名进行分组
        for (NSString *groupName in self.groupTitleList) {
            NSMutableArray *partStudents = [[NSMutableArray alloc]init];
            for (StuGMemberModel *student in students) {
                if ([groupName isEqualToString:student.groupName]) {
                    [partStudents addObject:student];
                }
            }
            [self.studentsInsort addObject:partStudents];
        }
   
        NSArray *resultKeys = [NSArray arrayWithObjects:@"titles",@"studentsInSort", nil];
        NSArray *resultValues= [NSArray arrayWithObjects:self.groupTitleList,self.studentsInsort, nil];
//        将结果包装成字典返回
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:resultValues forKeys:resultKeys];
        if (success) {
            success([[UTResult alloc]initWithSuccess:dic]);
        }
        
    } onFailure:^(FailureMsg * _Nonnull message) {
        if (failure) {
            failure([[UTResult alloc]initWithFailure:message.message]);
        }
    }];
    
}

#pragma mark 删除小组
-(void)deleteGroupById:(NSString *)groupId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    DeleteStuGroupApi *api = [[DeleteStuGroupApi alloc]initWithGroupId:groupId];
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

#pragma mark 根据groupID获取小组详情
-(void)requestGroupDetailById:(NSString *)groupId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    GroupDetailByIdApi *api = [[GroupDetailByIdApi alloc]initWithGroupId:groupId clazzId:[self getCurrentClassId]];
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        GroupModel *model = [GroupModel mj_objectWithKeyValues:successMsg.responseData];
        if (success) {
            success([[UTResult alloc]initWithSuccess:model]);
        }
    } onFailure:^(FailureMsg * _Nonnull message) {
        if (failure) {
            failure([[UTResult alloc]initWithFailure:message.message]);
        }
    }];
}


@end
