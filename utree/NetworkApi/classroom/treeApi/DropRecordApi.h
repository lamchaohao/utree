//
//  DropRecordApi.h
//  utree
//
//  Created by 科研部 on 2019/11/7.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface DropRecordApi : UTBaseRequest

- (instancetype)initWithStuId:(NSString *)stuId dateZone:(NSNumber *)num lastDropId:(NSString *)dropId limit:(NSNumber *)limit;

- (instancetype)initWithStuId:(NSString *)stuId dateZone:(NSNumber *)num limit:(NSNumber *)limit;

@end

NS_ASSUME_NONNULL_END
