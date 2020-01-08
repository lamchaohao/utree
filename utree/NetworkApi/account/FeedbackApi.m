//
//  FeedbackApi.m
//  utree
//
//  Created by 科研部 on 2019/12/26.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "FeedbackApi.h"

@implementation FeedbackApi

{
    NSString *_content;
}

- (instancetype)initWithContent:(NSString *)content
{
    self = [super init];
    if (self) {
        _content = content;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"tmobile/base/suggestionFeedback";
}

- (id)requestArgument
{
    return @{
        @"content":_content,
        @"terminal":@(2)
    };
}

@end
