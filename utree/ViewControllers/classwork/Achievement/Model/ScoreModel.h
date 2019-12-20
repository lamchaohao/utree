//
//  ScoreModel.h
//  utree
//
//  Created by 科研部 on 2019/12/9.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScoreModel : NSObject

@property(nonatomic,strong)NSString *scoreId;
@property(nonatomic,strong)NSNumber *score;
@property(nonatomic,strong)NSString *studentName;
@property(nonatomic,strong)NSNumber *ranking;


@end

NS_ASSUME_NONNULL_END
