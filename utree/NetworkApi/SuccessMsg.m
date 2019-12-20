//
//  SuccessMsg.m
//  utree
//
//  Created by 科研部 on 2019/10/29.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "SuccessMsg.h"

@implementation SuccessMsg

-(instancetype)initWithResponseData:(id)data
{
    self=[super init];
    if (self) {
        self.responseData = data;
    }
    return self;
}

@end
