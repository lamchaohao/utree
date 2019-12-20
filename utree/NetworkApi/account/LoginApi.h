//
//  LoginApi.h
//  utree
//
//  Created by 科研部 on 2019/10/23.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginApi : UTBaseRequest
- (id)initWithUsername:(NSString *)username password:(NSString *)password;

@end

NS_ASSUME_NONNULL_END
