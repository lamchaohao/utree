//
//  BaseSecondVC.m
//  utree
//
//  Created by 科研部 on 2019/9/6.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "BaseSecondVC.h"

@interface BaseSecondVC ()

@end

@implementation BaseSecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _showNavWhenDisappear = YES;
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    NSDictionary *dict = @{
                           NSForegroundColorAttributeName : [UIColor_ColorChange blackColor]
                           };
    [navBar setTitleTextAttributes:dict];
    
    [self.navigationController setNavigationBarHidden:NO];
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillAppear:(BOOL)animated
{
   
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if (!_showNavWhenDisappear) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
        
        UINavigationBar *navBar = [UINavigationBar appearance];
        UIImage *navImg =[UIImage imageNamed:@"topbar_bg"];
        navImg = [navImg resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
        NSDictionary *dict = @{
                               NSForegroundColorAttributeName : [UIColor whiteColor]
                               };
        [navBar setTitleTextAttributes:dict];
        /** 设置导航栏背景图片 */
        [navBar setBackgroundImage:navImg forBarMetrics:UIBarMetricsDefault];
        
        
        /** 设置返回箭头颜色 */
        self.navigationController.navigationBar.tintColor = [UIColor_ColorChange blackColor];
        
         /** 设置取消导航栏返回按钮的字 */
//        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
//        
//        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    }
    
}

-(void)pushIntoWithoutNavChange:(UIViewController *)viewController
{
    _showNavWhenDisappear =  YES;
    [self.navigationController pushViewController:viewController animated:YES];
}



@end
