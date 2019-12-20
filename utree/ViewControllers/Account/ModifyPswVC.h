//
//  ModifyPswVC.h
//  utree
//
//  Created by 科研部 on 2019/8/6.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ZBTextField.h"
#import "ModifyPswDC.h"
#import "ModifyPswViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ModifyPswVC : BaseViewController


@property(nonatomic,strong)ModifyPswDC *dataController;
@property(nonatomic,strong)ModifyPswViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
