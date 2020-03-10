//
//  NoticeDetailApi.m
//  utree
//
//  Created by 科研部 on 2020/1/16.
//  Copyright © 2020 科研部. All rights reserved.
//

#import "MessageNoticeDetailApi.h"

@implementation MessageNoticeDetailApi

{
    NSString *_msgId;
    NSNumber *_isSysMsg;
}

- (instancetype)initWithMsgId:(NSString *)msgId isSystem:(BOOL)isSysMsg
{
    self = [super init];
    if (self) {
        _msgId = msgId;
        _isSysMsg = [NSNumber numberWithBool:isSysMsg];
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"tmobile/msg/msgDetail";
}

- (id)requestArgument
{
    return @{@"messageId":_msgId,
             @"isSYSMSG":_isSysMsg
    };
}

@end
