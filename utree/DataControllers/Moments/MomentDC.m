//
//  MomentDC.m
//  utree
//
//  Created by 科研部 on 2019/11/20.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "MomentDC.h"
#import "MomentListApi.h"
#import "MomentModel.h"
#import "WrapMomentListModel.h"
#import "LikeMomentApi.h"
#import "PostMomentApi.h"
#import "DeleteMomentApi.h"

@implementation MomentDC


-(void)requestFirstTimeList:(BOOL)mySelfData limitItems:(NSNumber *)limit WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    MomentListApi *api = [[MomentListApi alloc]initWithFirstTime:mySelfData limit:limit];
    [self handleMomentResultWithAPI:api andSuccess:success failure:failure];
    
}

-(void)requestMoreMoments:(BOOL)mySelfData limitItems:(NSNumber *)limit lastId:(NSString *)lastId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    MomentListApi *api = [[MomentListApi alloc]initWithMore:mySelfData limit:limit lastId:lastId];
    
    [self handleMomentResultWithAPI:api andSuccess:success failure:failure];
    
}

-(void)handleMomentResultWithAPI:(MomentListApi *)api andSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        
        [WrapMomentListModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                       @"list" : @"MomentModel"
                       // @"list" : [StuDropRecordModel class]
                   };
        }];
        
        WrapMomentListModel *wrapModel = [WrapMomentListModel mj_objectWithKeyValues:successMsg.responseData];
        
        for (MomentModel *moment in wrapModel.list) {
            NSMutableArray *fullPathpicUrlArray = [[NSMutableArray alloc]init];
            for (int i=0; i<moment.picList.count; i++)
            {
                NSString *picUrl = moment.picList[i];
                [fullPathpicUrlArray addObject:[NSString stringWithFormat:@"%@%@",wrapModel.dPath,picUrl]];
            }
            moment.picList = [NSArray arrayWithArray:fullPathpicUrlArray];
            if (moment.video) {
                NSString *snapShot = [moment.video.path stringByAppendingString:@"?x-oss-process=video/snapshot,t_1000,f_jpg,w_0,h_0,m_fast"];
                
                moment.video.minPath = snapShot;
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


- (void)requestLikeMoment:(NSString *)momentId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    LikeMomentApi *api = [[LikeMomentApi alloc]initWithMomentId:momentId];
    
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


-(void)postMomentWith:(NSString *)textContent pictures:(NSArray *)pictures WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    PostMomentApi *api = [[PostMomentApi alloc]initWithPictures:pictures contents:textContent];
    
    [self handlePostMomentResult:api WithSuccess:success failure:failure];
    
}


-(void)postMomentWith:(NSString *)textContent video:(FileObject *)videoFile WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    PostMomentApi *api = [[PostMomentApi alloc]initWithVideo:videoFile contents:textContent];
    [self handlePostMomentResult:api WithSuccess:success failure:failure];
}

-(void)postMomentWithText:(NSString *)textContent WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    PostMomentApi *api = [[PostMomentApi alloc]initWithText:textContent];
    [self handlePostMomentResult:api WithSuccess:success failure:failure];
}

-(void)handlePostMomentResult:(PostMomentApi *)api WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
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


-(void)deleteMomentById:(NSString *)momentId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    DeleteMomentApi *api = [[DeleteMomentApi alloc]initWithMomentId:momentId];
    
    [self handleRequestResultWithApi:api WithSuccess:success failure:failure];
    
}



-(void)handleRequestResultWithApi:(UTBaseRequest *)api WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
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
