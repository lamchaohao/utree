//
//  AchievementListApi.h
//  utree
//
//  Created by 科研部 on 2019/12/9.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface AchievementListApi : UTBaseRequest

- (instancetype)initWithMoreClassId:(NSString *)classId isMine:(BOOL)isMine limit:(NSNumber *)limit lastId:(NSString *)lastId;

- (instancetype)initWithFirstTimeClassId:(NSString *)classId isMine:(BOOL)isMine;

@end

NS_ASSUME_NONNULL_END
