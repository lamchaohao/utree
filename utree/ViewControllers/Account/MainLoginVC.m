//
//  MainLogin.m
//  utree
//
//  Created by 科研部 on 2019/8/1.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "MainLoginVC.h"
#import "SMSLoginVC.h"
#import "ModifyPswVC.h"
#import "MMAlertView.h"
#import "LoginView.h"
#import "LoginViewModel.h"
@interface MainLoginVC ()<SMSLoginDelegate,LoginDataDelegate,LoginViewResponser>

@end

@implementation MainLoginVC


- (void)loadView{
     [self initView];
}

-(void)initView{
    self.dataController = [[LoginDataController alloc]init];
    self.dataController.delegate = self;
    
    LoginView *loginView = [[LoginView alloc]init];
    self.view = loginView;
    loginView.responser = self;
    
    self.viewModel = [[LoginViewModel alloc]init];
    [loginView bindWithViewModel:self.viewModel];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.viewModel hideKeyboard];
}

#pragma mark 登录成功 SMSLoginVC delegate
- (void)smsLoginSuccessWithUserId:(NSString *)userId
{
    //通知appDelegate转换页面
       if([self.delegate respondsToSelector:@selector(loginSuccessWithUser:)]){
          [self.delegate loginSuccessWithUser:userId];
      }
      [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)onRegister:(NSString *)account password:(NSString *)password code:(NSString *)code
{
    [self.dataController requestRegister:account password:password code:code WithSuccess:^(UTResult *result) {
        
    } failure:^(UTResult *result) {
        [self showAlertMessage:@"" title:result.failureResult];
    }];
}

- (void)onGetVerifyCodePress:(NSString *)account
{
    [self.dataController requestVerifyCodeForAccount:account usage:USAGE_REGISTER WithSuccess:^(UTResult *result) {
        [self.viewModel showCountDownViewFrom:60];
    } failure:^(UTResult *result) {
        [self.viewModel showCountDownViewFrom:3];
    }];
}

- (void)onToUpdatePassword
{
    ModifyPswVC *modifyPswVC = [[ModifyPswVC alloc] init];
    modifyPswVC.modalPresentationStyle=UIModalPresentationFullScreen;
    [self presentViewController:modifyPswVC animated:YES completion:nil];
}

- (void)onChangeToSMSLogin
{
    SMSLoginVC *smsLoginVC = [[SMSLoginVC alloc] init];
    smsLoginVC.smsLoginDelegate = self;
    smsLoginVC.modalPresentationStyle=UIModalPresentationFullScreen;
    [self presentViewController:smsLoginVC animated:YES completion:nil];
}

- (void)onLoginPress:(NSString *)account password:(NSString *)password
{
    [self.dataController requestPasswordLogin:account password:password WithSuccess:^(UTResult * result) {
        [self smsLoginSuccessWithUserId:[self getUserId]];
    } failure:^(UTResult * result) {
        [self showAlertMessage:@"" title:result.failureResult];
    }];
    
}


@end
