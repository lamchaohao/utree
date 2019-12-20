//
//  RemindCheckApi.h
//  utree
//
//  Created by 科研部 on 2019/12/3.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface RemindCheckApi : UTBaseRequest

- (instancetype)initWithRemindId:(NSString *)remindId classId:(NSString *)classId from:(int)source;

@end

NS_ASSUME_NONNULL_END
