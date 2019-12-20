//
//  NoticeListDC.h
//  utree
//
//  Created by 科研部 on 2019/11/15.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "BaseDataController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeListDC : BaseDataController

-(void)requestNoticeListFirstTime:(BOOL)isMyData WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)requestMoreNotice:(BOOL)isMyData lastId:(NSString *)lastId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

@end

NS_ASSUME_NONNULL_END
