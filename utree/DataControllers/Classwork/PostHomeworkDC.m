//
//  PostHomeworkDC.m
//  utree
//
//  Created by 科研部 on 2019/11/27.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "PostHomeworkDC.h"
#import "PostHomeworkApi.h"
#import "SubjectsInClassApi.h"
@implementation PostHomeworkDC


-(void)requestClassAndSubjectsWithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    SubjectsInClassApi *api = [[SubjectsInClassApi alloc]init];
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        if(success)
        {
            success([[UTResult alloc]initWithSuccess:successMsg.responseData]);
        }
    } onFailure:^(FailureMsg * _Nonnull message) {
        if (failure) {
            failure([[UTResult alloc]initWithFailure:message.message]);
        }
    }];
    
}


-(void)publishTaskToServerWithTopic:(NSString *)topic content:(NSString *)cont enclosureDic:(NSDictionary *)dic WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    PostHomeworkApi *api= [[PostHomeworkApi alloc]initWithTopic:topic content:cont];
    [api setLink: [dic objectForKey:@"link"]];
    [api setPicList:[dic objectForKey:@"pics"]];
    [api setClassIds:[dic objectForKey:@"classIds"]];
    [api setSubjectId:[dic objectForKey:@"subjectId"]];
    [api setAudioFileObject:[dic objectForKey:@"audio"]];
    [api setVideoFileObject:[dic objectForKey:@"video"]];
    [api setDeadLine:[dic objectForKey:@"deadline"]];
    NSNumber * boolNum = dic[@"onlineSubmit"];
    [api setOnlineSubmit:[boolNum boolValue]];
    
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
