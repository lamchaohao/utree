//
//  AwardDC.h
//  utree
//
//  Created by 科研部 on 2019/11/11.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "BaseDataController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AwardDC : BaseDataController

-(void)requestAwardItemsWithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)requestAwardGroupId:(NSString *)groupId awardId:(NSString *)awardId  WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)requestAwardStudents:(NSArray *)stuList awardId:(NSString *)awardId  WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

@end

NS_ASSUME_NONNULL_END
