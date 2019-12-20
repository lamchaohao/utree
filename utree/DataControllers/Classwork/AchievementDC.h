//
//  AchievementDC.h
//  utree
//
//  Created by 科研部 on 2019/12/9.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "BaseDataController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AchievementDC : BaseDataController

-(void)requestAchievementListWithLastId:(NSString *)lastId limit:(NSNumber *)limit isMySelf:(BOOL)isMine WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)requestAchievementListWithFirstTimeisMySelf:(BOOL)isMine WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)requestStudentScoreListWithExamId:(NSString *)examId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

@end

NS_ASSUME_NONNULL_END
