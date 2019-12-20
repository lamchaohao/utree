//
//  DropDetailDC.h
//  utree
//
//  Created by 科研部 on 2019/11/6.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "BaseDataController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DropDetailDC : BaseDataController

-(void)requestStudentTreeData:(NSString *)stuId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)requestMedalData:(NSString *)studentId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)requestDropRecordFirst:(NSString *)stuId dateZone:(NSNumber *)dateType WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)requestMoreDropRecordWithStuId:(NSString *)stuId dateZone:(NSNumber *)dateType lastDropId:(NSString *)dropId limit:(NSNumber *)limit WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

@end

NS_ASSUME_NONNULL_END
