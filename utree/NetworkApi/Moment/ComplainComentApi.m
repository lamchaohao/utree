//
//  ComplainComentApi.m
//  utree
//
//  Created by 科研部 on 2019/11/26.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ComplainComentApi.h"

@implementation ComplainComentApi


{
    NSString *_commentId;
    NSString *_reason;
}
- (instancetype)initWithCommentId:(NSString *)commId andReason:(NSString *)reason
{
    self = [super init];
    if (self) {
        _commentId = commId;
        _reason = reason;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"tmobile/schoolCircle/applyComplaint";
}

- (id)requestArgument
{
    return @{
        @"commentId":_commentId,
        @"reason":_reason
    };
}

@end
