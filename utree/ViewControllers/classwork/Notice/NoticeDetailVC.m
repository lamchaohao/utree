//
//  NoticeDetailVC.m
//  utree
//
//  Created by 科研部 on 2019/11/18.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "NoticeDetailVC.h"
#import "NoticeDetailView.h"
#import "ParentCheckModel.h"
#import "NoticeDetailDC.h"
#import "AppDelegate.h"
#import "UTCache.h"
#import "AVAudioPlayer.h"
#import "RxWebViewController.h"
#import "MMAlertView.h"
#import "UTClassModel.h"

@interface NoticeDetailVC ()<NoticeDataDelegate,WorkMediaDelegate,XMAVAudioPlayerDelegate>

@property(nonatomic,strong)NoticeDetailView *detailView;
@property(nonatomic,strong)NoticeModel *noticeModel;
@property(nonatomic,strong)NoticeDetailDC *dataController;
@property(nonatomic,strong)NSString *classListStr;
@property (nonatomic, strong) UIView *naviBGView;
@end

@implementation NoticeDetailVC

- (instancetype)initWithNoticeModel:(NoticeModel *)notice
{
    self = [super init];
       if (self) {
           self.noticeModel = notice;
       }
       return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.title = @"通知详情";
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
    self.dataController = [[NoticeDetailDC alloc]init];
    
    BOOL needList =NO;
    NSString *userID = [[UTCache readProfile] objectForKey:@"teacherId"];
    if ([_noticeModel.teacherDo.teacherId isEqualToString:userID]) {
        if (self.noticeModel.needReceipt.boolValue) {
            needList= YES;
        }
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Del"
            style:UIBarButtonItemStyleDone target:self action:@selector(onDeleteDataClick:)];
        NSString *imagePath = [[NSBundle mainBundle]pathForResource:@"ic_delete_white" ofType:@"png"];
        UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
        [self.navigationItem.rightBarButtonItem setImage:img];
    }
    
    self.detailView = [[NoticeDetailView alloc]initWithFrame:CGRectMake(0, iPhone_Top_NavH, self.view.frame.size.width, self.view.frame.size.height-iPhone_Top_NavH)  andNoticeModel:self.noticeModel needList:needList];
    self.detailView.dataDelegate = self;
    self.detailView.userHeaderView.mediaDelegate = self;
    [self.view addSubview:self.detailView];
    [self.detailView.userHeaderView.classListBtn addTarget:self action:@selector(showClassDetail) forControlEvents:UIControlEventTouchUpInside];
    [self loadClassList];
}

-(void)loadClassList
{
    [self.dataController requestClassListById:self.noticeModel.noticeId WithSuccess:^(UTResult * _Nonnull result) {
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
}

- (void)getParentListWithCheck:(NSNumber *)isCheck
{
    [self.dataController requestParentCheckDetail:self.noticeModel.noticeId checkStaus:isCheck WithSuccess:^(UTResult * _Nonnull result) {
        NSArray<ParentCheckModel *> *parents = result.successResult;
        [self.detailView setDataSourceWithCheck:isCheck.boolValue parents:parents];
        
    } failure:^(UTResult * _Nonnull result) {
        [self.view makeToast:result.failureResult];
    }];
}

-(void)showClassDetail
{
    MMAlertView *alertView = [[MMAlertView alloc]initWithConfirmTitle:_classListStr  detail:@""];
    [alertView show];
}

- (void)onekeyRemindAll
{
    [self.dataController requestOneKeyRemind:self.noticeModel.noticeId WithSuccess:^(UTResult * _Nonnull result) {
        [self getParentListWithCheck:[NSNumber numberWithBool:NO]];
    } failure:^(UTResult * _Nonnull result) {
        [self.view makeToast:result.failureResult];
    }];
}

-(void)onDeleteDataClick:(id)send
{
    
    MMPopupItemHandler positiveHandler = ^(NSInteger index){
        [self.dataController requestDeleteNoticeById:self.noticeModel.noticeId WithSuccess:^(UTResult * _Nonnull result) {
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
    RxWebViewController* webViewController = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:webUrl]];
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)playAudioClick:(FileObject *)audioFile
{
    [[XMAVAudioPlayer sharePlayer] setDelegate:self] ;
    [[XMAVAudioPlayer sharePlayer] playAudioWithURLString:audioFile.path atIndex:1];
}

- (void)playVideoClick:(FileObject *)videoFile
{
    
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
    navBar.translucent=YES;
    
}




@end
