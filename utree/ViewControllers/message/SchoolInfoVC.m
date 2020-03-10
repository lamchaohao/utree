//
//  SchoolInfoVC.m
//  utree
//
//  Created by 科研部 on 2019/10/14.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "SchoolInfoVC.h"
#import "RxWebViewController.h"
#import "NotificationDC.h"
#import "WrapNoticeMsgModel.h"
#import "NoticeMessageModel.h"
#import "NoticeMessageCell.h"
#import "UTMessageDetailVC.h"
#import "RedDotHelper.h"
@interface SchoolInfoVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)NotificationDC *dataController;
@property(nonatomic,strong)NSMutableArray *datasource;
@property(nonatomic,strong)NSIndexPath *selectedIndexpath;
@end

@implementation SchoolInfoVC
static NSString *cellID = @"schoolInfoID";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataController = [[NotificationDC alloc]init];
    self.datasource = [[NSMutableArray alloc]init];
    [self createTableView];
    
}

-(void)loadFirstData
{
    [self.dataController requestFirstNotification:self.isSystemNotice WithSuccess:^(UTResult * _Nonnull result) {
        WrapNoticeMsgModel *wrapModel= result.successResult;
        [self.datasource removeAllObjects];
        [self.datasource addObjectsFromArray:wrapModel.list];
        
        if (self.datasource.count==0) {
            self.tableView.tableHeaderView = self.headView;
        }else{
            self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.tableView.bounds.size.width,0.01)];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(UTResult * _Nonnull result) {
        [self.view makeToast:result.failureResult];
        [self.tableView.mj_header endRefreshing];
        if (self.datasource.count==0) {
            self.tableView.tableHeaderView = self.headView;
        }else{
            self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.tableView.bounds.size.width,0.01)];
        }
    }];
}


-(void)loadMoreData
{
    if (self.datasource.count>0) {
        NoticeMessageModel *lastObj = [self.datasource lastObject];
        [self.dataController requestMoreNotice:self.isSystemNotice lastId:lastObj.messageId limit:10 WithSuccess:^(UTResult * _Nonnull result) {
            WrapNoticeMsgModel *wrapModel= result.successResult;
            [self.datasource addObjectsFromArray:wrapModel.list];
            if (self.datasource.count==0) {
                self.tableView.tableHeaderView = self.headView;
            }else{
                self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.tableView.bounds.size.width,0.01)];
            }
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        } failure:^(UTResult * _Nonnull result) {
             [self.view makeToast:result.failureResult];
             [self.tableView.mj_header endRefreshing];
             if (self.datasource.count==0) {
                 self.tableView.tableHeaderView = self.headView;
             }else{
                 self.tableView.tableHeaderView = nil;
             }
        }];
    }else{
       [self.tableView.mj_footer endRefreshing];
    }
    
}

-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight  - iPhone_Top_NavH - SegmentTitleViewHeight -iPhone_Bottom_NavH) style:UITableViewStyleGrouped];
    
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, iPhone_Bottom_NavH, 0);
    [_tableView registerClass:[NoticeMessageCell class]forCellReuseIdentifier:cellID];
    [self.view addSubview:_tableView];
    
    _tableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadFirstData)];
    
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [_tableView.mj_header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

//创建TableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NoticeMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    NoticeMessageModel *model = [self.datasource objectAtIndex:indexPath.row];
    
    [cell setNoticeMsgToView:model];
    
    return cell;
}

//选中某个cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    RxWebViewController* webViewController = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:@"https://www.qq.com"]];
    
    NoticeMessageModel *model = [self.datasource objectAtIndex:indexPath.row];
    if(!model.read.boolValue){
        model.read = [NSNumber numberWithBool:YES];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        if (self.isSystemNotice) {
            int unread = [RedDotHelper shareInstance].systemUnread;
            unread--;
            unread=unread<0?0:unread;
            [[RedDotHelper shareInstance] setSystemUnread:unread];
        }else{
            int unread = [RedDotHelper shareInstance].schoolMsgUnread;
            unread--;
            unread=unread<0?0:unread;
            [[RedDotHelper shareInstance] setSchoolMsgUnread:unread];
        }
        
    }
    UTMessageDetailVC *detailVC = [[UTMessageDetailVC alloc]initWithNoticeId:model.messageId isSystemMsg:self.isSystemNotice];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(UIView *)headView
{
    if (!_headView) {
        UIView *rootView = [MyRelativeLayout new];
        rootView.frame = CGRectMake(0, 0, ScreenWidth, 240);
        UILabel *tips = [UILabel new];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 230, 170)];
        NSString *picPath;
        picPath =[[NSBundle mainBundle] pathForResource:@"pic_no_message" ofType:@"png"];
        [tips setText:@"暂无消息"];
        UIImage *img = [UIImage imageWithContentsOfFile:picPath];
        [imageView setImage:img];
        imageView.myCenterX=0;
        imageView.myCenterY=0;
        [tips sizeToFit];
        tips.textColor = [UIColor myColorWithHexString:@"#666666"];
        tips.font=[UIFont systemFontOfSize:14];
        tips.topPos.equalTo(imageView.bottomPos).offset(20);
        tips.myCenterX =0;
        
        [rootView addSubview:imageView];
        [rootView addSubview:tips];
        _headView = rootView;
    }
    
    return _headView;
}

@end
