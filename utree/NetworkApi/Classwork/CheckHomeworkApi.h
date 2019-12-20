//
//  CheckHomeworkApi.h
//  utree
//
//  Created by 科研部 on 2019/12/3.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface CheckHomeworkApi : UTBaseRequest
- (instancetype)initWithWorkId:(NSString *)workId classId:(NSString *)classId isCheck:(NSNumber *)isCheck;

@end

NS_ASSUME_NONNULL_END
