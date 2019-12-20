//
//  StudentListApi.m
//  utree
//
//  Created by 科研部 on 2019/10/25.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "StudentListApi.h"

@implementation StudentListApi

{
    NSString *_tClassId;
}

-(instancetype)initWithClassId:(NSString *)classId
{
    self = [super init];
    if (self) {
        _tClassId = classId;
    }

    return self;
}

- (NSString *)requestUrl
{
    return @"tmobile/class/getStudentList";
}

-(id)requestArgument
{
    return @{@"teachClassId":_tClassId};
}

@end
