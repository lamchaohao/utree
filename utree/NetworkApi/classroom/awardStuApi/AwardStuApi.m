//
//  AwardStuApi.m
//  utree
//
//  Created by 科研部 on 2019/11/12.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "AwardStuApi.h"

@implementation AwardStuApi

{
    NSString *_stuIdList;
    NSString *_excitationId;
    NSString *_classId;
    NSString *_groupId;
    BOOL _isGroup;
}

- (instancetype)initWithStuList:(NSString *)stuIds awardId:(NSString *)awardId classId:(NSString *)classId
{
    self = [super init];
    if (self) {
        _isGroup = NO;
        _stuIdList = stuIds;
        _excitationId = awardId;
        _classId = classId;
    }
    return self;
}


- (instancetype)initWithGroup:(NSString *)groupId awardId:(NSString *)awardId classId:(NSString *)classId
{
    self = [super init];
    if (self) {
        _isGroup = YES;
        _groupId = groupId;
        _excitationId = awardId;
        _classId = classId;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"tmobile/class/rewardStudent";
}

- (id)requestArgument
{
    if (_isGroup) {
        return @{
            @"excitationId":_excitationId,
            @"classId":_classId,
            @"groupId":_groupId
        };
    }else{
        return @{
            @"studentList":_stuIdList,
            @"excitationId":_excitationId,
            @"classId":_classId
        };
    }
}


@end
