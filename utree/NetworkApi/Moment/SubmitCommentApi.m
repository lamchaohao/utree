//
//  SubmitCommentApi.m
//  utree
//
//  Created by 科研部 on 2019/11/21.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "SubmitCommentApi.h"

@implementation SubmitCommentApi


{
    NSString *commentText;
    NSString *momentId;
}

- (instancetype)initWithMomentId:(NSString *)circleId comment:(NSString *)text
{
    self = [super init];
    if (self) {
        commentText = text;
        momentId = circleId;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"tmobile/schoolCircle/commentCircle";
}

- (id)requestArgument
{
    return @{@"schoolCircleId":momentId,@"comment":commentText};
}



@end
