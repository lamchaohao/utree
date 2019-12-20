//
//  CommentDC.m
//  utree
//
//  Created by 科研部 on 2019/11/21.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "MomentCommentDC.h"
#import "CommentListApi.h"
#import "WrapCommentListModel.h"
#import "CommentModel.h"
#import "SubmitCommentApi.h"
#import "DeleteCommentApi.h"
#import "ComplainComentApi.h"
@implementation MomentCommentDC

-(void)requestCommentFirstTimeWithId:(NSString *)momentId withSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    CommentListApi *api = [[CommentListApi alloc]initWithFirstTime:momentId limit:[NSNumber numberWithLong:20]];
    
    [self handleCommentResult:api andSuccess:success failure:failure];
    
}

-(void)requestCommentMoreWithId:(NSString *)momentId lastCommentId:(NSString *)lastId withSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    CommentListApi *api = [[CommentListApi alloc]initWithMore:momentId limit:[NSNumber numberWithLong:20] lastId:lastId];
    
    [self handleCommentResult:api andSuccess:success failure:failure];
}



-(void)handleCommentResult:(CommentListApi *)api andSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        
        [WrapCommentListModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                       @"list" : @"CommentModel"
                       // @"list" : [StuDropRecordModel class]
                   };
        }];
        
        WrapCommentListModel *wrapModel = [WrapCommentListModel mj_objectWithKeyValues:successMsg.responseData];
        
        if (success) {
            success([[UTResult alloc]initWithSuccess:wrapModel]);
        }
    
    } onFailure:^(FailureMsg * _Nonnull message) {
        if (failure) {
            failure([[UTResult alloc]initWithFailure:message.message]);
        }
    }];
}

- (void)sendComment:(NSString *)text toMoment:(NSString *)momentId withSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    SubmitCommentApi *api = [[SubmitCommentApi alloc]initWithMomentId:momentId comment:text];
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

-(void)deleteCommentById:(NSString *)commentId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    DeleteCommentApi *api = [[DeleteCommentApi alloc]initWithCommentId:commentId];
    [self handleRequestResultWithApi:api WithSuccess:success failure:failure];
}


-(void)complainCommentById:(NSString *)commentId andReason:(NSString *)reason WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    ComplainComentApi *api = [[ComplainComentApi alloc]initWithCommentId:commentId andReason:reason];
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
