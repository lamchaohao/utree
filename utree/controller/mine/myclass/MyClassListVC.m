//
//  MyClassListVC.m
//  utree
//
//  Created by 科研部 on 2019/9/5.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "MyClassListVC.h"
#import "MyClassCell.h"
@interface MyClassListVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation MyClassListVC
static NSString *ID = @"myClassCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"带领班级";
    [self initView];
}


-(void)initView
{
    self.navigationController.navigationBarHidden=NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView registerClass:[MyClassCell class] forCellReuseIdentifier:ID];
    [_tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyClassCell * cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    //    cell setmodel
    ClassModel *model = [[ClassModel alloc]initWithClassName:@"三年三班" subject:@"数学" studentCount:54 dropCount:788];
    if (indexPath.row==3) {
        model.isSelected= YES;
    }
    [cell setClassModel:model];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenHeight*0.1345;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.showNavWhenDisappear = NO;
    [super viewWillAppear:animated];
    
}

@end
