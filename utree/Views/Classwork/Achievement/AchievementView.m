//
//  AchievementView.m
//  utree
//
//  Created by 科研部 on 2019/12/9.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "AchievementView.h"
#import "AchievementCell.h"
#import "AchievementDC.h"
#import "AchievementDetailVC.h"
#import "WrapAchievementModel.h"
@interface AchievementView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)AchievementDC *dataController;
@property(nonatomic,assign)BOOL isMyselfData;
@property(nonatomic,strong)NSMutableArray *achievementList;
@property(nonatomic,strong)WrapAchievementModel *lastResponseObject;

@end

@implementation AchievementView
static NSString *CellID = @"achievementId";

- (instancetype)initWithFrame:(CGRect)frame isSelfData:(BOOL)isSelf
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isMyselfData = isSelf;
        _achievementList = [[NSMutableArray alloc]init];
        self.dataController = [[AchievementDC alloc]init];
        [self initTableView];
    }
    return self;
}

-(void)initTableView
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.bounds.size.height-iPhone_Bottom_NavH) style:UITableViewStylePlain];
    [_tableView registerClass:[AchievementCell class] forCellReuseIdentifier:CellID];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _tableView.separatorStyle=UITableViewCellEditingStyleNone;
    //tabBar遮挡tableview问题
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleWidth;
    
    _tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, iPhone_Bottom_NavH, 0.0f);
    [self addSubview:_tableView];
    
    _tableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadAchievementFirstTime)];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [_tableView.mj_header beginRefreshing];
}


-(void)loadAchievementFirstTime
{
    [self.dataController requestAchievementListWithFirstTimeisMySelf:NO WithSuccess:^(UTResult * _Nonnull result) {
        self.lastResponseObject = result.successResult;
        [self.achievementList removeAllObjects];
        [self.achievementList addObjectsFromArray:self.lastResponseObject.list];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } failure:^(UTResult * _Nonnull result) {
        [self makeToast:result.failureResult];
        [self.tableView.mj_header endRefreshing];
    }];
}

-(void)loadMoreData
{
    if (_lastResponseObject&&_lastResponseObject.examId) {
        [self.dataController requestAchievementListWithLastId:_lastResponseObject.examId limit:[NSNumber numberWithInt:10] isMySelf:NO WithSuccess:^(UTResult * _Nonnull result) {
            self.lastResponseObject = result.successResult;
            [self.achievementList addObjectsFromArray:self.lastResponseObject.list];
            if (self.lastResponseObject.list.count==0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
            [self.tableView reloadData];
        } failure:^(UTResult * _Nonnull result) {
            [self makeToast:result.failureResult];
            [self.tableView.mj_footer endRefreshing];
        }];
    }else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AchievementCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
       //选中后不变色
    AchievementModel *model = [self.achievementList objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setDataToView:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AchievementModel *model = [self.achievementList objectAtIndex:indexPath.row];
    AchievementDetailVC *detail = [[AchievementDetailVC alloc]initWithAchievementModel:model];
    [self.utViewDelegate pushToViewController:detail];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 370;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _achievementList.count;
}


@end
