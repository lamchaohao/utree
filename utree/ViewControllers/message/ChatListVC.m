//
//  ChatListVC.m
//  utree
//
//  Created by 科研部 on 2019/10/14.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ChatListVC.h"
#import "ContactVC.h"
#import "ChatViewController.h"
#import "ChatContactCell.h"
#import "XMUserManager.h"
#import "ChatVC.h"
#import "UUChatViewController.h"
#import "UUParentChatVC.h"
#import "DBManager.h"
#import "ConvertMessageUtil.h"
@interface ChatListVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIButton *contactBtn;
@property(nonatomic,strong)NSMutableArray *recentList;
@property(nonatomic,strong)DBManager *dbManager;

@end

@implementation ChatListVC
static NSString *cellID = @"chatId";
- (void)viewDidLoad {
    [super viewDidLoad];
    _dbManager = [DBManager sharedInstance];
    _recentList = [[NSMutableArray alloc]init];
    [self createTableView];
    [[JSBadgeView appearance] setBadgeTextFont:[UIFont systemFontOfSize:12]];
    [self initContactsButton];
    
}

-(void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveMsgNotification:) name:MIMC_ReceiveMsgNotifyName object:nil];
}

- (void)onReceiveMsgNotification:(NSNotification *) notification {
    //处理消息
    NSDictionary *dic =notification.object;
    MIMCMessage *msg =[dic objectForKey:@"msg"];
//    MCUser *user =[dic objectForKey:@"user"];

    [self dealWithNewMessage:msg];

}

-(void)dealWithNewMessage:(MIMCMessage *)mimcMsg
{
    NSString *accountId = mimcMsg.getFromAccount;
    UTMessage *message = [ConvertMessageUtil convertMimcMessage:mimcMsg];
    int oldPosition = -1;
    for (int index=0; index<self.recentList.count; index ++) {
        RecentContact *contact = [self.recentList objectAtIndex:0];
        if([contact.parent.parentId isEqualToString:accountId]){
            oldPosition = index;
            contact.lastMessage = message;
            contact.unreadCount ++;
        }
    }
    if (oldPosition!=-1) {//更新列表中的顺序
        [self.recentList exchangeObjectAtIndex:0 withObjectAtIndex:oldPosition];
        NSMutableArray *indexpaths = [[NSMutableArray alloc]init];
        for (int count =0 ; count<=oldPosition; count++) {
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:count inSection:0];
            [indexpaths addObject:indexpath];
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
              [self.tableView reloadRowsAtIndexPaths:indexpaths withRowAnimation:UITableViewRowAnimationNone];
        });
       
    }else{//说明最近联系人中无此人，则需要从数据库缓存中读取
        [_recentList removeAllObjects];
        [_dbManager queryRecentContactListWithResult:^(NSDictionary * _Nonnull resultDic) {
            NSMutableArray *recents = resultDic[@"result"];
            [self.recentList addObjectsFromArray:recents];
            dispatch_sync(dispatch_get_main_queue(), ^{
                  [self.tableView reloadData];
            });
           
        }];
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerNotification];
    if(_tableView){
        [_recentList removeAllObjects];
        [_dbManager queryRecentContactListWithResult:^(NSDictionary * _Nonnull resultDic) {
            NSMutableArray *recents = resultDic[@"result"];
            [self.recentList addObjectsFromArray:recents];
            [self.tableView reloadData];
        }];
        
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)refreshRecentContacts
{

    [_recentList removeAllObjects];
    [_dbManager queryRecentContactListWithResult:^(NSDictionary * _Nonnull resultDic) {
        NSMutableArray *recents = resultDic[@"result"];
        [self.recentList addObjectsFromArray:recents];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
    
}

-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight  - iPhone_Top_NavH - SegmentTitleViewHeight -iPhone_Bottom_NavH) style:UITableViewStyleGrouped];
    [_tableView registerClass:[ChatContactCell class] forCellReuseIdentifier:cellID];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, iPhone_Bottom_NavH, 0);
    _tableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshRecentContacts)];
    [self.view addSubview:_tableView];
    [_tableView.mj_header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _recentList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.01)];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

//创建TableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ChatContactCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];

    RecentContact *contact = [_recentList objectAtIndex:indexPath.row];
    [cell setDataToView:contact];
    return cell;
}

//选中某个cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    RecentContact *contact = [_recentList objectAtIndex: indexPath.row];
//    ChatVC *chatC = [[ChatVC alloc]initWithParent:contact.parent];
//    chatC.hidesBottomBarWhenPushed = YES;
    UUParentChatVC *vc= [[UUParentChatVC alloc]initWithParent:contact.parent];
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)initContactsButton
{
    self.contactBtn=[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth*0.85, ScreenHeight*0.65, 54, 54)];
    [self.contactBtn setImage:[UIImage imageNamed:@"ic_contact"] forState:UIControlStateNormal];
    
    [self.contactBtn sizeToFit];
    [self.contactBtn addTarget:self action:@selector(openContact:) forControlEvents:UIControlEventTouchUpInside];
    
    UIPanGestureRecognizer *panGes= [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panScroll:)];
    
    [self.contactBtn addGestureRecognizer:panGes];
    [self.view addSubview:self.contactBtn];
}

- (void)panScroll:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {//设置拖动范围
        CGPoint translation = [recognizer locationInView:self.contactBtn];
        CGPoint newCenter = CGPointMake(recognizer.view.center.x+ translation.x,
                                        recognizer.view.center.y + translation.y);
        newCenter.y = MIN(ScreenHeight-54, newCenter.y);
        newCenter.y = MAX(30, newCenter.y);//iPhone_Top_NavH-SegmentTitleViewHeight
        newCenter.x = MAX(30, newCenter.x);
        newCenter.x = MIN(ScreenWidth-30,newCenter.x);
        if (newCenter.y>CGRectGetHeight(self.view.frame)-iPhone_Bottom_NavH-54) {
            newCenter.y =CGRectGetHeight(self.view.frame)-iPhone_Bottom_NavH-54;
        }
        recognizer.view.center = newCenter;
        [recognizer setTranslation:CGPointZero inView:self.contactBtn];

    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {//可以在这里做一些复位处理
        
    }
}

-(void)openContact:(id)sender
{
    ContactVC *contactVC= [[ContactVC alloc]init];
    contactVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:contactVC animated:YES];
    

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
