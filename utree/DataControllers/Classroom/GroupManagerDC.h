//
//  GroupManagerDC.h
//  utree
//
//  Created by 科研部 on 2019/11/4.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "BaseDataController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupManagerDC : BaseDataController

-(void)requestGroupListByClassId:(NSString *)classId planId:(NSString *)planId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)requestStudentListInGroup:(NSString *)classId planId:(NSString *)planId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)requestAddGroupByName:(NSString *)groupName planId:(NSString *)planId studentList:(NSArray *)stuIdList WithSuccess:(UTRequestCompletionBlock)success  failure:(UTRequestCompletionBlock)failure;

-(void)deleteGroupById:(NSString *)groupId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)requestEditGroupById:(NSString *)groupId planId:(NSString *)planId studentList:(NSArray *)stuIdList WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)requestGroupDetailById:(NSString *)groupId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)requestRenameGroupById:(NSString *)groupId groupName:(NSString *)gName planId:(NSString *)planId studentList:(NSArray *)stuIdList WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;
@end

NS_ASSUME_NONNULL_END
