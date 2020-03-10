//
//  RemindAgainApi.h
//  utree
//
//  Created by 科研部 on 2020/1/17.
//  Copyright © 2020 科研部. All rights reserved.
//

#import "UTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface RemindAgainApi : UTBaseRequest

- (instancetype)initWithWorkId:(NSString *)workId stuId:(NSString *)stuId workType:(int)type;

@end

NS_ASSUME_NONNULL_END
