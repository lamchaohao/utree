//
//  VerifyCodeApi.h
//  utree
//
//  Created by 科研部 on 2019/10/23.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKRequest.h"
#import "UTBaseRequest.h"
NS_ASSUME_NONNULL_BEGIN
//REGISTER（注册用）、LOGIN（登录用）、SETPWD（修改密码用）、CHANGEPHONE（更换手机号码）

typedef NS_ENUM(NSInteger, VerifyCodeMethod) {
    USAGE_REGISTER =1,
    USAGE_LOGIN ,
    USAGE_SETPWD ,
    USAGE_CHANGEPHONE
};

@interface VerifyCodeApi : UTBaseRequest
- (id)initWithAccount:(NSString *)account usage:(VerifyCodeMethod)usage;
@end

NS_ASSUME_NONNULL_END
