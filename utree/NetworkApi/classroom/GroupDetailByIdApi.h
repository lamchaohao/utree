//
//  GroupDetailByIdApi.h
//  utree
//
//  Created by 科研部 on 2019/11/5.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupDetailByIdApi : UTBaseRequest

- (instancetype)initWithGroupId:(NSString *)groupId clazzId:(NSString *)clazzId;

@end

NS_ASSUME_NONNULL_END
