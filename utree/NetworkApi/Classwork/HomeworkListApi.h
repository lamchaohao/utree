//
//  HomeworkListApi.h
//  utree
//
//  Created by 科研部 on 2019/11/27.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeworkListApi : UTBaseRequest

- (instancetype)initWithFirstClassId:(NSString *)classId isMydata:(BOOL)isMine;

- (instancetype)initWithMoreWithClassId:(NSString *)classId isMydata:(BOOL)isMine limitNum:(NSNumber *)limit lastTaskId:(NSString *)lastTaskId;
@end

NS_ASSUME_NONNULL_END
