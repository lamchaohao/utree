//
//  HomeworkDetailDC.h
//  utree
//
//  Created by 科研部 on 2019/12/3.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "BaseDataController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeworkDetailDC : BaseDataController

-(void)requestHomeworkCheckDetail:(NSString *)workId checkStaus:(NSNumber *)isCheck WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)requestOneKeyRemind:(NSString *)remindId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

- (void)requestDeleteTaskById:(NSString *)workId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)requestClassListById:(NSString *)workId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

@end

NS_ASSUME_NONNULL_END
