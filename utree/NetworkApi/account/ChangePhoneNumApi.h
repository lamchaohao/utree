//
//  ChangePhoneNumApi.h
//  utree
//
//  Created by 科研部 on 2019/12/26.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChangePhoneNumApi : UTBaseRequest


- (instancetype)initWithOldCode:(NSString *)oldCode newPhone:(NSString *)phone andNewCode:(NSString *)newCode;

@end

NS_ASSUME_NONNULL_END
