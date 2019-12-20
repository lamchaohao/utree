//
//  ModifyPswView.h
//  utree
//
//  Created by 科研部 on 2019/10/29.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBTextField.h"
#import "MMAlertView.h"
#import "ZBVerifyCodeButton.h"
#import "ModifyPswViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol ModifyPswViewResponser <NSObject>

-(void)onModifyBtnPress:(NSString *)account password:(NSString *)password code:(NSString *)code;

-(void)onRequestVerifyCode:(NSString *)account;

-(void)onChangeToLogin;


@end

@interface ModifyPswView : MyLinearLayout

@property(strong,nonatomic)ZBTextField *accountInput;

@property(strong,nonatomic)ZBTextField *verifyCodeInput;

@property(strong,nonatomic)ZBTextField *pswTextInput;

@property(strong,nonatomic)UIButton *modifyBtn;

@property(strong,nonatomic)UIButton *accountAndPswLoginBtn;

@property(strong,nonatomic)ZBVerifyCodeButton *verifyCodeBtn;

@property(nonatomic,assign)id<ModifyPswViewResponser> responser;

-(void)bindWithViewModel:(ModifyPswViewModel *)viewModel;


@end

NS_ASSUME_NONNULL_END
