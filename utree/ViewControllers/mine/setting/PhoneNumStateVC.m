//
//  PhoneNumStateVCViewController.m
//  utree
//
//  Created by 科研部 on 2019/9/17.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "PhoneNumStateVC.h"

@interface PhoneNumStateVC ()

@end

@implementation PhoneNumStateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手机";
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
    [phoneNumLabel setText:@"当前绑定的手机号:137****112"];
    
    UIButton *editPhoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 458, ScreenWidth*0.8285, ScreenWidth*0.174)];
    [editPhoneBtn setTitle:@"修改手机号码" forState:UIControlStateNormal];
    [editPhoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editPhoneBtn setBackgroundImage:[UIImage imageNamed:@"bg_round_conner"] forState:UIControlStateNormal];
    editPhoneBtn.myLeft=editPhoneBtn.myRight=25;
    editPhoneBtn.myTop=95;
    
    [self.view addSubview:phoneImg];
//     [self.view addSubview:rootLayout];
    [self.view addSubview:phoneNumLabel];
    [self.view addSubview:editPhoneBtn];
    
   
    
}


@end
