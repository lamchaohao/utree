//
//  AttendaceDC.h
//  utree
//
//  Created by 科研部 on 2019/10/31.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "BaseDataController.h"
#import "UTStudent.h"
NS_ASSUME_NONNULL_BEGIN

@interface AttendaceDC : BaseDataController

-(void)requestStudentAttendanceStatusWithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)fail;

-(void)saveStudentsAttendance:(NSArray<UTStudent *> *)stuList StatusWithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)fail;

@end

NS_ASSUME_NONNULL_END
