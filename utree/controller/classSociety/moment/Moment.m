//
//  Moment.m
//  utree
//
//  Created by 科研部 on 2019/8/28.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "Moment.h"

@implementation Moment


-(instancetype)initWithAuthorName:(NSString *)name time:(NSString *)time content:(NSString *)content photos:(NSArray *)picUrls
{
    self = [super init];
    if (self) {
        _poster = name;
        _postTime = time;
        _momentDetail = content;
        _photoUrls = picUrls;
    }

    return self;
}


@end
