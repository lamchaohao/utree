//
//  LikeMomentApi.h
//  utree
//
//  Created by 科研部 on 2019/11/20.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface LikeMomentApi : UTBaseRequest
- (instancetype)initWithMomentId:(NSString *)momentId;

@end

NS_ASSUME_NONNULL_END
