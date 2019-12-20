//
//  ClassStudentsDC.h
//  utree
//
//  Created by 科研部 on 2019/10/30.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "BaseDataController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClassStudentsDC : BaseDataController

-(void)requestStudentListWithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

@end

NS_ASSUME_NONNULL_END
