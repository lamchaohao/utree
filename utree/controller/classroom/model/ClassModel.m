//
//  ClassModel.m
//  utree
//
//  Created by 科研部 on 2019/8/27.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ClassModel.h"

@implementation ClassModel

- (instancetype)initWithClassName:(NSString *)className subject:(NSString *)subject studentCount:(int) studentCount dropCount:(int) dropCount
{
    self = [super init];
    if (self) {
        self.className = className;
        self.subject = subject;
        self.studentCount = studentCount;
        self.dropScore = dropCount;
    }
    return self;
}

@end
