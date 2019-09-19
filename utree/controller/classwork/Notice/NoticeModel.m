//
//  NoticeModel.m
//  utree
//
//  Created by 科研部 on 2019/8/29.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "NoticeModel.h"

@implementation NoticeModel



-(instancetype)initWithPosterName:(NSString *)name time:(NSString *)time title:(NSString *)title detail:(NSString *)detail
{
    self.poster = name;
    self.noticeTitle = title;
    self.postTime = time;
    self.noticeDetail = detail;
    return self;
}

@end
