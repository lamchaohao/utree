//
//  EditGroupVC.m
//  utree
//
//  Created by 科研部 on 2019/9/26.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "EditGroupVC.h"
#import "EditGroupView.h"
#import "UTStudentCollectCell.h"
#import "UTStudent.h"
#import "MMAlertView.h"
#import "GroupManagerDC.h"
#import "SelectStudentGroupVC.h"

@interface EditGroupVC ()<EditGroupViewResponser,SelectStudentDelegate>

@property(nonatomic,strong)GroupModel *group;
@property(nonatomic,strong)GroupManagerDC *dataController;
@property(nonatomic,strong)EditGroupView *groupView;
@end

@implementation EditGroupVC
static NSString *cellID = @"collectionID";

-(instancetype)initWithGroup:(GroupModel *)group
{
    self = [super init];
    _group = group;
    return self ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.groupView = [[EditGroupView alloc]initWithFrame:self.view.frame groupModel:_group];
    [self.view addSubview:self.groupView];
    self.groupView.responser = self;
    self.title=@"编辑小组";
    self.dataController = [[GroupManagerDC alloc]init];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.showNavigationBarImageWhenDisappear = YES;
    [super viewWillAppear:animated];
    
}

- (void)onCloseViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onDeleteGroup
{
    [self.dataController deleteGroupById:self.group.groupId WithSuccess:^(UTResult * _Nonnull result) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(UTResult * _Nonnull result) {
        [self.view makeToast:result.failureResult];
    }];
}

- (void)onRenameGroup:(NSString *)groupName
{
    [self.dataController requestRenameGroupById:self.group.groupId groupName:groupName planId:[self.dataController getCurrentPlanId] studentList:self.group.studentDos WithSuccess:^(UTResult * _Nonnull result) {
          [self onRequestRefresh];
    } failure:^(UTResult * _Nonnull result) {
         [self.view makeToast:[NSString stringWithString:result.failureResult]];
    }];    
}

- (void)onRequestRefresh
{
    [self.dataController requestGroupDetailById:self.group.groupId WithSuccess:^(UTResult * _Nonnull result) {
        self.group = result.successResult;
        [self.groupView bindViewModel:self.group];
        [self.groupView onLoadDataFinish];

    } failure:^(UTResult * _Nonnull result) {
         [self.groupView onLoadDataFinish];
    }];
}

- (void)onEditPress
{
    SelectStudentGroupVC *selectVC = [[SelectStudentGroupVC alloc]initWithEditGroupId:self.group.groupId];
    selectVC.delegate = self;
    [self.navigationController pushViewController:selectVC animated:YES];
}

- (void)onSelectedStuSuccess
{
    [self onRequestRefresh];
}


@end
