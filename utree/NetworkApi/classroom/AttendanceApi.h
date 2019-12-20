//
//  AttendanceApi.h
//  utree
//
//  Created by 科研部 on 2019/10/31.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface AttendanceApi : UTBaseRequest

- (instancetype)initWithClassId:(NSString *)clazzId;

@end

NS_ASSUME_NONNULL_END
