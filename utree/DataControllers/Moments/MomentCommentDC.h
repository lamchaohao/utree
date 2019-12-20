//
//  CommentDC.h
//  utree
//
//  Created by 科研部 on 2019/11/21.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "BaseDataController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MomentCommentDC : BaseDataController

-(void)requestCommentFirstTimeWithId:(NSString *)momentId withSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)requestCommentMoreWithId:(NSString *)momentId lastCommentId:(NSString *)lastId withSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)sendComment:(NSString*)text toMoment:(NSString*)momentId withSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)complainCommentById:(NSString *)commentId andReason:(NSString *)reason WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)deleteCommentById:(NSString *)commentId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

@end

NS_ASSUME_NONNULL_END
