//
//  GroupListApi.h
//  utree
//
//  Created by 科研部 on 2019/11/4.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupListApi : UTBaseRequest
- (instancetype)initWithClassId:(NSString *)classid planId:(NSString *)planid;
@end

NS_ASSUME_NONNULL_END
