//
//  FailureMsg.m
//  utree
//
//  Created by 科研部 on 2019/10/29.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "FailureMsg.h"

@implementation FailureMsg

- (instancetype)initWithMessage:(NSString *)msg
{
    self=[super init];
    if (self) {
        self.message = msg;
    }
    return self;
}

@end
