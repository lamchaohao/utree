//
//  MessageInfoApi.h
//  utree
//
//  Created by 科研部 on 2019/12/24.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageInfoApi : UTBaseRequest

- (instancetype)initWithFirst:(NSNumber *)isSystem;

- (instancetype)initWithMore:(NSNumber *)isSystem lastId:(NSString *)lastId limit:(NSNumber *)limit;

@end

NS_ASSUME_NONNULL_END
