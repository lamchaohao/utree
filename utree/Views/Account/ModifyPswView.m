//
//  ModifyPswView.m
//  utree
//
//  Created by 科研部 on 2019/10/29.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ModifyPswView.h"
#import "ZBSegmentView.h"

@interface ModifyPswView()<ModifyPswViewManagerDelegate>

@end

@implementation ModifyPswView

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

    UIImageView *loginHeaderImageView = [[UIImageView alloc]init];
    loginHeaderImageView.widthSize.equalTo(@(ScreenWidth));
    loginHeaderImageView.heightSize.equalTo(@150);
    [loginHeaderImageView setImage:[UIImage imageNamed:@"login_header"]];
    
    
    
    UIImageView *headerLogo = [UIImageView new];
    headerLogo.heightSize.equalTo(@114);
    headerLogo.widthSize.equalTo(@114);
    //    headerLogo.leftPos.equalTo(loginHeaderImageView.centerXPos).offset(36);
    headerLogo.topPos.offset(-57);
    headerLogo.myRight=45;
    [headerLogo setImage:[UIImage imageNamed:@"utree_round"]];
    
    
    NSArray *titles= [[NSArray alloc]initWithObjects:@"忘记密码", nil];
    CGRect segmentFrame= CGRectMake(0, 0, 100, 56);
    ZBSegmentView *segmentView = [[ZBSegmentView alloc]initWithFrame:segmentFrame withTitleArray:titles];
    
    segmentView.topPos.equalTo(@-70);
    segmentView.leftPos.equalTo(@30);
    [segmentView setReturnBlock:^(NSInteger index) {
        
    }];
    
    [self addSubview:loginHeaderImageView];
    [self addSubview:headerLogo];
    [self addSubview:segmentView];
    
    
    [self initLoginView];
}

-(void)initLoginView{
    
    UIImageView *phoneIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_phone_account"]];
    [phoneIcon setLayoutMargins:UIEdgeInsetsMake(5, 4, 4, 12)];
    UIImageView *pswIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_password_lock"]];
    [pswIcon setLayoutMargins:UIEdgeInsetsMake(5, 4, 4, 12)];
    UIImageView *verifyIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_verify_code"]];
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
    
    //验证码输入框
    _verifyCodeInput = [ZBTextField new];
    [_verifyCodeInput setPlaceholder:@"请输入短信验证码"];
    [_verifyCodeInput setBorderStyle:UITextBorderStyleNone];
    [_verifyCodeInput setLeftView:verifyIcon];
    _verifyCodeInput.keyboardType = UIKeyboardTypeNumberPad;
    _verifyCodeInput.returnKeyType=UIReturnKeyContinue;
    _verifyCodeInput.leftViewMode = UITextFieldViewModeAlways;
    _verifyCodeInput.topPos.equalTo(_accountInput.bottomPos).offset(36);
    _verifyCodeInput.myLeft=_verifyCodeInput.myRight=25;
    _verifyCodeInput.myHeight=42;
    [_verifyCodeInput setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    _verifyCodeBtn = [ZBVerifyCodeButton buttonWithType:UIButtonTypeCustom];
    _verifyCodeBtn.frame = CGRectMake(ScreenWidth - 60 - 50, 0, 60, 30);
    [_verifyCodeBtn addTarget:self action:@selector(codeBtnVerification:) forControlEvents:UIControlEventTouchUpInside];
    [_verifyCodeInput addSubview:_verifyCodeBtn];
    
    
    //密码输入框
    _pswTextInput = [[ZBTextField alloc]init];
    [_pswTextInput setPlaceholder:@"请输入新密码"];
    [_pswTextInput setBorderStyle:UITextBorderStyleNone];
    [_pswTextInput setLeftView:pswIcon];
    _pswTextInput.secureTextEntry = YES;
    _pswTextInput.keyboardType = UIKeyboardTypeEmailAddress;
    _pswTextInput.returnKeyType= UIReturnKeyGo;
    _pswTextInput.leftViewMode = UITextFieldViewModeAlways;
    //1.关闭首字母大写
    [_pswTextInput setAutocapitalizationType:UITextAutocapitalizationTypeNone];
//    2.关闭自动联想功能：
    [_pswTextInput setAutocorrectionType:UITextAutocorrectionTypeNo];
    _pswTextInput.topPos.equalTo(_verifyCodeInput.bottomPos).offset(36);
    _pswTextInput.myLeft=_pswTextInput.myRight=25;
    _pswTextInput.myHeight=42;
    [_pswTextInput setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    //确认按钮
    _modifyBtn= [[UIButton alloc]init];
    [_modifyBtn setTitle:@"确定" forState:UIControlStateNormal];
    _modifyBtn.myTop = 44;
    _modifyBtn.myHeight = 70;
    _modifyBtn.myLeft=_modifyBtn.myRight=25;
    _modifyBtn.myCenterX=0;
    [_modifyBtn setBackgroundImage:[UIImage imageNamed:@"bg_round_conner"] forState:UIControlStateNormal];
    [_modifyBtn addTarget:self action:@selector(updatePswPress:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //切换到账号登录按钮
    _accountAndPswLoginBtn = [UIButton new];
    [_accountAndPswLoginBtn setTitle:@"账号密码登录" forState:UIControlStateNormal];
    [_accountAndPswLoginBtn setTitleColor:[UIColor_ColorChange colorWithHexString:PrimaryColor] forState:UIControlStateNormal];
    _accountAndPswLoginBtn.myCenterX=0;
    _accountAndPswLoginBtn.myBottom=0.7;
    [_accountAndPswLoginBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_accountAndPswLoginBtn sizeToFit];
    
    [_accountAndPswLoginBtn addTarget:self action:@selector(changeToAccountLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *tipsLabel = [UILabel new];
    tipsLabel.myCenterX=0;
    tipsLabel.myBottom=12;
    [tipsLabel setText:@"请使用提供给学校的手机号码注册/登录"];
    [tipsLabel setFont:[UIFont systemFontOfSize:15]];
    [tipsLabel sizeToFit];
    [tipsLabel setTextColor:[UIColor_ColorChange colorWithHexString:UnselectedTextColor]];
    
    [self addSubview:_accountInput];
    [self addSubview:_verifyCodeInput];
    [self addSubview:_pswTextInput];
    [self addSubview:_modifyBtn];
    [self addSubview:_accountAndPswLoginBtn];
    [self addSubview:tipsLabel];
}

-(void)changeToAccountLogin:(UIButton *)sender{
    [self.responser onChangeToLogin];
}

-(void)updatePswPress:(UIButton *)sender
{
    [self.responser onModifyBtnPress:self.accountInput.text password:self.pswTextInput.text code:self.verifyCodeInput.text];
}

-(void)codeBtnVerification:(id)sender
{
    [self.responser onRequestVerifyCode:self.accountInput.text];
}

-(void)hideKeyboard
{
    [self.accountInput resignFirstResponder];
    [self.pswTextInput resignFirstResponder];
    [self.verifyCodeInput resignFirstResponder];

}

-(void)bindWithViewModel:(ModifyPswViewModel *)viewModel
{
    viewModel.viewDelegate=self;
}

- (void)showCountDownViewFrom:(int)begin
{
    [self.verifyCodeBtn timeFailBeginFrom:begin];
}



@end
