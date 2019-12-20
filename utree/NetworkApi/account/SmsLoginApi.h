//
//  SmsLoginApi.h
//  utree
//
//  Created by 科研部 on 2019/10/24.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTBaseRequest.h"

@interface SmsLoginApi : UTBaseRequest
-(instancetype)initWithPhoneNum:(NSString *)phone andCode:(NSString *)code;
@end

