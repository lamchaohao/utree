//
//  StudentTreeApi.h
//  utree
//
//  Created by 科研部 on 2019/11/6.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface StudentTreeApi : UTBaseRequest

- (instancetype)initWithStudentId:(NSString *)studentId;

@end

NS_ASSUME_NONNULL_END
