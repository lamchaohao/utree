//
//  FeedbackDC.h
//  utree
//
//  Created by 科研部 on 2019/12/26.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "BaseDataController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedbackDC : BaseDataController

-(void)submitFeedbackWithContent:(NSString *)content withSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

@end

NS_ASSUME_NONNULL_END
