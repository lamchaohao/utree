//
//  ResetPswApi.h
//  utree
//
//  Created by 科研部 on 2019/10/24.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface ResetPswApi : UTBaseRequest
-(instancetype)initWithPhone:(NSString *)phone code:(NSString *)code newPassword:(NSString *)psw;
@end

NS_ASSUME_NONNULL_END
