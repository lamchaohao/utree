//
//  BaseViewController.m
//  utree
//
//  Created by 科研部 on 2019/10/14.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "MMAlertView.h"
#import "UTCache.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

    UINavigationBar *navBar = self.navigationController.navigationBar;
    if (navBar==nil) {
        navBar = [UINavigationBar appearance];
    }
    UIImage *navImg =[UIImage imageNamed:@"topbar_bg"];
    navImg = [navImg resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    NSDictionary *dict = @{
                       NSForegroundColorAttributeName : [UIColor whiteColor]
                       };
    [navBar setTitleTextAttributes:dict];
    /** 设置导航栏背景图片 */
    [navBar setBackgroundImage:navImg forBarMetrics:UIBarMetricsDefault];

    /** 设置返回箭头颜色 */
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    //改变UITabBarItem字体颜色 //UITextAttributeTextColor
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.rootTabbarCtr.tabBar.tintColor = [UIColor blackColor];
}

- (void)showAlertMessage:(NSString *)message title:(NSString *)title
{
    MMAlertView *alertView = [[MMAlertView alloc]initWithConfirmTitle:title detail:message];
    [alertView show];
}


-(void)showToastView:(NSString *)message
{
    UIView *toastView = [self.view toastViewForMessage:message title:nil image:nil style:nil];
    toastView.myCenterY=0;
    toastView.myCenterX=0;
    [self.view showToast:toastView duration:[CSToastManager defaultDuration] position:CSToastPositionCenter completion:nil];
}

- (BOOL)isBlankString:(NSString *)str {
    NSString *string = str;
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    
    return NO;
}

-(NSString *)getUserId
{
    return [[UTCache readProfile] objectForKey:@"teacherId"];
}


@end
