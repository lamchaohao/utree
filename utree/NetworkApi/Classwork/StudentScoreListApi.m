//
//  StudentScoreListApi.m
//  utree
//
//  Created by 科研部 on 2019/12/10.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "StudentScoreListApi.h"

@implementation StudentScoreListApi

{
    NSString *_classId;
    NSString *_examId;
}

- (instancetype)initWithClassId:(NSString *)classId examId:(NSString *)examId
{
    self = [super init];
    if (self) {
        _classId = classId;
        _examId = examId;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"tmobile/task/examDetail";
}

- (id)requestArgument
{
    return @{
        @"classId":_classId,
        @"examId":_examId
    };
}


@end
