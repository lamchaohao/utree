//
//  PhoneNumStateVCViewController.m
//  utree
//
//  Created by 科研部 on 2019/9/17.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "PhoneNumStateVC.h"
#import "UTCache.h"
#import "ChangePhoneVC.h"

@interface PhoneNumStateVC ()
@property(nonatomic,strong)NSString *accountPhoneNum;
@end

@implementation PhoneNumStateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手机";
    [self loadData];
    [self createView];
}


-(void)createView
{
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
//    rootLayout.frame = self.view.bounds;
    self.view = rootLayout;
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *phoneImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, 116, 153)];
    [phoneImg setImage:[UIImage imageNamed:@"bind_phone"]];
    phoneImg.myCenterX=10;
    phoneImg.myTop = 60 + iPhone_Top_NavH;
    
    UILabel *phoneNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 120, ScreenWidth, 46)];
    [phoneNumLabel setTextColor:[UIColor_ColorChange colorWithHexString:@"333333"]];
    [phoneNumLabel setFont:[UIFont systemFontOfSize:20]];
    phoneNumLabel.myTop=60;
    phoneNumLabel.myCenterX=0;
    [phoneNumLabel setWrapContentSize:YES];
    NSString *phoneStr = [NSString stringWithFormat:@"当前绑定的手机号:%@",self.accountPhoneNum];
    [phoneNumLabel setText:phoneStr];
    
    UIButton *editPhoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 458, ScreenWidth*0.8285, ScreenWidth*0.174)];
    [editPhoneBtn setTitle:@"修改手机号码" forState:UIControlStateNormal];
    [editPhoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editPhoneBtn setBackgroundImage:[UIImage imageNamed:@"bg_round_conner"] forState:UIControlStateNormal];
    editPhoneBtn.myLeft=editPhoneBtn.myRight=25;
    editPhoneBtn.myTop=95;
    [editPhoneBtn addTarget:self action:@selector(onEditPhoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phoneImg];
//     [self.view addSubview:rootLayout];
    [self.view addSubview:phoneNumLabel];
    [self.view addSubview:editPhoneBtn];
    
   
    
}

-(void)onEditPhoneBtnClick:(id)send
{
    ChangePhoneVC *changePhoneVC = [[ChangePhoneVC alloc]init];
           //注意是UIViewController调用hidesBottomBarWhenPushed而不是UINavigationController
    [self pushIntoWithoutNavChange:changePhoneVC];
}


- (void)loadData
{
    
    NSString *phone = [[UTCache readProfile] objectForKey:@"phone"];
    NSRange range =NSMakeRange(0, 2);
    if (phone.length>10) {
       range = NSMakeRange(3, 4);
    }
    self.accountPhoneNum = [phone stringByReplacingCharactersInRange:range withString:@"****"];
   
}


@end
