//
//  NoticeDetailDC.h
//  utree
//
//  Created by 科研部 on 2019/12/2.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "BaseDataController.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeDetailDC : BaseDataController

-(void)requestParentCheckDetail:(NSString *)noticeId checkStaus:(NSNumber *)isCheck WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)requestOneKeyRemind:(NSString *)remindId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)requestDeleteNoticeById:(NSString *)noticeId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)requestClassListById:(NSString *)workId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)setNoticeReadWithWorkId:(NSString *)workId;

-(void)remindStuParentAgain:(NSString*) studentId noticeId:(NSString *)noticeId;

@end

NS_ASSUME_NONNULL_END
