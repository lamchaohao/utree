//
//  NoticeView.m
//  utree
//
//  Created by 科研部 on 2019/11/26.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "NoticeView.h"
#import "NoticeCell.h"
#import "NoticeModel.h"
#import "NoticeViewModel.h"
#import "NoticeListDC.h"
#import "WrapNoticeListModel.h"
#import "AVAudioPlayer.h"
#import "RxWebViewController.h"
#import "NoticeDetailVC.h"
#import "UTCache.h"
@interface NoticeView ()<UITableViewDataSource,UITableViewDelegate,NoticeMediaDelegate,XMAVAudioPlayerDelegate>

@property(nonatomic,strong)NoticeListDC *dataController;
@property (nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong)NSString *userId;
@property (nonatomic,strong) NSMutableArray *noticeArray;      //数据模型
@property (nonatomic,strong) NSMutableArray *noticeFrameArray; //ViewModel(包含cell子控件的Frame)
@property(nonatomic,assign)BOOL isMySelf;
@end

@implementation NoticeView

static NSString *CellID = @"noticeCellID";

- (instancetype)initWithFrame:(CGRect)frame isSelfData:(BOOL)isSelf
{
    self = [super initWithFrame:frame];
    if (self) {
        _isMySelf = isSelf;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _userId = [[UTCache readProfile] objectForKey:@"teacherId"];
    [XMAVAudioPlayer sharePlayer].delegate = self;
    self.dataController = [[NoticeListDC alloc]init];
    self.noticeArray = [[NSMutableArray alloc]init];
    self.noticeFrameArray = [[NSMutableArray alloc]init];
    [self initTableView];
    [self loadNoticeDataAtFirstTime];

}

-(void)initTableView
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.bounds.size.height-iPhone_Bottom_NavH) style:UITableViewStylePlain];
    [_tableView registerClass:[NoticeCell class] forCellReuseIdentifier:CellID];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    //tabBar遮挡tableview问题
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleWidth;
    
    _tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, iPhone_Bottom_NavH, 0.0f);
    [self addSubview:_tableView];
    
    _tableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNoticeDataAtFirstTime)];
    
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.noticeFrameArray objectAtIndex: indexPath.row]) {
        NoticeViewModel *vm = [self.noticeFrameArray objectAtIndex:indexPath.row];
        NoticeDetailVC *detailVC = [[NoticeDetailVC alloc]initWithNoticeModel:vm.notice];
        [self.utViewDelegate pushToViewController:detailVC];

    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    //选中后不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.noticeFrameArray objectAtIndex: indexPath.row]) {
        [cell setNoticeViewModel:self.noticeFrameArray[indexPath.row]];
    }
    cell.mediaDelegate = self;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _noticeArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeViewModel *noticeVM = self.noticeFrameArray[indexPath.row];
    return noticeVM.cellHeight;

}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


-(void)loadNoticeDataAtFirstTime
{
    
    [self.dataController requestNoticeListFirstTime:_isMySelf WithSuccess:^(UTResult * _Nonnull result) {
        WrapNoticeListModel *wrapNoticeModel = result.successResult;
        [self.noticeArray removeAllObjects];
        [self.noticeFrameArray removeAllObjects];
        [self.noticeArray addObjectsFromArray:wrapNoticeModel.list];
        for (NoticeModel *notice in self.noticeArray) {
            notice.allCheckNum =wrapNoticeModel.allCheckNum;
            NoticeViewModel *noticeVM = [[NoticeViewModel alloc] init];
            noticeVM.userId=self.userId;
            noticeVM.notice = notice;
            [self.noticeFrameArray addObject:noticeVM];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(UTResult * _Nonnull result) {
        [self makeToast:result.failureResult];
        [self.tableView.mj_header endRefreshing];
    }];
}

-(void)loadMoreData
{
    if (self.noticeArray.count>0) {
        NoticeModel *lastNotice = [self.noticeArray lastObject];
        [self.dataController requestMoreNotice:_isMySelf lastId:lastNotice.noticeId WithSuccess:^(UTResult * _Nonnull result) {
            WrapNoticeListModel *wrapNoticeModel = result.successResult;
            [self.noticeArray addObjectsFromArray:wrapNoticeModel.list];
             for (NoticeModel *notice in wrapNoticeModel.list) {
                 notice.allCheckNum =wrapNoticeModel.allCheckNum;
                 NoticeViewModel *noticeVM = [[NoticeViewModel alloc] init];
                 noticeVM.userId=self.userId;
                 noticeVM.notice = notice;
                 [self.noticeFrameArray addObject:noticeVM];
             }
             [self.tableView reloadData];
             [self.tableView.mj_footer endRefreshing];
        } failure:^(UTResult * _Nonnull result) {
             [self makeToast:result.failureResult];
             [self.tableView.mj_footer endRefreshing];
        }];
    }
    
}


- (void)playAudioClick:(FileObject *)audioFile
{
//    [playerHelper managerAudioWithFileName:self.audioPath toPlay:YES];
    [[XMAVAudioPlayer sharePlayer] playAudioWithURLString:audioFile.path atIndex:1 ];
}

- (void)openWebView:(NSString *)webUrl
{
    if([self.utViewDelegate respondsToSelector:@selector(pushToViewController:)])
    {
        RxWebViewController* webViewController = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:webUrl]];
        [self.utViewDelegate pushToViewController:webViewController];
    }
}

- (void)audioPlayerStateDidChanged:(VoiceMessageState)audioPlayerState forIndex:(NSUInteger)index
{
    switch (audioPlayerState) {
        case VoiceMessageStateNormal:
            NSLog(@"未播放状态");
            break;
        case VoiceMessageStateDownloading:
            NSLog(@"正在下载中");//正在下载中
            break;
        case VoiceMessageStatePlaying://正在播放
            NSLog(@"正在播放");
            break;
        case VoiceMessageStateCancel:
            NSLog(@"播放被取消");
            break;
        default:
            break;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[XMAVAudioPlayer sharePlayer] stopAudioPlayer];
    [XMAVAudioPlayer sharePlayer].index = NSUIntegerMax;
    [XMAVAudioPlayer sharePlayer].URLString = nil;
}


@end
