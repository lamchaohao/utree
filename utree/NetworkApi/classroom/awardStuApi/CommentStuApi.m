//
//  CommentStuApi.m
//  utree
//
//  Created by 科研部 on 2019/11/8.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "CommentStuApi.h"

@implementation CommentStuApi

{
    NSString *_text;
    NSString *_stuId;
}

- (instancetype)initWithStuId:(NSString *)studentId commentText:(NSString *)comment
{
    self = [super init];
    if (self) {
        _text = comment;
        _stuId = studentId;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"tmobile/class/reviewStudent";
}

- (id)requestArgument
{
    return @{@"reviewText":_text,
             @"studentId":_stuId
    };
}

@end
