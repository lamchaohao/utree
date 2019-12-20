//
//  NoticeListApi.h
//  utree
//
//  Created by 科研部 on 2019/11/15.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeListApi : UTBaseRequest

- (instancetype)initWithFirstClassId:(NSString *)classId isMydata:(BOOL)isMine;

- (instancetype)initWithMoreWithClassId:(NSString *)classId isMydata:(BOOL)isMine limitNum:(NSNumber *)limit lastNoticeId:(NSString *)lastNoticeId;

@end

NS_ASSUME_NONNULL_END
