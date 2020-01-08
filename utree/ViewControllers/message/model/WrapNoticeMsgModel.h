//
//  WrapNoticeMsgModel.h
//  utree
//
//  Created by 科研部 on 2019/12/24.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeMessageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WrapNoticeMsgModel : NSObject

@property(nonatomic,strong)NSNumber *limit;

@property(nonatomic,strong)NSString *messageId;

@property(nonatomic,strong)NSNumber *unreadCount;

@property(nonatomic,strong)NSArray<NoticeMessageModel *> *list;

@end

NS_ASSUME_NONNULL_END
