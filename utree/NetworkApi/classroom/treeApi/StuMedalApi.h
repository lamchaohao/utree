//
//  StuMedalApi.h
//  utree
//
//  Created by 科研部 on 2019/11/7.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface StuMedalApi : UTBaseRequest

- (instancetype)initWithStudentId:(NSString *)stuId;

@end

NS_ASSUME_NONNULL_END
