//
//  GroupStudentsApi.h
//  utree
//
//  Created by 科研部 on 2019/11/4.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupStudentsApi : UTBaseRequest

- (instancetype)initWithClassId:(NSString *)classId planId:(NSString *)planId;

@end

NS_ASSUME_NONNULL_END
