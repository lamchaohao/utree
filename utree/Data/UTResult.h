//
//  UTResult.h
//  utree
//
//  Created by 科研部 on 2019/10/28.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UTResult : NSObject

@property(nonatomic,strong)id successResult;

@property(nonatomic,strong)id failureResult;

-(instancetype)initWithSuccess:(id)result;
-(instancetype)initWithFailure:(id)result;
@end

NS_ASSUME_NONNULL_END
