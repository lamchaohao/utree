//
//  UTBaseRequest.h
//  utree
//
//  Created by 科研部 on 2019/10/24.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "YTKBaseRequest.h"
#import "FailureMsg.h"
#import "SuccessMsg.h"
#import "UTResult.h"

NS_ASSUME_NONNULL_BEGIN


typedef void(^OnResponseBlock)(SuccessMsg *successMsg);
typedef void(^OnFailureBlock)(FailureMsg *message);

@interface UTBaseRequest : YTKBaseRequest

-(void)startWithValidateBlock:(OnResponseBlock)successBlock onFailure:(OnFailureBlock)onFail;

@end

NS_ASSUME_NONNULL_END
