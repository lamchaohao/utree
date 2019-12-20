//
//  MomentListApi.h
//  utree
//
//  Created by 科研部 on 2019/11/20.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UTBaseRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface MomentListApi : UTBaseRequest

- (instancetype)initWithFirstTime:(BOOL)mySelf limit:(NSNumber *)limit;

- (instancetype)initWithMore:(BOOL)mySelf limit:(NSNumber *)limit lastId:(NSString *)lastId;

@end

NS_ASSUME_NONNULL_END
