//
//  SelectStudentGroupVC.m
//  utree
//
//  Created by 科研部 on 2019/11/4.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "SelectStudentGroupVC.h"
#import "StuGMemberCell.h"
#import "StuGMemberModel.h"
#import "GroupManagerDC.h"
@interface SelectStudentGroupVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *studentsWithGroup;
@property(nonatomic,strong)NSMutableArray *sectionTitleArray;
@property(nonatomic,strong)NSMutableArray *selectedStus;
@property(nonatomic,strong)NSString *groupName;
@property(nonatomic,strong)NSString *groupID;
@property(nonatomic,strong)GroupManagerDC *dataController;
@property(nonatomic,assign)BOOL createGroupFlag;


@end

@implementation SelectStudentGroupVC
static NSString *cellId = @"studentGroupId";

- (instancetype)initWithGroupName:(NSString *)name
{
    self = [super init];
    if (self) {
        self.groupName =name;
        self.dataController = [[GroupManagerDC alloc]init];
        self.selectedStus = [[NSMutableArray alloc]init];
        self.createGroupFlag = YES;
    }
    return self;
}

- (instancetype)initWithEditGroupId:(NSString *)groupId
{
    self = [super init];
    if (self) {
        self.groupID =groupId;
        self.dataController = [[GroupManagerDC alloc]init];
        self.selectedStus = [[NSMutableArray alloc]init];
        self.createGroupFlag = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initRightItemView];
    [self initTableView];
    [self loadStudentData];
}

-(void)initRightItemView
{
    UIBarButtonItem *rightbarItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(createGroupWithStus:)];
    rightbarItem.tintColor=[UIColor blackColor];
    self.navigationItem.rightBarButtonItem=rightbarItem;
}

-(void)loadStudentData
{
    [self.dataController requestStudentListInGroup:[self.dataController getCurrentClassId] planId:[self.dataController getCurrentPlanId] WithSuccess:^(UTResult * _Nonnull result) {
        [self.tableView.mj_header endRefreshing];
        NSDictionary *resultDic = result.successResult;
//        NSArray *resultKeys = [NSArray arrayWithObjects:@"titles",@"studentsInSort", nil]
        self.sectionTitleArray = [resultDic objectForKey:@"titles"];
        self.studentsWithGroup = [resultDic objectForKey:@"studentsInSort"];
        [self.selectedStus removeAllObjects];
        //如果是编辑状态 则需要把本组的学生置为可选
        if (!self.createGroupFlag) {
            for (NSMutableArray *partStus in self.studentsWithGroup) {
                for (StuGMemberModel *model in partStus) {
                    if([model.groupId isEqualToString:self.groupID]){
                        model.selectMode=1;
                        [self.selectedStus addObject:model];
                    }else{
                        break;
                    }
                }
            }
        }
        [self.tableView reloadData];
    } failure:^(UTResult * _Nonnull result) {
        [self.selectedStus removeAllObjects];
        [self.tableView.mj_header endRefreshing];
    }];
}

-(void)initTableView
{
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-60) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _tableView.sectionIndexColor = [UIColor myColorWithHexString:@"#676767"];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, iPhone_Bottom_NavH, 0);
    [_tableView registerClass:[StuGMemberCell class] forCellReuseIdentifier:cellId];
    
    [self.view addSubview:_tableView];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadStudentData)];
    
}

#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.sectionTitleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSArray *array = [self.dataSource valueForKey:self.sectionTitleArray[section]];
    
    return [[self.studentsWithGroup objectAtIndex:section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 24)];
    UILabel *label = [[UILabel alloc]init];
    label.text = [NSString stringWithFormat:@"%@",self.sectionTitleArray[section]];
    [view addSubview:label];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:18];
    label.frame = CGRectMake(11, 0, 100, 25);
    view.backgroundColor=[UIColor myColorWithHexString:@"#FFF7F7F7"];
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

//创建TableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StuGMemberCell *cell =(StuGMemberCell*) [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[StuGMemberCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }

    StuGMemberModel *studentGroupModel = [[_studentsWithGroup objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell setStudentModel:studentGroupModel];

    return cell;
}

//选中某个cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //选中后不变色
     StuGMemberModel *studentGroupModel = [[_studentsWithGroup objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
//    if ([[self.sectionTitleArray objectAtIndex:indexPath.section] isEqualToString:@"未分组"]) {
//
//    }
    [studentGroupModel changeSelectMode];
    if (studentGroupModel.selectMode==1) {
        [self.selectedStus addObject:studentGroupModel];
    }else if(studentGroupModel.selectMode==2){
        [self.selectedStus removeObject:studentGroupModel];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionTitleArray[section];
}


-(void)createGroupWithStus:(id)sender
{
    if (self.selectedStus.count>0) {
        if (self.createGroupFlag){
            [self.dataController requestAddGroupByName:self.groupName planId:[self.dataController getCurrentPlanId] studentList:self.selectedStus WithSuccess:^(UTResult * _Nonnull result) {
                if([self.delegate respondsToSelector:@selector(onSelectedStuSuccess)]){
                    [self.delegate onSelectedStuSuccess];
                }
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(UTResult * _Nonnull result) {
                [self.view makeToast:result.failureResult];
            }];
        }else{
            [self.dataController requestEditGroupById:self.groupID planId:[self.dataController getCurrentPlanId] studentList:self.selectedStus WithSuccess:^(UTResult * _Nonnull result) {
                if([self.delegate respondsToSelector:@selector(onSelectedStuSuccess)]){
                    [self.delegate onSelectedStuSuccess];
                }
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(UTResult * _Nonnull result) {
                [self.view makeToast:result.failureResult];
            }];
        }
    }else{
        [self.view makeToast:@"没有已选择学生"];
    }
    
    
    
}


@end
