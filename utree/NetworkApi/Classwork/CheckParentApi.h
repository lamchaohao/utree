//
//  CheckParentApi.h
//  utree
//
//  Created by 科研部 on 2019/12/2.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface CheckParentApi : UTBaseRequest

- (instancetype)initWithNoticeId:(NSString *)noticeId classId:(NSString *)classId isCheck:(NSNumber *)isCheck;

@end

NS_ASSUME_NONNULL_END
