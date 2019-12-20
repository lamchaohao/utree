//
//  EditGourpPlanApi.h
//  utree
//
//  Created by 科研部 on 2019/11/1.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditGourpPlanApi : UTBaseRequest

- (instancetype)initWithName:(NSString *)groupName classId:(NSString *)clazzId planId:(NSString *)planId;

- (instancetype)initWithName:(NSString *)groupName classId:(NSString *)clazzId;

@end

NS_ASSUME_NONNULL_END
