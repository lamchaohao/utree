//
//  AwardStuApi.h
//  utree
//
//  Created by 科研部 on 2019/11/12.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UTBaseRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface AwardStuApi : UTBaseRequest

- (instancetype)initWithStuList:(NSString *)stuIds awardId:(NSString *)awardId classId:(NSString *)classId;

- (instancetype)initWithGroup:(NSString *)groupId awardId:(NSString *)awardId classId:(NSString *)classId;

@end

NS_ASSUME_NONNULL_END
