//
//  SmsLoginView.h
//  utree
//
//  Created by 科研部 on 2019/10/28.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBTextField.h"
#import "ZBVerifyCodeButton.h"
#import "SMSViewManager.h"
NS_ASSUME_NONNULL_BEGIN

@protocol SMSLoginViewResponser <NSObject>

-(void)onGetVerifyCodePress:(NSString *)account;

-(void)onVerifyLoginPress:(NSString *)account code:(NSString *)code;

-(void)onPasswordLoginPress;

@end


@interface SmsLoginView : MyLinearLayout

@property(strong,atomic)ZBTextField *accountInput;
@property(strong,atomic)ZBTextField *verifyCodeInput;
@property(strong,atomic)UIButton *loginBtn;
@property(strong,atomic)UIButton *accountAndPswLoginBtn;
@property(strong,atomic)ZBVerifyCodeButton *codeBtn;

-(void)bindWithViewManger:(SMSViewManager *)viewManager;

@property(nonatomic,assign)id<SMSLoginViewResponser> responser;

@end

NS_ASSUME_NONNULL_END
