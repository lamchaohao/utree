//
//  CommentDC.m
//  utree
//
//  Created by 科研部 on 2019/11/8.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "CommentDC.h"
#import "CommentStuApi.h"
#import "UTCache.h"
@implementation CommentDC


-(void)requestCommentToStuId:(NSString *)stuId comment:(NSString *)comment
 WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    CommentStuApi *api = [[CommentStuApi alloc]initWithStuId:stuId commentText:comment];
    
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

-(NSArray *)requestCommentList
{
    return [UTCache readComments];
}

-(void)deleteComment:(NSString *)comment
{
    NSArray *store = [UTCache readComments];
    NSMutableArray *commentList = [[NSMutableArray alloc]initWithArray:store];
    [commentList removeObject:comment];
    [UTCache saveComments:commentList];
}

-(void)addSingleComment:(NSString *)comment
{
    NSArray *store = [UTCache readComments];
    NSMutableArray *comments = [[NSMutableArray alloc]initWithArray:store];
    [comments addObject:comment];
    [UTCache saveComments:comments];
}


@end
