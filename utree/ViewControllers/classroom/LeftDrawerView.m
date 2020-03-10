//
//  LeftDrawerView.m
//  utree
//
//  Created by 科研部 on 2019/8/22.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "LeftDrawerView.h"
#import "ClassCell.h"
#import "ClassViewModel.h"
@interface LeftDrawerView()<UITableViewDelegate,UITableViewDataSource,ClassViewModelDelegate>
@property(nonatomic,strong) ClassViewModel *viewModel;

@end

@implementation LeftDrawerView


static NSString *tableViewCellID = @"myClassCell";

- (void)viewDidLoad
{
    [self createCustomView];
    self.viewModel = [[ClassViewModel alloc]init];
    self.viewModel.viewModelDelegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.viewModel fetchClassListData];
}

-(void)createCustomView
{
    
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, ScreenHeight)];
    _contentView.backgroundColor = [UIColor whiteColor];
//    _contentView.layer.cornerRadius = 16;
    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    contentLayout.frame = CGRectMake(0, 0, ScreenWidth*0.814, ScreenHeight);
    contentLayout.backgroundColor = [UIColor whiteColor];
    
    UIImageView *topImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 137)];
    topImg.contentMode = UIViewContentModeScaleToFill;
    [topImg setImage:[UIImage imageNamed:@"drawer_top_img"]];
    
    topImg.layer.cornerRadius = 16;
    [contentLayout addSubview:topImg];
    
    [_contentView addSubview:contentLayout];
    [self.view addSubview:_contentView];
    self.view.backgroundColor=[UIColor whiteColor];

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, topImg.frame.size.height+12, ScreenWidth*0.81, ScreenHeight-topImg.frame.size.height) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView registerClass:[ClassCell class] forCellReuseIdentifier:tableViewCellID];

    [_tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTClassModel *clazz = [self.viewModel.classModel objectAtIndex:indexPath.row];
    [self.viewModel selectedClass:clazz.classId className:clazz.className];
    [clazz setIsSelected:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:ClazzChangedNotifycationName object:nil];
    [self.viewDeckController closeSide:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassCell * cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID forIndexPath:indexPath];
    [cell setClassModel:[self.viewModel.classModel objectAtIndex:indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.classModel.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenWidth*0.432+10;
}

- (void)onClassListLoadCompeleted:(NSArray<UTClassModel *> *)classModels
{
    [self.tableView reloadData];
}


@end
