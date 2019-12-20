//
//  SuccessMsg.h
//  utree
//
//  Created by 科研部 on 2019/10/29.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SuccessMsg : NSObject

@property(nonatomic,strong)id responseData;

-(instancetype)initWithResponseData:(id)data;

@end

NS_ASSUME_NONNULL_END
