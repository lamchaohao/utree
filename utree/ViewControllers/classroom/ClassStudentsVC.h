//
//  ClassPersonVCViewController.h
//  utree
//
//  Created by 科研部 on 2019/8/7.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassStudentsDC.h"
#import "StudentsViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ClassStudentsVC : UIViewController
//YES_--GridView
-(BOOL)switchToGridView;
-(void)switchToMultiChoice;

@property(nonatomic, strong)ClassStudentsDC *dataController;
@property(nonatomic, strong)StudentsViewModel *viewModel;
@end

NS_ASSUME_NONNULL_END
