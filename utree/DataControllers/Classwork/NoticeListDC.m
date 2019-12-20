//
//  NoticeListDC.m
//  utree
//
//  Created by 科研部 on 2019/11/15.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "NoticeListDC.h"
#import "NoticeListApi.h"
#import "WrapNoticeListModel.h"
#import "NoticeModel.h"
@implementation NoticeListDC


-(void)requestNoticeListFirstTime:(BOOL)isMyData WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    NoticeListApi *api = [[NoticeListApi alloc]initWithFirstClassId:[self getCurrentClassId] isMydata:isMyData];
    [self handlerNoticeResult:api WithSuccess:success failure:failure];
    
}

-(void)requestMoreNotice:(BOOL)isMyData lastId:(NSString *)lastId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    NoticeListApi *api = [[NoticeListApi alloc]initWithMoreWithClassId:[self getCurrentClassId] isMydata:isMyData limitNum:[NSNumber numberWithInt:20] lastNoticeId:lastId];
    [self handlerNoticeResult:api WithSuccess:success failure:failure];
    
}


-(void)handlerNoticeResult:(NoticeListApi *)api WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        [WrapNoticeListModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                       @"list" : @"NoticeModel"
                       // @"list" : [StuDropRecordModel class]
                   };
        }];
        
        WrapNoticeListModel *wrapModel = [WrapNoticeListModel mj_objectWithKeyValues:successMsg.responseData];
        
        for (NoticeModel *notice in wrapModel.list) {
            NSMutableArray *fullPathpicUrlArray = [[NSMutableArray alloc]init];
            for (int i=0; i<notice.picList.count; i++)
            {
                NSString *picUrl = notice.picList[i];
                [fullPathpicUrlArray addObject:[NSString stringWithFormat:@"%@%@",wrapModel.dPath,picUrl]];
            }
            notice.picList = fullPathpicUrlArray;
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
