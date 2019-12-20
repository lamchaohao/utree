//
//  MainLogin.h
//  utree
//
//  Created by 科研部 on 2019/8/1.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ZBTextField.h"
#import "BaseViewController.h"
#import "ZBSegmentView.h"
#import "LoginDataController.h"
#import "LoginView.h"
NS_ASSUME_NONNULL_BEGIN

@protocol LoginDelegate<NSObject>

@optional
-(void)loginSuccessWithUser:(NSString *)userId;

@end

@interface MainLoginVC : BaseViewController

@property(nonatomic, assign) id<LoginDelegate> delegate;
@property(nonatomic,strong)LoginDataController *dataController;
@property(nonatomic,strong)LoginViewModel *viewModel;
@property(nonatomic,strong) NSMutableArray  *sortStudentList;
@end

NS_ASSUME_NONNULL_END
