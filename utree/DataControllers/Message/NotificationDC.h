//
//  NotificationDC.h
//  utree
//
//  Created by 科研部 on 2019/12/24.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "BaseDataController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NotificationDC : BaseDataController

-(void)requestMoreNotice:(BOOL)isSystemNotice lastId:(NSString *)lastId limit:(int)limit WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)requestFirstNotification:(BOOL)isSystemNotice WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

@end

NS_ASSUME_NONNULL_END
