//
//  ChangePhoneVC.m
//  utree
//
//  Created by 科研部 on 2019/12/26.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ChangePhoneVC.h"
#import "ZBTextField.h"
#import "ZBVerifyCodeButton.h"
#import "ModifyPswDC.h"
#import "MMAlertView.h"

@interface ChangePhoneVC ()
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *tipLabel;
@property(nonatomic,strong)UIButton *nextStepBtn;
@property(nonatomic,strong)ZBTextField *verifyCodeInput;
@property(nonatomic,strong)ZBTextField *phoneCodeInput;

@property(nonatomic,strong)ZBTextField *otherPhoneInput;
// 获取验证码按钮
@property (nonatomic, weak) ZBVerifyCodeButton *codeBtn;
@property (nonatomic, weak) ZBVerifyCodeButton *changeNumCodeBtn;
@property (nonatomic, strong)ModifyPswDC *dataController;
@property (nonatomic, assign)BOOL isVerifyNewPhone;
@property (nonatomic, strong)NSString *theOldCode;
@end

@implementation ChangePhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手机";
    self.dataController = [[ModifyPswDC alloc]init];
    [self createView];
    // Do any additional setup after loading the view.
}

-(void)createView
{
    
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    self.view = rootLayout;
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleLabel = [[UILabel alloc]init];
    [_titleLabel setFont:[UIFont systemFontOfSize:26]];
    [_titleLabel setWrapContentSize:YES];
    _titleLabel.myTop=40+iPhone_Top_NavH;
    _titleLabel.myLeft = 31;
    _titleLabel.text=@"身份校验";
    
    self.tipLabel = [[UILabel alloc]init];
    [_tipLabel setFont:[UIFont systemFontOfSize:15]];
    [_tipLabel setWrapContentSize:YES];
    _tipLabel.myTop=15;
    _tipLabel.myLeft = 31;
    _tipLabel.text=@"验证当前手机号";
    _tipLabel.textColor = [UIColor_ColorChange colorWithHexString:SecondTextColor];
    
    
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
    [codeBtn addTarget:self action:@selector(onOldPhoneVerifyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_verifyCodeInput addSubview:codeBtn];
    self.codeBtn=codeBtn;
    
    
    self.nextStepBtn= [[UIButton alloc]init];
    [_nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    
    _nextStepBtn.myTop = 96;
    _nextStepBtn.myHeight = 70;
    _nextStepBtn.myLeft=_nextStepBtn.myRight=25;
    _nextStepBtn.myCenterX=0;
    [_nextStepBtn setBackgroundImage:[UIImage imageNamed:@"bg_round_conner"] forState:UIControlStateNormal];
    [_nextStepBtn addTarget:self action:@selector(onConfirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rootLayout addSubview:_titleLabel];
    [rootLayout addSubview:_tipLabel];
    [rootLayout addSubview:_verifyCodeInput];
//    [rootLayout addSubview:_passwordInput];
    [rootLayout addSubview:_nextStepBtn];
    
}

-(void)createNewView
{
    UIImageView *phoneIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_phone_account"]];
    [phoneIcon setLayoutMargins:UIEdgeInsetsMake(5, 4, 4, 12)];
    UIImageView *verifyIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_verify_code"]];
    [verifyIcon setLayoutMargins:UIEdgeInsetsMake(5, 4, 4, 12)];
    
    _otherPhoneInput = [ZBTextField new];
    [_otherPhoneInput setPlaceholder:@"请输入新的手机号"];
    [_otherPhoneInput setBorderStyle:UITextBorderStyleNone];
    [_otherPhoneInput setLeftView:phoneIcon];
    _otherPhoneInput.leftViewMode = UITextFieldViewModeAlways;
    //    _passwordInput.topPos.equalTo(_verifyCodeInput.bottomPos).offset(36);
    _otherPhoneInput.myTop=36;
    _otherPhoneInput.myLeft=_otherPhoneInput.myRight=25;
    _otherPhoneInput.myHeight=42;
    [_otherPhoneInput setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    _phoneCodeInput = [ZBTextField new];
    
    [_phoneCodeInput setPlaceholder:@"请输入验证码"];
    [_phoneCodeInput setBorderStyle:UITextBorderStyleNone];
    [_phoneCodeInput setLeftView:verifyIcon];
    _phoneCodeInput.leftViewMode = UITextFieldViewModeAlways;
    _phoneCodeInput.myLeft=_phoneCodeInput.myRight=25;
    _phoneCodeInput.myHeight=42;
    _phoneCodeInput.myTop=55;
    [_phoneCodeInput setClearButtonMode:UITextFieldViewModeNever];// 不显示右边清除叉号
    _phoneCodeInput.keyboardType = UIKeyboardTypeNumberPad; // 数字键盘
    
    // 获取验证码按钮
    ZBVerifyCodeButton *codeBtn = [ZBVerifyCodeButton buttonWithType:UIButtonTypeCustom];
    codeBtn.frame = CGRectMake(ScreenWidth - 70 - 50, 0, 70, 30);
    [codeBtn addTarget:self action:@selector(onNewPhoneVerifyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_phoneCodeInput addSubview:codeBtn];
    self.changeNumCodeBtn=codeBtn;
    
    
}

-(void)switchToVerifyNewPhoneView
{
    [self createNewView];
    [_verifyCodeInput removeFromSuperview];
    [self.nextStepBtn removeFromSuperview];
    [self.view addSubview:_otherPhoneInput];
    [self.view addSubview:_phoneCodeInput];
    [self.view addSubview:_nextStepBtn];
    
    self.titleLabel.text = @"更换手机号";
    self.tipLabel.text = @"请验证新手机号";
    [self.nextStepBtn setTitle:@"确定" forState:UIControlStateNormal];
    
}

-(void)onConfirmBtnClick:(id)sender
{
    
    if (_isVerifyNewPhone) {
        
        NSString *verifyCode = self.phoneCodeInput.text;
        NSString *phone = self.otherPhoneInput.text;
        
        [self.dataController changeNewPhoneWithOldCode:self.theOldCode newPhone:phone andNewCode:verifyCode WithSuccess:^(UTResult * _Nonnull result) {
            [self showViewAfterResetPhone];
        } failure:^(UTResult * _Nonnull result) {
            [self showToastView:result.failureResult];
        }];
        
    }else{
        NSString *verifyCode = self.verifyCodeInput.text;
        [self.dataController verifyOldPhoneWithCode:verifyCode WithSuccess:^(UTResult * _Nonnull result) {
            self.theOldCode = verifyCode;
            self.isVerifyNewPhone = YES;
            [self switchToVerifyNewPhoneView];
        } failure:^(UTResult * _Nonnull result) {
            [self showToastView:result.failureResult];
        }];
        
    }
    
}


-(void)onOldPhoneVerifyBtnClick:(UIButton *)sender
{
    
    NSString *phone = [[UTCache readProfile] objectForKey:@"phone"];
    [self.dataController requestVerifyCode:phone usage:USAGE_CHANGEPHONE WithSuccess:^(UTResult * _Nonnull result) {
        [self.codeBtn timeFailBeginFrom:60]; // 倒计时60s
        [self.tipLabel setText:@"短信验证码发送,请查收"];
    } failure:^(UTResult * _Nonnull result) {
        [self showToastView:result.failureResult];
    }];
    
}

-(void)onNewPhoneVerifyBtnClick:(id)send
{
    NSString *phone = self.otherPhoneInput.text;
    [self.dataController requestVerifyCode:phone usage:USAGE_CHANGEPHONE WithSuccess:^(UTResult * _Nonnull result) {
        [self.changeNumCodeBtn timeFailBeginFrom:60]; // 倒计时60s
        [self.tipLabel setText:@"短信验证码发送,请查收"];
    } failure:^(UTResult * _Nonnull result) {
        [self showToastView:result.failureResult];
    }];
}


-(void)showViewAfterResetPhone
{
    MMPopupCompletionBlock completeBlock = ^(MMPopupView *popupView, BOOL finished){
        [self.navigationController popViewControllerAnimated:YES];
    };
    MMAlertView *alertView = [[MMAlertView alloc]initWithConfirmTitle:@"更换手机号码成功" detail:@"请记住您新的手机号码"];
    [alertView showWithBlock:completeBlock];
}


//点击输入框外 收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.otherPhoneInput resignFirstResponder];
    [self.verifyCodeInput resignFirstResponder];
    [self.changeNumCodeBtn resignFirstResponder];
}

@end
