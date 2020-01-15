//
//  AppDelegate.h
//  utree
//
//  Created by 科研部 on 2019/7/26.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic, strong) UITabBarController *rootTabbarCtr;

-(void)toMainVC:(NSString *)userId;
-(void)toLoginVC;
@end

