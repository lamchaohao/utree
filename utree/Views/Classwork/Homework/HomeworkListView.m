//
//  HomeworkListView.m
//  utree
//
//  Created by 科研部 on 2019/11/26.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "HomeworkListView.h"
#import "HomeworkCell.h"
#import "HomeworkModel.h"
#import "HomeworkViewModel.h"
#import "HomeworkListDC.h"
#import "WrapHomeworkListModel.h"
#import "AVAudioPlayer.h"
#import "RxWebViewController.h"
#import "VideoViewController.h"
#import "HomeworkDetailVC.h"
@interface HomeworkListView()<UITableViewDelegate,UITableViewDataSource,XMAVAudioPlayerDelegate,HomeworkMediaDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)HomeworkListDC *dataController;

@property(nonatomic,strong)NSMutableArray *taskArray;

@property(nonatomic,strong)NSMutableArray *taskFrameArray;

@property(nonatomic,strong)NSString *userId;

@property(nonatomic,assign)BOOL isSelfData;

@end

@implementation HomeworkListView

static NSString *CellID= @"HomeworkListCellId";

- (instancetype)initWithFrame:(CGRect)frame isSelfData:(BOOL)isSelf
{
    self = [super initWithFrame:frame];
    if (self) {
        _isSelfData = isSelf;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _userId = [[UTCache readProfile] objectForKey:@"teacherId"];
    [XMAVAudioPlayer sharePlayer].delegate = self;
    self.dataController = [[HomeworkListDC alloc]init];
    self.taskArray = [[NSMutableArray alloc]init];
    self.taskFrameArray = [[NSMutableArray alloc]init];
    [self initTableView];
    [self loadNoticeDataAtFirstTime];
//    [self loadNewData];
}

-(void)initTableView
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.bounds.size.height-iPhone_Bottom_NavH) style:UITableViewStylePlain];
    [_tableView registerClass:[HomeworkCell class] forCellReuseIdentifier:CellID];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    //tabBar遮挡tableview问题
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleWidth;
    
    _tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, iPhone_Bottom_NavH, 0.0f);
    [self addSubview:_tableView];
    
    _tableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNoticeDataAtFirstTime)];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.taskFrameArray objectAtIndex: indexPath.row]) {
        HomeworkViewModel *vm = [self.taskFrameArray objectAtIndex:indexPath.row];
        HomeworkDetailVC *detailVC = [[HomeworkDetailVC alloc]initWithHomeworkModel:vm.taskModel];
        [self.utViewDelegate pushToViewController:detailVC];

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeworkCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    //选中后不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.taskFrameArray objectAtIndex: indexPath.row]) {
        [cell setTaskViewModel:self.taskFrameArray[indexPath.row]];
    }
    cell.mediaDelegate = self;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _taskFrameArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeworkViewModel *taskVM = self.taskFrameArray[indexPath.row];
    return taskVM.cellHeight;

}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


-(void)loadNoticeDataAtFirstTime
{
    
    [self.dataController requestHomeworkListFirstTime:_isSelfData WithSuccess:^(UTResult * _Nonnull result) {
        WrapHomeworkListModel *wrapTaskModel = result.successResult;
        [self.taskArray removeAllObjects];
        [self.taskFrameArray removeAllObjects];
        [self.taskArray addObjectsFromArray:wrapTaskModel.list];
        for (HomeworkModel *task in self.taskArray) {
            task.allCheckNum =wrapTaskModel.allCheckNum;
            HomeworkViewModel *taskVM = [[HomeworkViewModel alloc] init];
            taskVM.userId = self.userId;
            [taskVM setTaskModelToCaculate:task];
            [self.taskFrameArray addObject:taskVM];
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
    if (self.taskArray.count>0) {
        HomeworkModel *lastTask = [self.taskArray lastObject];
        [self.dataController requestMoreHomework:_isSelfData lastId:lastTask.workId WithSuccess:^(UTResult * _Nonnull result) {
            WrapHomeworkListModel *wrapTaskModel = result.successResult;
            
            [self.taskArray addObjectsFromArray:wrapTaskModel.list];
            for (HomeworkModel *task in wrapTaskModel.list) {
                task.allCheckNum =wrapTaskModel.allCheckNum;
                HomeworkViewModel *taskVM = [[HomeworkViewModel alloc] init];
                taskVM.userId = self.userId;
                [taskVM setTaskModelToCaculate:task];
                [self.taskFrameArray addObject:taskVM];
            }
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        } failure:^(UTResult * _Nonnull result) {
            [self makeToast:result.failureResult];
            [self.tableView.mj_footer endRefreshing];
        }];
    }else{
       [self.tableView.mj_footer endRefreshing];
    }
    
}


- (void)playAudioClick:(FileObject *)audioFile
{
//    [playerHelper managerAudioWithFileName:self.audioPath toPlay:YES];
    [[XMAVAudioPlayer sharePlayer] playAudioWithURLString:audioFile.path atIndex:1 ];
}

- (void)playVideoClick:(FileObject *)videoFile
{
    VideoViewController *videoVC = [[VideoViewController alloc]initWithVideo:videoFile];
    if([self.utViewDelegate respondsToSelector:@selector(pushToViewController:)])
    {
        [self.utViewDelegate pushToViewController:videoVC];
    }
    
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
