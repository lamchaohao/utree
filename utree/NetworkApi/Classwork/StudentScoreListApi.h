//
//  StudentScoreListApi.h
//  utree
//
//  Created by 科研部 on 2019/12/10.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface StudentScoreListApi : UTBaseRequest

- (instancetype)initWithClassId:(NSString *)classId examId:(NSString *)examId;

@end

NS_ASSUME_NONNULL_END
