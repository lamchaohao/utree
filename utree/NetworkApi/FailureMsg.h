//
//  FailureMsg.h
//  utree
//
//  Created by 科研部 on 2019/10/29.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FailureMsg : NSObject

@property(nonatomic,strong)NSString *message;
@property(nonatomic,assign)int code;

-(instancetype)initWithMessage:(NSString*) msg;

@end

NS_ASSUME_NONNULL_END
