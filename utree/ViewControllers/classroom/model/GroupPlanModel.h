//
//  GroupPlanModel.h
//  utree
//
//  Created by 科研部 on 2019/11/1.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GroupPlanModel : NSObject

@property(nonatomic,strong)NSString *planId;

@property(nonatomic,strong)NSString *planName;

@property(nonatomic,assign)int groupCount;

@end

NS_ASSUME_NONNULL_END
