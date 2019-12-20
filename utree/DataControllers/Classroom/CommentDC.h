//
//  CommentDC.h
//  utree
//
//  Created by 科研部 on 2019/11/8.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "BaseDataController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentDC : BaseDataController

-(void)requestCommentToStuId:(NSString *)stuId comment:(NSString *)comment
                 WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(NSArray *)requestCommentList;

-(void)deleteComment:(NSString *)comment;

-(void)addSingleComment:(NSString *)comment;
@end

NS_ASSUME_NONNULL_END
