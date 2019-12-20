//
//  WorkClassListApi.h
//  utree
//
//  Created by 科研部 on 2019/12/5.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WorkClassListApi : UTBaseRequest

- (instancetype)initWithWorkId:(NSString *)workId isNotice:(BOOL)isNotice;

@end

NS_ASSUME_NONNULL_END
