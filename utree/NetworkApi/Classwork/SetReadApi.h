//
//  SetReadApi.h
//  utree
//
//  Created by 科研部 on 2020/1/16.
//  Copyright © 2020 科研部. All rights reserved.
//

#import "UTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetReadApi : UTBaseRequest

- (instancetype)initWithWorkId:(NSString *)workId type:(int)type;

@end

NS_ASSUME_NONNULL_END
