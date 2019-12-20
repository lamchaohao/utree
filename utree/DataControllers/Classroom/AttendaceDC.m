//
//  AttendaceDC.m
//  utree
//
//  Created by 科研部 on 2019/10/31.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "AttendaceDC.h"
#import "AttendanceApi.h"
#import "UTCache.h"
#import "ClassStudentsDC.h"
#import "UTStudent.h"
#import "AttendanceStatusApi.h"
@interface AttendaceDC()

@property(nonatomic,strong)NSArray *students;

@end


@implementation AttendaceDC


- (void)requestStudentAttendanceStatusWithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)fail
{
    
    ClassStudentsDC *studentsDC = [[ClassStudentsDC alloc]init];
    [studentsDC requestStudentListWithSuccess:^(UTResult * _Nonnull result) {
        self.students = result.successResult;
        [self fetchStudentsStatusWithSuccess:success failure:fail];
    } failure:^(UTResult * _Nonnull result) {
        if (fail) {
                   fail([[UTResult alloc]initWithFailure:result.failureResult]);
            }
    }];
    
    
}
/**
     {
         "studentId":"95650771140570211",
         "status":2
     }
 */
-(void)fetchStudentsStatusWithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)fail
{
    AttendanceApi *api = [[AttendanceApi alloc]initWithClassId:[UTCache readClassId]];
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        NSArray *dictArray =  successMsg.responseData;
        for (NSDictionary *dict in dictArray) {
            NSString *stuId = [dict objectForKey:@"studentId"];
            NSNumber *status =[dict objectForKey:@"status"];
            for (UTStudent *student in self.students) {
                if([student.studentId isEqualToString:stuId])
                {
                    student.attendanceMode = status.integerValue;
                    break;
                }
            }
        }
        if (success) {
            success([[UTResult alloc]initWithSuccess:self.students]);
        }
        
    } onFailure:^(FailureMsg * _Nonnull message) {
        if (fail) {
            fail([[UTResult alloc]initWithFailure:message.message]);
        }
    }];
}


-(void)saveStudentsAttendance:(NSArray<UTStudent *> *)stuList StatusWithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)fail
{
    
    NSMutableDictionary *requestJson = [[NSMutableDictionary alloc]init];
    NSMutableArray *attendanceArray = [[NSMutableArray alloc]init];
    for (UTStudent *stu in stuList) {
        if (stu.attendanceMode!=0) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setValue:[NSNumber numberWithLong:stu.attendanceMode] forKey:@"status"];
            [dic setValue:stu.studentId forKey:@"studentId"];
            [attendanceArray addObject:dic];
        }
    }
    [requestJson setValue:attendanceArray forKey:@"attendanceDos"];
    [requestJson setValue:[self getCurrentClassId] forKey:@"classId"];
    [requestJson setValue:[UTCache readToken] forKey:@"token"];
    
    AttendanceStatusApi *api =[[AttendanceStatusApi alloc]initWithRequestDictionary:requestJson];
    
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        if(success){
            success([[UTResult alloc]initWithSuccess:successMsg.responseData]);
        }
    } onFailure:^(FailureMsg * _Nonnull message) {
        if (fail) {
            fail([[UTResult alloc]initWithFailure:message.message]);
        }
    }];
    
}

@end
