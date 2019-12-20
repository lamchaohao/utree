//
//  CommentListApi.m
//  utree
//
//  Created by 科研部 on 2019/11/21.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "CommentListApi.h"

@implementation CommentListApi

{
    BOOL _isRequestMore;
    NSString *_schoolCircleId;
    NSNumber *_limit;
    NSString *_commentId;
}

- (instancetype)initWithFirstTime:(NSString *)momentId limit:(NSNumber *)limit
{
    self = [super init];
    if (self) {
        _isRequestMore = NO;
        _schoolCircleId = momentId;
        _limit = limit;
    }
    return self;
}

- (instancetype)initWithMore:(NSString *)momentId limit:(NSNumber *)limit lastId:(NSString *)lastId
{
    self = [super init];
    if (self) {
        _isRequestMore = YES;
        _schoolCircleId = momentId;
        _limit=limit;
        _commentId = lastId;
    }
    return self;
}



- (NSString *)requestUrl
{
    return @"tmobile/schoolCircle/commentList";
}

- (id)requestArgument
{
    if (_isRequestMore) {
        return @{@"schoolCircleId":_schoolCircleId,
                 @"limit":_limit,
                 @"commentId":_commentId
        };
    }else{
        return @{@"schoolCircleId":_schoolCircleId,@"limit":_limit};
    }
}

@end
