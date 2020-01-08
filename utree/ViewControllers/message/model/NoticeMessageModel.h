//
//  NoticeMessageModel.h
//  utree
//
//  Created by 科研部 on 2019/12/24.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeMessageModel : NSObject

@property(nonatomic,strong)NSString *messageId;
@property(nonatomic,strong)NSString *topic;
@property(nonatomic,strong)NSString *createTime;
@property(nonatomic,strong)NSNumber *recall;//是否撤回，true为撤回
@property(nonatomic,strong)NSNumber *read;//是否已阅，false为未读

@end

NS_ASSUME_NONNULL_END
