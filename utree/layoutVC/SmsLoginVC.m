//
//  SmsLoginVCViewController.m
//  utree
//
//  Created by 科研部 on 2019/8/6.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "SmsLoginVC.h"
#import "ThemeConfig.h"
#import "AutoScaleFrameMain.h"
#import "ZBSegmentView.h"
#import "ZBVerifyCodeButton.h"
@interface SmsLoginVC ()
@property(nonatomic,weak)ZBVerifyCodeButton *codeBtn;
@end

@implementation SmsLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)loadView{
    [self initView];
}


-(void)initView{
    
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
//    rootLayout.insetsPaddingFromSafeArea = UIRectEdgeAll;//通知栏安全区域不会使用
    rootLayout.backgroundColor = [UIColor whiteColor];
    self.view = rootLayout;
    
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
    
    
    NSArray *titles= [[NSArray alloc]initWithObjects:@"短信验证码登录", nil];
    CGRect segmentFrame= asKFrame(0, 0, 170, 56, asKFrameXY);
    ZBSegmentView *segmentView = [[ZBSegmentView alloc]initWithFrame:segmentFrame withTitleArray:titles];
    
    segmentView.topPos.equalTo(@-70);
    segmentView.leftPos.equalTo(@30);
    [segmentView setReturnBlock:^(NSInteger index) {
        
    }];
    
    [rootLayout addSubview:loginHeaderImageView];
    [rootLayout addSubview:headerLogo];
    [rootLayout addSubview:segmentView];
   
    
    [self initLoginView];
}

-(void)initLoginView{
    
    UIImageView *phoneIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_phone_account"]];
    [phoneIcon setLayoutMargins:UIEdgeInsetsMake(5, 4, 4, 12)];
    UIImageView *verifyIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_verify_code"]];
    [verifyIcon setLayoutMargins:UIEdgeInsetsMake(5, 4, 4, 12)];
    
    
    _accountInput = [ZBTextField new];
    
    [_accountInput setPlaceholder:@"请输入手机号码"];
    [_accountInput setBorderStyle:UITextBorderStyleNone];
    [_accountInput setLeftView:phoneIcon];
    _accountInput.leftViewMode = UITextFieldViewModeAlways;
    _accountInput.myLeft=_accountInput.myRight=25;
    _accountInput.myHeight=42;
    _accountInput.myTop=55;
    [_accountInput setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    _verifyCodeInput = [ZBTextField new];
    
    [_verifyCodeInput setPlaceholder:@"请输入短信验证码"];
    [_verifyCodeInput setBorderStyle:UITextBorderStyleNone];
    [_verifyCodeInput setLeftView:verifyIcon];
    _verifyCodeInput.leftViewMode = UITextFieldViewModeAlways;
    _verifyCodeInput.topPos.equalTo(_accountInput.bottomPos).offset(36);
    _verifyCodeInput.myLeft=_verifyCodeInput.myRight=25;
    _verifyCodeInput.myHeight=42;
    [_verifyCodeInput setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    ZBVerifyCodeButton *codeBtn = [ZBVerifyCodeButton buttonWithType:UIButtonTypeCustom];
    codeBtn.frame = CGRectMake(ScreenWidth - 60 - 50, 0, 60, 30);
    [codeBtn addTarget:self action:@selector(codeBtnVerification:) forControlEvents:UIControlEventTouchUpInside];
    [_verifyCodeInput addSubview:codeBtn];
    self.codeBtn=codeBtn;
    
    
    _loginBtn= [[UIButton alloc]init];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    _loginBtn.myTop = 44;
    _loginBtn.myHeight = 70;
    _loginBtn.myLeft=_loginBtn.myRight=25;
    _loginBtn.myCenterX=0;
    [_loginBtn setBackgroundImage:[UIImage imageNamed:@"bg_round_conner"] forState:UIControlStateNormal];
    
    
    
    _accountAndPswLoginBtn = [UIButton new];
    [_accountAndPswLoginBtn setTitle:@"账号密码登录" forState:UIControlStateNormal];
    [_accountAndPswLoginBtn setTitleColor:[UIColor_ColorChange colorWithHexString:PrimaryColor] forState:UIControlStateNormal];
    _accountAndPswLoginBtn.myCenterX=0;
    _accountAndPswLoginBtn.myBottom=0.6;
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
    
    [self.view addSubview:_accountInput];
    [self.view addSubview:_verifyCodeInput];
    [self.view addSubview:_loginBtn];
    [self.view addSubview:_accountAndPswLoginBtn];
    [self.view addSubview:tipsLabel];
}

-(void)changeToAccountLogin:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)codeBtnVerification:(UIButton *)sender
{
    [self.codeBtn timeFailBeginFrom:60]; // 倒计时60s
}

@end
