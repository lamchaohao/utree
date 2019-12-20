//
//  SMSLoginVC.h
//  utree
//
//  Created by 科研部 on 2019/10/28.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBTextField.h"
#import "BaseViewController.h"
#import "SMSLoginDC.h"
#import "SMSViewManager.h"
#import "SmsLoginView.h"
NS_ASSUME_NONNULL_BEGIN

@protocol SMSLoginDelegate<NSObject>

@optional-(void)smsLoginSuccessWithUserId:(NSString *)userId;

@end

@interface SMSLoginVC : BaseViewController

@property(nonatomic, assign) id<SMSLoginDelegate> smsLoginDelegate;
@property(nonatomic, strong)SMSLoginDC *dataController;
@property(nonatomic, strong)SMSViewManager *viewManager;
@property(nonatomic, strong)SmsLoginView *rootView;
@end



NS_ASSUME_NONNULL_END
