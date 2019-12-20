//
//  DeleteWorkApi.h
//  utree
//
//  Created by 科研部 on 2019/12/4.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeleteWorkApi : UTBaseRequest


- (instancetype)initWithId:(NSString *)workId isNotice:(BOOL)isNotice;


@end

NS_ASSUME_NONNULL_END
