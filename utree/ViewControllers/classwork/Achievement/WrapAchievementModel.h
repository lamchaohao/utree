//
//  WrapAchievementModel.h
//  utree
//
//  Created by 科研部 on 2019/12/9.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AchievementModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WrapAchievementModel : NSObject

@property(nonatomic,strong)NSNumber *limit;
@property(nonatomic,strong)NSNumber *allCheckNum;

@property(nonatomic,strong)NSNumber *unreadCount;//未读

@property(nonatomic,strong)NSString *examId;
@property(nonatomic,assign)NSNumber *myself;
@property(nonatomic,assign)NSArray<AchievementModel *> *list;


@end

NS_ASSUME_NONNULL_END
