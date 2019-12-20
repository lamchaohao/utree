//
//  AttendanceVC.m
//  utree
//
//  Created by 科研部 on 2019/8/15.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "AttendanceVC.h"
#import "SJDateConvertTool.h"
#import "UIColor+ColorChange.h"
#import "UTAttendanceCell.h"
#import "AttendanceView.h"
@interface AttendanceVC ()

@end

@implementation AttendanceVC
static NSString *CellID = @"attendCellID";
- (void)viewDidLoad {

    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];//设置自己想要的颜色
    
    UIBarButtonItem *rightbarItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAttendaceStatus:)];
       rightbarItem.tintColor=[UIColor whiteColor];
       self.navigationItem.rightBarButtonItem=rightbarItem;
    
    [self loadData];

}


-(void)loadData
{
    self.viewModel = [[AttendanceViewModel alloc]init];
    self.dataController = [[AttendaceDC alloc]init];
    AttendanceView *rootView = [[AttendanceView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:rootView];
    [self.dataController requestStudentAttendanceStatusWithSuccess:^(UTResult * _Nonnull result) {
        self.viewModel.studentList = result.successResult;
        [rootView bindWithViewModel:self.viewModel];
    } failure:^(UTResult * _Nonnull result) {
        
    }];
    
}

-(void)saveAttendaceStatus:(id)sender
{
    [self.dataController saveStudentsAttendance:self.viewModel.studentList StatusWithSuccess:^(UTResult * _Nonnull result) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(UTResult * _Nonnull result) {
        [self showToastView:result.failureResult];
    }];
}


@end
