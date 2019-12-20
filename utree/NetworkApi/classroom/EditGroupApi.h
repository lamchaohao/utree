//
//  EditGroupApi.h
//  utree
//
//  Created by 科研部 on 2019/11/4.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditGroupApi : UTBaseRequest

- (instancetype)initWithPlanId:(NSString *)planId gName:(NSString *)name idList:(NSArray *)stuList;

- (instancetype)initWithPlanId:(NSString *)planId groupId:(NSString *)groupId idList:(NSArray *)stuList;

- (instancetype)initWithRename:(NSString *)gName groupId:(NSString *)groupId planId:(NSString *)planId idList:(NSArray *)stuList;
@end

NS_ASSUME_NONNULL_END
