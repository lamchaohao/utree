//
//  BaseSecondVC.m
//  utree
//
//  Created by 科研部 on 2019/9/6.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "BaseSecondVC.h"
#import "AppDelegate.h"
@interface BaseSecondVC ()

@end

@implementation BaseSecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _showNavigationBarImageWhenDisappear = NO;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    /** 设置返回箭头颜色 */
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    //改变UITabBarItem字体颜色 //UITextAttributeTextColor
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.rootTabbarCtr.tabBar.tintColor = [UIColor blackColor];
    
    UINavigationBar *navBar =self.navigationController.navigationBar;
    //[UINavigationBar appearance];
    [navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    NSDictionary *dict = @{
                         NSForegroundColorAttributeName : [UIColor blackColor]
                         };
    [navBar setTitleTextAttributes:dict];
    
    if (_diasblePopGesture) {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
             self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
   //禁止页面左侧滑动返回，注意，如果仅仅需要禁止此单个页面返回，还需要在viewWillDisapper下开放侧滑权限
   // 禁用返回手势
   
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
}


-(void)pushIntoWithoutNavChange:(UIViewController *)viewController
{
    _showNavigationBarImageWhenDisappear =  NO;
    [self.navigationController pushViewController:viewController animated:YES];
}



@end
