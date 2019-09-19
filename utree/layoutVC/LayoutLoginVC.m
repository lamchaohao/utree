//
//  LayoutLoginVC.m
//  utree
//
//  Created by 科研部 on 2019/7/31.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "LayoutLoginVC.h"
#import "MyLayout.h"
#import "ZBSegmentView.h"
#import "AutoScaleFrameMain.h"
#import "ZBSegmentView.h"
#import "ZBTextField.h"
@interface LayoutLoginVC ()

@end

@implementation LayoutLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];

}
- (void)loadView{
//    [super loadView];
//    [self initView];

}

-(void)initView{
    
   MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    
    self.view = rootLayout;
    
    self.view.backgroundColor=[UIColor whiteColor];
  
    UIImageView *phoneIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_phone_account"]];
    [phoneIcon setLayoutMargins:UIEdgeInsetsMake(5, 4, 4, 12)];
    UIImageView *pswIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_password_lock"]];
    [pswIcon setLayoutMargins:UIEdgeInsetsMake(5, 4, 4, 12)];
    

    ZBTextField *accountInput = [ZBTextField new];
    
    [accountInput setPlaceholder:@"请输入手机号码"];
    [accountInput setBorderStyle:UITextBorderStyleNone];
    [accountInput setLeftView:phoneIcon];
    accountInput.leftViewMode = UITextFieldViewModeAlways;
    accountInput.myLeft=accountInput.myRight=25;
    accountInput.myHeight=42;
    [accountInput setClearButtonMode:UITextFieldViewModeWhileEditing];

    ZBTextField *passwordInput = [ZBTextField new];
    
    [passwordInput setPlaceholder:@"请输入密码"];
    [passwordInput setBorderStyle:UITextBorderStyleNone];
    [passwordInput setLeftView:pswIcon];
    passwordInput.leftViewMode = UITextFieldViewModeAlways;
    passwordInput.topPos.equalTo(accountInput.bottomPos).offset(36);
    passwordInput.myLeft=passwordInput.myRight=25;
    passwordInput.myHeight=42;
    [passwordInput setClearButtonMode:UITextFieldViewModeWhileEditing];

    
    UIButton *btnLogin= [[UIButton alloc]init];
    [btnLogin setTitle:@"登录" forState:UIControlStateNormal];
    
    btnLogin.myTop = 44;
    btnLogin.myHeight = 70;
    btnLogin.myLeft=btnLogin.myRight=25;
    btnLogin.myCenterX=0;
    [btnLogin setBackgroundImage:[UIImage imageNamed:@"bg_round_conner"] forState:UIControlStateNormal];
    
    [self.view addSubview:accountInput];
    [self.view addSubview:passwordInput];
    [self.view addSubview:btnLogin];
    
}


@end
