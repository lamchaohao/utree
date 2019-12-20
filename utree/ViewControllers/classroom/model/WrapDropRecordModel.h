//
//  WrapDropRecordModel.h
//  utree
//
//  Created by 科研部 on 2019/11/7.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StuDropRecordModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WrapDropRecordModel : NSObject

@property(nonatomic,strong)NSNumber *offset;

@property(nonatomic,strong)NSNumber *limit;

@property(nonatomic,strong)NSString *updateTime;

@property(nonatomic,strong)NSString *dropId;

@property(nonatomic,strong)NSArray<StuDropRecordModel *> *list;
@end

NS_ASSUME_NONNULL_END
