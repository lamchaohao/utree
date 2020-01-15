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
#import "RedDotHelper.h"
@interface HomeworkListView()<UITableViewDelegate,UITableViewDataSource,XMAVAudioPlayerDelegate,HomeworkMediaDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)HomeworkListDC *dataController;

@property(nonatomic,strong)NSMutableArray *taskArray;

@property(nonatomic,strong)NSMutableArray *taskFrameArray;

@property(nonatomic,strong)NSString *userId;

@property(nonatomic,assign)BOOL isSelfData;

@property(nonatomic,strong)HomeworkCell *focusCell;

@end

@implementation HomeworkListView

static NSString *CellID= @"HomeworkListCellId";

- (instancetype)initWithFrame:(CGRect)frame isSelfData:(BOOL)isSelf
{
    self = [super initWithFrame:frame];
    if (self) {
        self.headViewPath=@"pic_no_homework";
        _isSelfData = isSelf;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _userId = [[UTCache readProfile] objectForKey:@"teacherId"];
    self.dataController = [[HomeworkListDC alloc]init];
    self.taskArray = [[NSMutableArray alloc]init];
    self.taskFrameArray = [[NSMutableArray alloc]init];
    [self initTableView];
    [self loadHomeworkDataAtFirstTime];
//    [self loadNewData];
}

-(void)initTableView
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.bounds.size.height-iPhone_Bottom_NavH) style:UITableViewStyleGrouped];
    [_tableView registerClass:[HomeworkCell class] forCellReuseIdentifier:CellID];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    //tabBar遮挡tableview问题
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleWidth;
    
    _tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, iPhone_Bottom_NavH, 0.0f);
    [self addSubview:_tableView];
    self.headViewMessage = @"暂无作业";
    _tableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadHomeworkDataAtFirstTime)];
    
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreHomeworkData)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.taskFrameArray objectAtIndex: indexPath.row]) {
        HomeworkViewModel *vm = [self.taskFrameArray objectAtIndex:indexPath.row];
        if (vm.taskModel.unread.boolValue) {
            vm.taskModel.unread=[NSNumber numberWithBool:NO];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [RedDotHelper shareInstance].studentTaskUnread--;
            [[NSNotificationCenter defaultCenter] postNotificationName:BadgeValueUpdateNotifyName object:nil];
        }
             
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


-(void)loadHomeworkDataAtFirstTime
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
        if (self.taskArray.count==0) {
            self.tableView.tableHeaderView = self.headView;
        }else{
            self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.tableView.bounds.size.width,0.01)];

        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];

    } failure:^(UTResult * _Nonnull result) {
        [self makeToast:result.failureResult];
        [self.tableView.mj_header endRefreshing];
    }];

}

-(void)loadMoreHomeworkData
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
            if (self.taskArray.count==0) {
                self.tableView.tableHeaderView = self.headView;
            }else{
                self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.tableView.bounds.size.width,0.01)];

            }
            [self.tableView reloadData];
            if (wrapTaskModel.list.count>0) {
                [self.tableView.mj_footer endRefreshing];
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } failure:^(UTResult * _Nonnull result) {
            [self makeToast:result.failureResult];
            [self.tableView.mj_footer endRefreshing];
        }];
    }else{
       [self.tableView.mj_footer endRefreshing];
    }
    
}

- (void)playAudioClick:(HomeworkCell *)cell
{
    [XMAVAudioPlayer sharePlayer].delegate = self;
    if (self.focusCell) {
        //如果之前有在播放，先停止
        [self.focusCell.audioButton stopPlay];
    }
    self.focusCell = cell;
    [[XMAVAudioPlayer sharePlayer] playAudioWithURLString:cell.taskViewModel.taskModel.audio.path atIndex:1 ];
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
    dispatch_async(dispatch_get_main_queue(), ^{
         switch (audioPlayerState) {
             case VoiceMessageStateNormal:
             {
                 [self.focusCell.audioButton stopPlay];
                 NSLog(@"homework未播放状态");
                 break;
             }
             case VoiceMessageStateDownloading:
             {
                 
                 [self.focusCell.audioButton benginLoadVoice];
                 NSLog(@"homework正在下载中");//正在下载中
                 break;
             }
             case VoiceMessageStatePlaying://正在播放
             {
                 
                 [self.focusCell.audioButton didLoadVoice];
                 NSLog(@"homework正在播放");
                 break;
             }
             case VoiceMessageStateCancel:
             {
                 
                 [self.focusCell.audioButton stopPlay];
                 NSLog(@"homework播放被取消");
                 break;
             }
             default:
                 break;
         }
    });
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[XMAVAudioPlayer sharePlayer] stopAudioPlayer];
    [XMAVAudioPlayer sharePlayer].index = NSUIntegerMax;
    [XMAVAudioPlayer sharePlayer].URLString = nil;
    [XMAVAudioPlayer sharePlayer].delegate = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [XMAVAudioPlayer sharePlayer].delegate = self;
}

@end
