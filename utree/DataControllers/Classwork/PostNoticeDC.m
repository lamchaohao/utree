//
//  PostNoticeDC.m
//  utree
//
//  Created by 科研部 on 2019/11/13.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "PostNoticeDC.h"
#import "FetchOSSTokenApi.h"
#import <AliyunOSSiOS/OSSService.h>
#import "OSSService.h"
#import "MD5Util.h"
#import "PostNoticeApi.h"
#import "TeachClassApi.h"
#import "UTClassModel.h"
@interface PostNoticeDC()

@property(nonatomic,strong)OSSFederationToken * token;

@end


@implementation PostNoticeDC



-(void)publishNoticeToServerWithTopic:(NSString *)topic content:(NSString *)cont enclosureDic:(NSDictionary *)dic WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    PostNoticeApi *api= [[PostNoticeApi alloc]initWithTopic:topic content:cont];
    [api setLink: [dic objectForKey:@"link"]];
    [api setPicList:[dic objectForKey:@"pics"]];
    [api setClassIds:[dic objectForKey:@"classIds"]];
    [api setAudioFileObject:[dic objectForKey:@"audio"]];
    [api setReadType: [dic objectForKey:@"readType"]];
    NSNumber * boolNum = dic[@"needReceipt"];
    [api setNeedReceipt:[boolNum boolValue]];
    
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


@end
