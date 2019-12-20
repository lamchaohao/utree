//
//  AchievementListApi.m
//  utree
//
//  Created by 科研部 on 2019/12/9.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "AchievementListApi.h"

@implementation AchievementListApi

{
    NSString *_classId;
    NSNumber *_limit;
    NSString *_examId;
    BOOL myself;
    BOOL isFirstTime;
}

- (instancetype)initWithFirstTimeClassId:(NSString *)classId isMine:(BOOL)isMine
{
    self = [super init];
    if (self) {
        isFirstTime=YES;
        _classId = classId;
        myself=isMine;
    }
    return self;
}

- (instancetype)initWithMoreClassId:(NSString *)classId isMine:(BOOL)isMine limit:(NSNumber *)limit lastId:(NSString *)lastId
{
    self = [super init];
    if (self) {
        isFirstTime=NO;
        _classId = classId;
        _limit = limit;
        _examId = lastId;
        myself = isMine;
    }
    return self;
}




- (NSString *)requestUrl
{
    return @"tmobile/task/examList";
}

- (id)requestArgument
{
    if (isFirstTime) {
        return @{
            @"classId":_classId,
            @"myself":@(myself)
        };
    }else{
        return @{
            @"classId":_classId,
            @"limit":_limit,
            @"examId":_examId,
            @"myself":@(myself)
        };
    }
    
}



@end
