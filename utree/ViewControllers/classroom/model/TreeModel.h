//
//  TreeModel.h
//  utree
//
//  Created by 科研部 on 2019/11/6.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TreeModel : NSObject
@property(nonatomic,strong)NSString *treeId;
@property(nonatomic,strong)NSString *studentId;
@property(nonatomic,strong)NSString *schoolYearCode;
@property(nonatomic,strong)NSNumber *term;
@property(nonatomic,strong)NSNumber *dropNow;
@property(nonatomic,strong)NSNumber *dropMax;
@property(nonatomic,strong)NSNumber *treeLevel;
@end

NS_ASSUME_NONNULL_END
