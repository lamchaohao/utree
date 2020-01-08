//
//  PasswordVC.m
//  utree
//
//  Created by 科研部 on 2019/9/17.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "PasswordVC.h"
#import "ZBTextField.h"
#import "ZBVerifyCodeButton.h"
#import "ModifyPswDC.h"
#import "MMAlertView.h"

@interface PasswordVC ()
@property(nonatomic,strong)ZBTextField *verifyCodeInput;
@property(nonatomic,strong)ZBTextField *passwordInput;
// 获取验证码按钮
@property (nonatomic, weak) ZBVerifyCodeButton *codeBtn;
@property (nonatomic, strong)ModifyPswDC *dataController;
@end

@implementation PasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    self.dataController = [[ModifyPswDC alloc]init];
    [self createView];
    
}

-(void)createView
{
    
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    self.view = rootLayout;
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc]init];
    [titleLabel setFont:[UIFont systemFontOfSize:26]];
    [titleLabel setWrapContentSize:YES];
    titleLabel.myTop=40+iPhone_Top_NavH;
    titleLabel.myLeft = 31;
    titleLabel.text=@"修改密码";
    
    UILabel *titleTipLabel = [[UILabel alloc]init];
    [titleTipLabel setFont:[UIFont systemFontOfSize:15]];
    [titleTipLabel setWrapContentSize:YES];
    titleTipLabel.myTop=15;
    titleTipLabel.myLeft = 31;
    titleTipLabel.text=@"验证当前手机号修改密码";
    titleTipLabel.textColor = [UIColor_ColorChange colorWithHexString:SecondTextColor];
    
    
    UIImageView *pswIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_password_lock"]];
    [pswIcon setLayoutMargins:UIEdgeInsetsMake(5, 4, 4, 12)];
    UIImageView *verifyIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_verify_code"]];
    [verifyIcon setLayoutMargins:UIEdgeInsetsMake(5, 4, 4, 12)];
    
    
    _verifyCodeInput = [ZBTextField new];
    
    [_verifyCodeInput setPlaceholder:@"请输入验证码"];
    [_verifyCodeInput setBorderStyle:UITextBorderStyleNone];
    [_verifyCodeInput setLeftView:verifyIcon];
    _verifyCodeInput.leftViewMode = UITextFieldViewModeAlways;
    _verifyCodeInput.myLeft=_verifyCodeInput.myRight=25;
    _verifyCodeInput.myHeight=42;
    _verifyCodeInput.myTop=55;
    [_verifyCodeInput setClearButtonMode:UITextFieldViewModeNever];// 不显示右边清除叉号
    _verifyCodeInput.keyboardType = UIKeyboardTypeNumberPad; // 数字键盘
    
    // 获取验证码按钮
    ZBVerifyCodeButton *codeBtn = [ZBVerifyCodeButton buttonWithType:UIButtonTypeCustom];
    codeBtn.frame = CGRectMake(ScreenWidth - 70 - 50, 0, 70, 30);
    [codeBtn addTarget:self action:@selector(codeBtnVerification:) forControlEvents:UIControlEventTouchUpInside];
    [_verifyCodeInput addSubview:codeBtn];
    self.codeBtn=codeBtn;
    
    
    _passwordInput = [ZBTextField new];
    [_passwordInput setPlaceholder:@"请输入新密码"];
    [_passwordInput setBorderStyle:UITextBorderStyleNone];
    [_passwordInput setLeftView:pswIcon];
    _passwordInput.leftViewMode = UITextFieldViewModeAlways;
//    _passwordInput.topPos.equalTo(_verifyCodeInput.bottomPos).offset(36);
    _passwordInput.myTop=36;
    _passwordInput.myLeft=_passwordInput.myRight=25;
    _passwordInput.myHeight=42;
    [_passwordInput setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    UIButton *btnLogin= [[UIButton alloc]init];
    [btnLogin setTitle:@"确定" forState:UIControlStateNormal];
    
    btnLogin.myTop = 96;
    btnLogin.myHeight = 70;
    btnLogin.myLeft=btnLogin.myRight=25;
    btnLogin.myCenterX=0;
    [btnLogin setBackgroundImage:[UIImage imageNamed:@"bg_round_conner"] forState:UIControlStateNormal];
    [btnLogin addTarget:self action:@selector(onConfirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rootLayout addSubview:titleLabel];
    [rootLayout addSubview:titleTipLabel];
    [rootLayout addSubview:_verifyCodeInput];
    [rootLayout addSubview:_passwordInput];
    [rootLayout addSubview:btnLogin];
    
}

-(void)onConfirmBtnClick:(id)sender
{
    NSString *phone = [[UTCache readProfile] objectForKey:@"phone"];
    NSString *verifyCode = self.verifyCodeInput.text;
    NSString *psw = self.passwordInput.text;
    [self.dataController requestUpdatePassword:phone newPassword:psw code:verifyCode WithSuccess:^(UTResult * _Nonnull result) {
        [self showViewAfterResetPassword];
    } failure:^(UTResult * _Nonnull result) {
        [self showToastView:result.failureResult];
    }];
}


-(void)codeBtnVerification:(UIButton *)sender
{
    NSString *phone = [[UTCache readProfile] objectForKey:@"phone"];
    [self.dataController requestVerifyCode:phone usage:USAGE_SETPWD WithSuccess:^(UTResult * _Nonnull result) {
        [self.codeBtn timeFailBeginFrom:60]; // 倒计时60s
        [self showToastView:@"短信验证码发送,请查收"];
    } failure:^(UTResult * _Nonnull result) {
        [self showToastView:result.failureResult];
    }];
    
}

-(void)showViewAfterResetPassword
{
    MMPopupCompletionBlock completeBlock = ^(MMPopupView *popupView, BOOL finished){
        [self.navigationController popViewControllerAnimated:YES];
    };
    MMAlertView *alertView = [[MMAlertView alloc]initWithConfirmTitle:@"修改密码成功" detail:@"请记住您的密码"];
    [alertView showWithBlock:completeBlock];
}


//点击输入框外 收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.passwordInput resignFirstResponder];
    [self.verifyCodeInput resignFirstResponder];
}

@end
