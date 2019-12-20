//
//  WrapMomentListModel.h
//  utree
//
//  Created by 科研部 on 2019/11/20.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MomentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WrapMomentListModel : NSObject


@property(nonatomic,strong)NSNumber *limit;
@property(nonatomic,assign)NSNumber *myself;
@property(nonatomic,strong)NSArray<MomentModel *> *list;
@property(nonatomic,strong)NSNumber *allCheckNum;
@property(nonatomic,strong)NSString *schoolCircleId;

@property(nonatomic,strong)NSString *dPath;


@end

NS_ASSUME_NONNULL_END
