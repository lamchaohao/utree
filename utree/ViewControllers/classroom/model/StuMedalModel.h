//
//  StuMedalModel.h
//  utree
//
//  Created by 科研部 on 2019/11/7.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StuMedalModel : NSObject

@property(nonatomic,strong)NSNumber *medalType;

@property(nonatomic,strong)NSNumber *medalNow;

@property(nonatomic,strong)NSNumber *medalMax;

@property(nonatomic,readwrite)BOOL read;

@end

NS_ASSUME_NONNULL_END
