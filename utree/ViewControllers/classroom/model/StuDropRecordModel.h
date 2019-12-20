//
//  StuDropRecordModel.h
//  utree
//
//  Created by 科研部 on 2019/11/7.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StuDropRecordModel : NSObject


@property(nonatomic,strong)NSString *dropId;
@property(nonatomic,strong)NSNumber *amount;
@property(nonatomic,strong)NSString *recordDescription;
@property(nonatomic,strong)NSString *dropType;
@property(nonatomic,strong)NSString *createTime;
@property(nonatomic,readwrite)BOOL click;

-(NSString *)getHourAndMinute;

-(NSString *)getRecordDate;

@end

NS_ASSUME_NONNULL_END
