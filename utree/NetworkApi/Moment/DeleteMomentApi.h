//
//  DeleteMomentApi.h
//  utree
//
//  Created by 科研部 on 2019/11/26.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeleteMomentApi : UTBaseRequest

- (instancetype)initWithMomentId:(NSString *)circleId;

@end

NS_ASSUME_NONNULL_END