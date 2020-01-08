//
//  ModifyPswDC.h
//  utree
//
//  Created by 科研部 on 2019/10/29.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDataController.h"
#import "VerifyCodeApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface ModifyPswDC : BaseDataController


-(void)requestUpdatePassword:(NSString *)account newPassword:(NSString *)password code:(NSString *)code WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

- (void)requestVerifyCode:(NSString *)account usage:(VerifyCodeMethod)usage WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)changeNewPhoneWithOldCode:(NSString *)oldCode newPhone:(NSString *)phone andNewCode:(NSString *)newCode  WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)verifyOldPhoneWithCode:(NSString *)code WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

@end

NS_ASSUME_NONNULL_END
