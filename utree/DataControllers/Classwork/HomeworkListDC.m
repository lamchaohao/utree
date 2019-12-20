//
//  HomeworkListDC.m
//  utree
//
//  Created by 科研部 on 2019/11/26.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "HomeworkListDC.h"
#import "WrapHomeworkListModel.h"
#import "HomeworkListApi.h"
@implementation HomeworkListDC


-(void)requestHomeworkListFirstTime:(BOOL)isMyData WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    HomeworkListApi *api = [[HomeworkListApi alloc]initWithFirstClassId:[self getCurrentClassId] isMydata:isMyData];
    [self handlerNoticeResult:api WithSuccess:success failure:failure];
}

-(void)requestMoreHomework:(BOOL)isMyData lastId:(NSString *)lastId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    HomeworkListApi *api =[[HomeworkListApi alloc]initWithMoreWithClassId:[self getCurrentClassId] isMydata:isMyData limitNum:[NSNumber numberWithInt:20] lastTaskId:lastId];
    [self handlerNoticeResult:api WithSuccess:success failure:failure];
    
}


-(void)handlerNoticeResult:(HomeworkListApi *)api WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        [WrapHomeworkListModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                       @"list" : @"HomeworkModel"
                       // @"list" : [StuDropRecordModel class]
                   };
        }];
        
        WrapHomeworkListModel *wrapModel = [WrapHomeworkListModel mj_objectWithKeyValues:successMsg.responseData];
        
        for (HomeworkModel *taskModel in wrapModel.list) {
            NSMutableArray *fullPathpicUrlArray = [[NSMutableArray alloc]init];
            for (int i=0; i<taskModel.picList.count; i++)
            {
                NSString *picUrl = taskModel.picList[i];
                [fullPathpicUrlArray addObject:[NSString stringWithFormat:@"%@%@",wrapModel.dPath,picUrl]];
            }
            taskModel.picList = fullPathpicUrlArray;
            
            if (taskModel.video) {
                NSString *snapShot = [taskModel.video.path stringByAppendingString:@"?x-oss-process=video/snapshot,t_1000,f_jpg,w_200,h_200,m_fast"];
                taskModel.video.minPath = snapShot;
            }
            
        }
        
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
