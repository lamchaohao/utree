//
//  BaseDataController.m
//  utree
//
//  Created by 科研部 on 2019/10/29.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "BaseDataController.h"

@implementation BaseDataController

-(NSString *)getCurrentPlanName
{
    NSDictionary *dic = [UTCache readGroupPlanCache];
    NSString *name = [dic objectForKey:@"groupPlanName"];
    if ([self isBlankString:name]) {
        name = @"未知 请选择方案";
    }
    return name;
}

-(NSString *)getCurrentPlanId
{
    NSDictionary *dic = [UTCache readGroupPlanCache];
    NSString *planId = [dic objectForKey:@"groupPlanId"];
    if ([self isBlankString:planId]) {
        planId = @"1";
    }
    return planId;
}

-(NSString *)getCurrentClassId
{
    return [UTCache readClassId];
}


- (BOOL)isBlankString:(NSString *)str {
    NSString *string = str;
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    
    return NO;
}

@end
