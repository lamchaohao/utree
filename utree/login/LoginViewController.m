//
//  LoginViewController.m
//  utree
//
//  Created by 科研部 on 2019/7/26.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginTabViewController.h"
#import "RegisterTabVC.h"
//#import "Masonry.h"
#import "AutoScaleFrameMain.h"
#import "ZBSegmentView.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    
}

-(void)initView{
    self.view.backgroundColor=UIColor.whiteColor;
//    NSString *imagePath =[NSString stringWithFormat:@"login_header"];
//    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    //initWithFrame:CGRectMake(0, 44, 414, 136)
    
    UIImageView *loginHeaderImageView = [[UIImageView alloc] init];
    [loginHeaderImageView setImage:[UIImage imageNamed:@"login_header"]];
    //initWithFrame:CGRectMake(255, 123, 114, 114)
    UIImageView *headerLogo = [[UIImageView alloc]init];
    
    [headerLogo setImage:[UIImage imageNamed:@"utree_round"]];
    
    loginHeaderImageView.frame=asKFrame(0, 0, ScreenWidth, 150,asKFrameXY);
//    headerLogo.frame=asKFrame(255, 100, 114, 114,asKFrameXY);

    CGRect segmentFrame= asKFrame(30, 120, 140, 56, asKFrameXY);
    NSArray *titles= [[NSArray alloc]initWithObjects:@"登录",@"注册", nil];
    
    ZBSegmentView *segmentView = [[ZBSegmentView alloc]initWithFrame:segmentFrame withTitleArray:titles];
    
    [self.view addSubview:loginHeaderImageView];
    [self.view addSubview:headerLogo];
    [self.view addSubview:segmentView];
   
//    [headerLogo mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(100).equalTo(loginHeaderImageView);
//    }];
    
    LoginTabViewController *loginTabVC = [LoginTabViewController alloc];
    RegisterTabVC *registerTabVC = [RegisterTabVC alloc];
    
    loginTabVC.view.hidden=NO;
    registerTabVC.view.hidden=YES;
    
    [self addChildViewController:loginTabVC];
    [self addChildViewController:registerTabVC];
    [self.view addSubview:loginTabVC.view];
    [self.view addSubview:registerTabVC.view];
    
    [segmentView setReturnBlock:^(NSInteger index) {
        registerTabVC.view.hidden=(index==0);
        loginTabVC.view.hidden=(index==1);
        NSLog(@"setReturnBlock");
    }];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
