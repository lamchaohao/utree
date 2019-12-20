//
//  SubmitCommentApi.h
//  utree
//
//  Created by 科研部 on 2019/11/21.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SubmitCommentApi : UTBaseRequest

- (instancetype)initWithMomentId:(NSString *)circleId comment:(NSString *)text;

@end

NS_ASSUME_NONNULL_END