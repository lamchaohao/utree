//
//  AttendanceVC.h
//  utree
//
//  Created by 科研部 on 2019/8/15.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttendaceDC.h"
#import "AttendanceViewModel.h"
#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface AttendanceVC : BaseViewController

@property(nonatomic,strong)AttendaceDC *dataController;

@property(nonatomic,strong)AttendanceViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
