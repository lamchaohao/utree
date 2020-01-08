//
//  MessageInfoApi.m
//  utree
//
//  Created by 科研部 on 2019/12/24.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "MessageInfoApi.h"

@implementation MessageInfoApi

{
    NSNumber *_isSystemMsg;
    NSNumber *_limit;
    NSString *_messageId;
    BOOL isRequestMore;
}

- (instancetype)initWithFirst:(NSNumber *)isSystem
{
    self = [super init];
    if (self) {
        isRequestMore = NO;
        _isSystemMsg = isSystem;
    }
    return self;
}

- (instancetype)initWithMore:(NSNumber *)isSystem lastId:(NSString *)lastId limit:(NSNumber *)limit
{
    self = [super init];
    if (self) {
        isRequestMore = YES;
        _isSystemMsg = isSystem;
        _messageId = lastId;
        _limit = limit;
    }
    return self;
}

- (id)requestArgument
{
    if (isRequestMore) {
        return @{
            @"isSYSMSG":_isSystemMsg,
            @"messageId":_messageId,
            @"limit":_limit
        };
    }else{
        return @{@"isSYSMSG":_isSystemMsg};
    }
}

- (NSString *)requestUrl
{
    return @"tmobile/msg/msgList";
}





@end
