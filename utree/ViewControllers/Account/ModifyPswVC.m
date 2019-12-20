//
//  ModifyPswVC.m
//  utree
//
//  Created by 科研部 on 2019/8/6.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ModifyPswVC.h"
#import "ZBSegmentView.h"
#import "MMAlertView.h"
#import "MD5Util.h"
#import "ModifyPswView.h"

@interface ModifyPswVC ()<ModifyPswViewResponser>

@end

@implementation ModifyPswVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)loadView{
    [self initView];
}

-(void)initView{
    ModifyPswView *rootView = [[ModifyPswView alloc]init];
    self.view = rootView;
    
    self.viewModel = [[ModifyPswViewModel alloc]init];
    
    [rootView bindWithViewModel:self.viewModel];
    rootView.responser=self;
    
    self.dataController = [[ModifyPswDC alloc]init];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.viewModel hidekeyBoard];
}

- (void)onRequestVerifyCode:(NSString *)account
{
    [self.dataController requestVerifyCode:account WithSuccess:^(UTResult * _Nonnull result) {
        [self.viewModel showCountDownViewFrom:60];
    } failure:^(UTResult * _Nonnull result) {
        [self showAlertMessage:@"" title:result.failureResult];
    }];
}

- (void)onModifyBtnPress:(NSString *)account password:(NSString *)password code:(NSString *)code
{
    [self.dataController requestUpdatePassword:account newPassword:password code:code WithSuccess:^(UTResult * _Nonnull result) {
        [self showViewAfterResetPassword];
    } failure:^(UTResult * _Nonnull result) {
        [self showAlertMessage:@"" title:result.failureResult];
    }];
}

- (void)onChangeToLogin
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)showViewAfterResetPassword
{
    MMPopupCompletionBlock completeBlock = ^(MMPopupView *popupView, BOOL finished){
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    MMAlertView *alertView = [[MMAlertView alloc]initWithConfirmTitle:@"修改密码成功" detail:@"请记住您的密码"];
    [alertView showWithBlock:completeBlock];
}

- (void)showAlertMessage:(NSString *)message title:(NSString *)title
{
    MMAlertView *alertView = [[MMAlertView alloc]initWithConfirmTitle:title detail:message];
    [alertView show];
}

@end
