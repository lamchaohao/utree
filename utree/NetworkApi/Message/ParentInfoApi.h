//
//  ParentInfoApi.h
//  utree
//
//  Created by 科研部 on 2019/12/19.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface ParentInfoApi : UTBaseRequest

- (instancetype)initWithParentId:(NSString *)parentId;

@end

NS_ASSUME_NONNULL_END
