//
//  EditGroupApi.m
//  utree
//
//  Created by 科研部 on 2019/11/4.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "EditGroupApi.h"

@implementation EditGroupApi

{
    NSString *_groupPlanId;
    NSString *_groupId;
    NSString *_groupName;
    NSString *_studentIdList;
    int _editMode;
}

- (instancetype)initWithPlanId:(NSString *)planId gName:(NSString *)name idList:(NSArray *)stuList
{
    self = [super init];
    if (self) {
        _editMode = 100;
        _groupPlanId = planId;
        _groupName = name;
        NSString *idListStr = @"";
        for (int i=0; i<stuList.count;i++) {
            idListStr = [idListStr stringByAppendingString:[stuList objectAtIndex:i]];
            if (i!=(stuList.count-1)) {
                idListStr = [idListStr stringByAppendingString:@","];
            }
        }
        _studentIdList = idListStr;
        NSLog(@"initWithPlanId %@",_studentIdList);
    }
    return self;
}

- (instancetype)initWithPlanId:(NSString *)planId groupId:(NSString *)groupId idList:(NSArray *)stuList
{
    self = [super init];
    if (self) {
        _editMode = 200;
        _groupPlanId = planId;
        _groupId = groupId;
        NSString *idListStr = @"";
        for (int i=0; i<stuList.count;i++) {
            idListStr = [idListStr stringByAppendingString:[stuList objectAtIndex:i]];
            if (i!=(stuList.count-1)) {
                idListStr = [idListStr stringByAppendingString:@","];
            }
        }
        _studentIdList = idListStr;
        NSLog(@"idlist %@",_studentIdList);
    }
    return self;
}

- (instancetype)initWithRename:(NSString *)gName groupId:(NSString *)groupId planId:(NSString *)planId idList:(NSArray *)stuList
{
    self = [super init];
    if (self) {
        _editMode = 300;
        _groupPlanId = planId;
        _groupId = groupId;
        _groupName = gName;
        NSString *idListStr = @"";
        for (int i=0; i<stuList.count;i++) {
            idListStr = [idListStr stringByAppendingString:[stuList objectAtIndex:i]];
            if (i!=(stuList.count-1)) {
                idListStr = [idListStr stringByAppendingString:@","];
            }
        }
        _studentIdList = idListStr;
    }
    return self;
}


- (NSString *)requestUrl
{
    return @"tmobile/class/addStudentGroup";
}

- (id)requestArgument
{
    switch (_editMode) {
        case 100:
            return @{
                @"groupPlanId":_groupPlanId,
                @"name":_groupName,
                @"studentList":_studentIdList
            };
            break;
        case 200:
            return @{
                @"groupPlanId":_groupPlanId,
                @"studentGroupId":_groupId,
                @"studentList":_studentIdList
            };
            break;
        case 300:
            return @{
                @"groupPlanId":_groupPlanId,
                @"name":_groupName,
                @"studentGroupId":_groupId,
                @"studentList":_studentIdList
            };
            break;
    }
    return @{
         @"groupPlanId":_groupPlanId,
         @"name":_groupName,
         @"studentGroupId":_groupId,
         @"studentList":_studentIdList
     };
    
}



@end
