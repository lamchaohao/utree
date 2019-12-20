//
//  WrapNoticeListModel.h
//  utree
//
//  Created by 科研部 on 2019/11/15.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WrapNoticeListModel : NSObject
@property(nonatomic,strong)NSNumber *limit;
@property(nonatomic,strong)NSNumber *allCheckNum;
@property(nonatomic,strong)NSArray<NoticeModel *> *list;
@property(nonatomic,strong)NSNumber *unreadCount;//未读
@property(nonatomic,strong)NSString *noticeId;
@property(nonatomic,assign)NSNumber *myself;
@property(nonatomic,strong)NSString *dPath;

@end

NS_ASSUME_NONNULL_END
