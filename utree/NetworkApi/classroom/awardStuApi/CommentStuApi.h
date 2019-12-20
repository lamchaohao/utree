//
//  CommentStuApi.h
//  utree
//
//  Created by 科研部 on 2019/11/8.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentStuApi : UTBaseRequest

- (instancetype)initWithStuId:(NSString *)studentId commentText:(NSString *)comment;

@end

NS_ASSUME_NONNULL_END
