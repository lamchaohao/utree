//
//  ModifyPswVC.h
//  utree
//
//  Created by 科研部 on 2019/8/6.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBTextField.h"
NS_ASSUME_NONNULL_BEGIN

@interface ModifyPswVC : UIViewController
@property(strong,atomic)ZBTextField *accountInput;

@property(strong,atomic)ZBTextField *verifyCodeInput;

@property(strong,atomic)ZBTextField *pswTextInput;

@property(strong,atomic)UIButton *modifyBtn;
@property(strong,atomic)UIButton *accountAndPswLoginBtn;
@end

NS_ASSUME_NONNULL_END
