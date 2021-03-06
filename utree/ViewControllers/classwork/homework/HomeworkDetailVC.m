//
//  HomeworkDetailVC.m
//  utree
//
//  Created by 科研部 on 2019/12/3.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "HomeworkDetailVC.h"
#import "HomeworkDetailView.h"
#import "HomeworkDetailDC.h"
#import "ParentCheckModel.h"
#import "AppDelegate.h"
#import "UTCache.h"
#import "UTWebViewController.h"
#import "VideoViewController.h"
#import "AVAudioPlayer.h"
#import "MMAlertView.h"
#import "UTClassModel.h"

@interface HomeworkDetailVC ()<HomeWorkDataDelegate,WorkMediaDelegate,XMAVAudioPlayerDelegate>
@property(nonatomic,strong)HomeworkDetailView *detailView;
@property(nonatomic,strong)HomeworkModel *taskModel;
@property(nonatomic,strong)HomeworkDetailDC *dataController;
@property(nonatomic,strong)NSString *classListStr;
@end

@implementation HomeworkDetailVC

- (instancetype)initWithHomeworkModel:(HomeworkModel *)taskModel
{
    self = [super init];
    if (self) {
        self.taskModel = taskModel;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.title = @"作业详情";
    [self initNaviBar];
    /** 设置返回箭头颜色 */
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //改变UITabBarItem字体颜色 //UITextAttributeTextColor
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.rootTabbarCtr.tabBar.tintColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [XMAVAudioPlayer sharePlayer].delegate = self;
    self.dataController = [[HomeworkDetailDC alloc]init];
    BOOL needList =NO;
    NSString *userID = [[UTCache readProfile] objectForKey:@"teacherId"];

    if ([self.taskModel.teacherDo.teacherId isEqualToString:userID]) {
        if (self.taskModel.uploadOnline.boolValue) {
            needList= YES;
        }
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Del"
            style:UIBarButtonItemStyleDone target:self action:@selector(onDeleteDataClick:)];
        NSString *imagePath = [[NSBundle mainBundle]pathForResource:@"ic_delete_white" ofType:@"png"];
        UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
        [self.navigationItem.rightBarButtonItem setImage:img];
    }
    
    self.detailView = [[HomeworkDetailView alloc]initWithFrame:CGRectMake(0, iPhone_Top_NavH, self.view.frame.size.width, self.view.frame.size.height-iPhone_Top_NavH)  andTaskModel:self.taskModel needList:needList];
    self.detailView.workDelegate = self;
    self.detailView.userHeaderView.mediaDelegate= self;
    [self.view addSubview:self.detailView];
    [self.detailView.userHeaderView.classListBtn addTarget:self action:@selector(showClassDetail) forControlEvents:UIControlEventTouchUpInside];
    [self loadClassList];
}

-(void)loadClassList
{
    [self.dataController requestClassListById:self.taskModel.workId WithSuccess:^(UTResult * _Nonnull result) {
        NSArray<UTClassModel *> *classList = result.successResult;
        NSString *classStr=@"";
        for (int i=0; i<classList.count; i++) {
            UTClassModel *model =[classList objectAtIndex:i];
            NSString *className = [NSString stringWithFormat:@"%d年(%d)班",model.classGrade.intValue,model.classCode.intValue];
            classStr = [classStr stringByAppendingFormat:@"%@",className];
            if (i!=classList.count-1) {
                classStr = [classStr stringByAppendingFormat:@","];
            }
        }
        self.classListStr = classStr;
        [self.detailView.userHeaderView setClassLabelStr:classStr];
    } failure:^(UTResult * _Nonnull result) {
        [self.view makeToast:result.failureResult];
    }];
    
    [self.dataController setTaskReadWithWorkId:self.taskModel.workId];
}

-(void)showClassDetail
{
    MMAlertView *alertView = [[MMAlertView alloc]initWithConfirmTitle:_classListStr  detail:@""];
    [alertView show];
}

- (void)getParentListWithCheck:(NSNumber *)isCheck
{
    
    [self.dataController requestHomeworkCheckDetail:self.taskModel.workId checkStaus:isCheck WithSuccess:^(UTResult * _Nonnull result) {
         NSArray<ParentCheckModel *> *parents = result.successResult;
         [self.detailView setDataSourceWithCheck:isCheck.boolValue parents:parents];
    } failure:^(UTResult * _Nonnull result) {
        [self.view makeToast:result.failureResult];
    }];
}

#pragma mark HomeWorkDataDelegate
- (void)onekeyRemindAll
{
    [self.dataController requestOneKeyRemind:self.taskModel.workId WithSuccess:^(UTResult * _Nonnull result) {
        [self getParentListWithCheck:[NSNumber numberWithBool:NO]];
    } failure:^(UTResult * _Nonnull result) {
        [self.view makeToast:result.failureResult];
    }];
}

#pragma mark HomeWorkDataDelegate
- (void)onRemindAgainClick:(ParentCheckModel *)model
{
    [self.dataController workRemindStuParentAgain:model.studentId taskId:self.taskModel.workId];
    
}

-(void)onDeleteDataClick:(id)send
{
    MMPopupItemHandler positiveHandler = ^(NSInteger index){
      [self.dataController requestDeleteTaskById:self.taskModel.workId WithSuccess:^(UTResult * _Nonnull result) {
          if (self.taskDeleteCallback) {
              self.taskDeleteCallback(self.taskModel.workId);
          }
          [self.navigationController popViewControllerAnimated:YES];
       } failure:^(UTResult * _Nonnull result) {
           [self.view makeToast:result.failureResult];
       }];
    };
    MMPopupItemHandler nagativeHandler = ^(NSInteger index){

    };
    NSArray *items =
    @[MMItemMake(@"确定", MMItemTypeHighlight, positiveHandler),
    MMItemMake(@"取消", MMItemTypeNormal, nagativeHandler)];

    MMAlertView *dismissAlert = [[MMAlertView alloc]initWithTitle:@"是否删除该通知" detail:@"" items:items];

    [dismissAlert show];
    
}

- (void)openWebView:(NSString *)webUrl
{
    UTWebViewController *webViewController = [[UTWebViewController alloc] initWithUrl:[NSURL URLWithString:webUrl]];
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)playAudioClick:(FileObject *)audioFile
{
    [XMAVAudioPlayer sharePlayer].delegate = self;
    [[XMAVAudioPlayer sharePlayer] playAudioWithURLString:audioFile.path atIndex:1];
}

- (void)playVideoClick:(FileObject *)videoFile
{
    VideoViewController *videoVC = [[VideoViewController alloc]initWithVideo:videoFile];
    videoVC.diasblePopGesture = YES;
    [self.navigationController pushViewController:videoVC animated:YES];
}

- (void)audioPlayerStateDidChanged:(VoiceMessageState)audioPlayerState forIndex:(NSUInteger)index
{
    dispatch_async(dispatch_get_main_queue(), ^{
         switch (audioPlayerState) {
             case VoiceMessageStateNormal:
                 NSLog(@"未播放状态");
                 [self.detailView.userHeaderView.audioButton stopPlay];
                 break;
             case VoiceMessageStateDownloading:
                 [self.detailView.userHeaderView.audioButton benginLoadVoice];
                 NSLog(@"正在下载中");//正在下载中
                 break;
             case VoiceMessageStatePlaying://正在播放
                 [self.detailView.userHeaderView.audioButton didLoadVoice];
                 NSLog(@"正在播放");
                 break;
             case VoiceMessageStateCancel:
                 [self.detailView.userHeaderView.audioButton stopPlay];
                 NSLog(@"播放被取消");
                 break;
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


-(void)initNaviBar
{
    UINavigationBar *navBar =self.navigationController.navigationBar;
    [navBar setBackgroundImage:[UIImage imageNamed:@"bg_work_green"] forBarMetrics:UIBarMetricsDefault];
//    [navBar setBarTintColor:[UIColor myColorWithHexString:@"#3BDF84"]];
    NSDictionary *dict = @{
                         NSForegroundColorAttributeName : [UIColor whiteColor]
                         };
    [navBar setTitleTextAttributes:dict];
}


@end
