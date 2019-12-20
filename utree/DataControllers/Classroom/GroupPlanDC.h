//
//  GroupPlanDC.h
//  utree
//
//  Created by 科研部 on 2019/11/1.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "BaseDataController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupPlanDC : BaseDataController

-(void)requestGroupPlanListWithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)requestAddGroupPlanFromName:(NSString *)name WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)editPlanName:(NSString *)name planId:(NSString *)planId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)deletePlanByPlanId:(NSString *)planId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

@end

NS_ASSUME_NONNULL_END
