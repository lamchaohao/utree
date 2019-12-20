//
//  HomeworkListDC.h
//  utree
//
//  Created by 科研部 on 2019/11/26.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "BaseDataController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeworkListDC : BaseDataController

-(void)requestHomeworkListFirstTime:(BOOL)isMyData WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)requestMoreHomework:(BOOL)isMyData lastId:(NSString *)lastId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;


@end

NS_ASSUME_NONNULL_END
