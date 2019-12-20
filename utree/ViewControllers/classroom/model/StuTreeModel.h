//
//  StuTreeModel.h
//  utree
//
//  Created by 科研部 on 2019/11/6.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TreeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface StuTreeModel : NSObject

@property(nonatomic,strong)NSNumber *thisMax;
@property(nonatomic,strong)NSNumber *previousMax;
@property(nonatomic,strong)NSNumber *levelMax;
@property(nonatomic,strong)TreeModel *tree;

@end

NS_ASSUME_NONNULL_END
