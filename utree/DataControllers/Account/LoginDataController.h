//
//  LoginDataController.h
//  utree
//
//  Created by 科研部 on 2019/10/28.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VerifyCodeApi.h"
#import "BaseDataController.h"
NS_ASSUME_NONNULL_BEGIN

@protocol LoginDataDelegate <NSObject>

-(void)showAlertMessage:(NSString *)message title:(NSString *)title;

@end

@interface LoginDataController : BaseDataController

-(void)requestPasswordLogin:(NSString *)account password:(NSString *)passwordStr WithSuccess:(UTRequestCompletionBlock)success
failure:(UTRequestCompletionBlock)failure;

-(void)requestVerifyCodeForAccount:(NSString *)account usage:(VerifyCodeMethod)method WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;


-(void)requestRegister:(NSString *)account password:(NSString *)passwordStr code:(NSString *)verifyCode WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;;

@property(nonatomic,strong)id<LoginDataDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
