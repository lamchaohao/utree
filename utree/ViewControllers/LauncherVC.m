//
//  LauncherVC.m
//  utree
//
//  Created by 科研部 on 2019/10/24.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "LauncherVC.h"
#import "YTKNetwork.h"
#import "UTCache.h"
#import "RefreshTokenApi.h"
#import "YTKUrlArgumentsFilter.h"
#import "AppDelegate.h"

@interface LauncherVC ()

@end

@implementation LauncherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self checkLogin];
}

-(void)checkLogin
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSString *accessToken=[UTCache readToken];
    if (accessToken) {
        RefreshTokenApi *api = [[RefreshTokenApi alloc]initWithToken:accessToken];
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            NSDictionary *json = [request responseObject];
            NSNumber *code = [json objectForKey:@"code"];
            if (code.intValue==10000) {
                NSString *token = [[json objectForKey:@"result"] objectForKey:@"token"];
                [UTCache saveToken:token];
                [self setupRequestFilters:token];
                [appDelegate toMainVC:[[UTCache readProfile] objectForKey:@"teacherId"]];
            }else{
                [appDelegate toLoginVC];
            }
            
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [appDelegate toLoginVC];
        }];
    }else{
        [appDelegate toLoginVC];
    }
}

//统一为网络请求加上一些参数
- (void)setupRequestFilters:(NSString *)token {
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    YTKUrlArgumentsFilter *urlFilter = [YTKUrlArgumentsFilter filterWithArguments:@{@"version": appVersion,@"token":token}];
    [config addUrlFilter:urlFilter];
}



@end
