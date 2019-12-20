//
//  SMSLoginVC.m
//  utree
//
//  Created by 科研部 on 2019/10/28.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "SMSLoginVC.h"
#import "SmsLoginView.h"
#import "MMAlertView.h"
@interface SMSLoginVC ()<SmsLoginDataDelegate,SMSLoginViewResponser>

@end

@implementation SMSLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
}

-(void)loadView{
    self.rootView = [[SmsLoginView alloc]init];
    self.view =self.rootView;
    self.rootView.responser=self;
}

-(void)initData
{
    self.dataController = [[SMSLoginDC alloc]init];
    self.dataController.delegate = self;
    self.viewManager = [[SMSViewManager alloc]init];
    [self.rootView bindWithViewManger:self.viewManager];
}

- (void)onPasswordLoginPress
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onVerifyLoginPress:(NSString *)account code:(NSString *)code
{
    [self.dataController requestLoginByVerifycode:account code:code WithSuccess:^(UTResult * _Nonnull result) {
        if([self.smsLoginDelegate respondsToSelector:@selector(smsLoginSuccessWithUserId:)])
        {
            [self.smsLoginDelegate smsLoginSuccessWithUserId:[self getUserId]];
              [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(UTResult * _Nonnull result) {
        [self showAlertMessage:@"" title:result.failureResult];
    }];
}

- (void)onGetVerifyCodePress:(NSString *)account
{
    [self.dataController requestVerifyCodeForAccount:account usage:USAGE_LOGIN WithSuccess:^(UTResult * _Nonnull result) {
        [self.viewManager showCountDownFrom:60];
    } failure:^(UTResult * _Nonnull result) {
        [self.viewManager showCountDownFrom:3];
    }];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    [self.viewManager shrinkKeyboard];
}


@end
