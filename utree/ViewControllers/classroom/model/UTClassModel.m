//
//  UTClassModel.m
//  utree
//
//  Created by 科研部 on 2019/10/25.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTClassModel.h"

@implementation UTClassModel


-(NSString *)className
{
    
    NSString *classNameComp = [NSString stringWithFormat:@"%d年%d班",self.classGrade.intValue,self.classCode.intValue];
//    if(self.headTeacher.boolValue)
//    {
//        [classNameComp stringByAppendingString:@"(班主任)"];
//    }
    return classNameComp;
}


@end
