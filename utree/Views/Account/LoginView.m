//
//  LoginView.m
//  utree
//
//  Created by 科研部 on 2019/10/28.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "LoginView.h"
@interface LoginView()<LoginViewManagerDelegate,UITextFieldDelegate>

@end

@implementation LoginView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.orientation=MyOrientation_Vert;
        [self initView];
    }
    return self;
}

-(void)initView
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *loginHeaderImageView = [[UIImageView alloc]init];
    loginHeaderImageView.widthSize.equalTo(@(ScreenWidth));
    loginHeaderImageView.heightSize.equalTo(@150);
    [loginHeaderImageView setImage:[UIImage imageNamed:@"login_header"]];
    
    
    
    UIImageView *headerLogo = [UIImageView new];
    headerLogo.heightSize.equalTo(@114);
    headerLogo.widthSize.equalTo(@114);
    headerLogo.topPos.offset(-57);
    headerLogo.myRight=45;
    [headerLogo setImage:[UIImage imageNamed:@"utree_round"]];
    
    
    NSArray *titles= [[NSArray alloc]initWithObjects:@"登录",@"注册", nil];
    CGRect segmentFrame= CGRectMake(0, 0, 140, 56);
    _segmentView = [[ZBSegmentView alloc]initWithFrame:segmentFrame withTitleArray:titles];
    
    _segmentView.topPos.equalTo(@-70);
    _segmentView.leftPos.equalTo(@30);

   
    [self addSubview:loginHeaderImageView];
    [self addSubview:headerLogo];
    [self addSubview:_segmentView];

    __weak typeof(self) weakSelf = self;
    [_segmentView setReturnBlock:^(NSInteger index) {

        if(index==0){
            [weakSelf changeViewToLogin];
        }else{
            [weakSelf changeViewToRegister];
        }
        
    }];
    
    [self initLoginView];
    [self initRegisterView];
    [self changeViewToLogin];
}

-(void)initLoginView{
    
    UIImageView *phoneIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_phone_account"]];
    [phoneIcon setLayoutMargins:UIEdgeInsetsMake(5, 4, 4, 12)];
    UIImageView *pswIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_password_lock"]];
    [pswIcon setLayoutMargins:UIEdgeInsetsMake(5, 4, 4, 12)];
    
    //手机号码输入框
    _accountInput = [ZBTextField new];
    [_accountInput setPlaceholder:@"请输入手机号码"];
    [_accountInput setBorderStyle:UITextBorderStyleNone];
    [_accountInput setLeftView:phoneIcon];
    _accountInput.keyboardType = UIKeyboardTypeNumberPad;
    _accountInput.returnKeyType=UIReturnKeyContinue;
    _accountInput.leftViewMode = UITextFieldViewModeAlways;
    _accountInput.myLeft=_accountInput.myRight=25;
    _accountInput.myHeight=42;
    _accountInput.myTop=55;
    [_accountInput setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    //密码输入框
    _passwordInput = [ZBTextField new];
    [_passwordInput setPlaceholder:@"请输入密码"];
    [_passwordInput setBorderStyle:UITextBorderStyleNone];
    [_passwordInput setLeftView:pswIcon];
    _passwordInput.secureTextEntry = YES;
    _passwordInput.keyboardType = UIKeyboardTypeEmailAddress;
    _passwordInput.returnKeyType= UIReturnKeyDone;
    _passwordInput.leftViewMode = UITextFieldViewModeAlways;
    //1.关闭首字母大写
    [_passwordInput setAutocapitalizationType:UITextAutocapitalizationTypeNone];
//    2.关闭自动联想功能：
    [_passwordInput setAutocorrectionType:UITextAutocorrectionTypeNo];
    _passwordInput.topPos.equalTo(_accountInput.bottomPos).offset(36);
    _passwordInput.myLeft=_passwordInput.myRight=25;
    _passwordInput.myHeight=42;
    [_passwordInput setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    //登录按钮
    _loginBtn= [[UIButton alloc]init];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    _loginBtn.myTop = 44;
    _loginBtn.myHeight = 70;
    _loginBtn.myLeft=_loginBtn.myRight=25;
    _loginBtn.myCenterX=0;
    [_loginBtn setBackgroundImage:[UIImage imageNamed:@"bg_round_conner"] forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(loginBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    //短信登录按钮
    _smsLoginBtn = [UIButton new];
    [_smsLoginBtn setTitle:@"短信验证登录" forState:UIControlStateNormal];
    _smsLoginBtn.myCenterX=0;
//    _smsLoginBtn.myTop=14;
    _smsLoginBtn.myBottom=0.7;
    [_smsLoginBtn sizeToFit];
    [_smsLoginBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_smsLoginBtn setTitleColor:[UIColor_ColorChange colorWithHexString:SecondTextColor] forState:UIControlStateNormal];
    
    [_smsLoginBtn addTarget:self action:@selector(toSmsLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    //忘记密码按钮
    _forgotPswBtn = [UIButton new];
    [_forgotPswBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [_forgotPswBtn setTitleColor:[UIColor_ColorChange colorWithHexString:PrimaryColor] forState:UIControlStateNormal];
    _forgotPswBtn.myCenterX=0;
    _forgotPswBtn.myBottom=12;
    [_forgotPswBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_forgotPswBtn sizeToFit];
    [_forgotPswBtn addTarget:self action:@selector(toModifyPassword:) forControlEvents:UIControlEventTouchUpInside];
    
    _tipsLabel = [UILabel new];
    _tipsLabel.myCenterX=0;
    _tipsLabel.myBottom=12;
    [_tipsLabel setText:@"请使用提供给学校的手机号码注册/登录"];
    [_tipsLabel setFont:[UIFont systemFontOfSize:15]];
    [_tipsLabel sizeToFit];
    [_tipsLabel setTextColor:[UIColor_ColorChange colorWithHexString:UnselectedTextColor]];
    
    [self addSubview:_accountInput];
}


-(void) initRegisterView{
    UIImageView *verifyIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_verify_code"]];
    [verifyIcon setLayoutMargins:UIEdgeInsetsMake(5, 4, 4, 12)];
    _verifyCodeInput = [ZBTextField new];
    
    [_verifyCodeInput setPlaceholder:@"请输入验证码"];
    [_verifyCodeInput setBorderStyle:UITextBorderStyleNone];
    [_verifyCodeInput setLeftView:verifyIcon];
    _verifyCodeInput.keyboardType = UIKeyboardTypeNumberPad;
    _verifyCodeInput.returnKeyType=UIReturnKeyNext;
    _verifyCodeInput.leftViewMode = UITextFieldViewModeAlways;
    _verifyCodeInput.topPos.equalTo(_accountInput.bottomPos).offset(36);
    _verifyCodeInput.myLeft=_verifyCodeInput.myRight=25;
    _verifyCodeInput.myHeight=42;
    [_verifyCodeInput setClearButtonMode:UITextFieldViewModeWhileEditing];
    self.codeBtn = [ZBVerifyCodeButton buttonWithType:UIButtonTypeCustom];
    self.codeBtn.frame = CGRectMake(ScreenWidth - 60 - 50, 0, 60, 30);
    [self.codeBtn addTarget:self action:@selector(codeBtnVerificationPress:) forControlEvents:UIControlEventTouchUpInside];
    [_verifyCodeInput addSubview:self.codeBtn];
    
    _registerBtn= [UIButton new];
    [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    _registerBtn.myTop = 44;
    _registerBtn.myHeight = 70;
    _registerBtn.myLeft=_registerBtn.myRight=25;
    _registerBtn.myCenterX=0;
    
    [_registerBtn setBackgroundImage:[UIImage imageNamed:@"bg_round_conner"] forState:UIControlStateNormal];
    [_registerBtn addTarget:self action:@selector(registerBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_registerBtn];
}



-(void) changeViewToLogin{
//    [self.view addSubview:_accountInput];
    [_verifyCodeInput removeFromSuperview];
    [_passwordInput removeFromSuperview];
    [_registerBtn removeFromSuperview];
    self.passwordInput.delegate = self;

    [self addSubview:_passwordInput];
    [self addSubview:_loginBtn];
    [self addSubview:_smsLoginBtn];
    [self addSubview:_forgotPswBtn];
    [self addSubview:_tipsLabel];
   
}

-(void)changeViewToRegister{
//    [_accountInput removeFromSuperview];
    [_passwordInput removeFromSuperview];
    [_loginBtn removeFromSuperview];
    [_smsLoginBtn removeFromSuperview];
    [_forgotPswBtn removeFromSuperview];
    [_tipsLabel removeFromSuperview];
    self.passwordInput.delegate=nil;
    [self addSubview:_verifyCodeInput];
    [self addSubview:_passwordInput];
    [self addSubview:_registerBtn];
    
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.accountInput resignFirstResponder];
    [self.passwordInput resignFirstResponder];
    [self.verifyCodeInput resignFirstResponder];
    
}

-(void)loginBtnPress:(id)sender
{
    [self.responser onLoginPress:self.accountInput.text password:self.passwordInput.text];
}

-(void)toSmsLogin:(id)sender
{
    [self.responser onChangeToSMSLogin];
}

-(void)toModifyPassword:(id)sender
{
    [self.responser onToUpdatePassword];
}

-(void)codeBtnVerificationPress:(id)sender
{
    [self.responser onGetVerifyCodePress:self.accountInput.text];
}

-(void)registerBtnPress:(id)sender
{
    [self.responser onRegister:self.accountInput.text password:self.passwordInput.text code:self.verifyCodeInput.text];
}

- (void)hideKeyboard
{
    [self.accountInput resignFirstResponder];
    [self.passwordInput resignFirstResponder];
    [self.verifyCodeInput resignFirstResponder];
}


-(void)showCountDownViewFrom:(int)begin
{
    [self.codeBtn timeFailBeginFrom:begin];
}

-(void)bindWithViewModel:(LoginViewModel *)viewModel
{
    viewModel.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.passwordInput resignFirstResponder];
    [self.responser onLoginPress:self.accountInput.text password:self.passwordInput.text];
    return YES;
}


@end
