//
//  AppDelegate.m
//  utree
//
//  Created by 科研部 on 2019/7/26.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "AppDelegate.h"
#import "MainLoginVC.h"
#import "ClassroomHomeVC.h"
#import "CLassworkHomeVC.h"
#import "ClassSocietyHomeVC.h"
#import "MessageHomeVC.h"
#import "MineHomeVC.h"
#import "YTKNetwork.h"
#import "UTCache.h"
#import "LauncherVC.h"
#import "IIViewDeckController.h"
#import "LeftDrawerView.h"
#import <MMCSDK/MMCSDK.h>
#import "XMUserManager.h"
#import <AudioToolbox/AudioToolbox.h>//震动
#import "RecordMessageHelper.h"
#import "ContactDC.h"
#import "RedDotHelper.h"
#import "UnreadApi.h"
#import "UITabBarController+Badge.h"

@interface AppDelegate ()<LoginDelegate,RecvMsgDelegate,returnUserStatusDelegate>
@property(nonatomic,strong) RecordMessageHelper *mimcMsgHelper;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self registerNotification];
    [self initNetwork];
    [self initIMIMC];
    [self toLauncherVC];
    [self setNavigationBarStyle];
    return YES;
}

-(void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchParentData:) name:FetchParentDataNotifyName object:nil];
    [[NSNotificationCenter defaultCenter] addObserverForName:BadgeValueUpdateNotifyName object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"AppDelegate NSNotificationCenter receive BadgeValueUpdateNotifyName");
        [self updateTabbarItemBadgeView];
    }];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTabbarItemBadgeView) name:BadgeValueUpdateNotifyName object:nil];
    
}

-(void)fetchParentData:(NSNotification *) notification
{
    
    NSString *parentId = notification.object;
    ContactDC *dc = [[ContactDC alloc]init];
    [dc requestParentDataByParentId:parentId WithSuccess:^(UTResult * _Nonnull result) {
         //获取资料
        [self.mimcMsgHelper updateParentData:result.successResult];
    } failure:^(UTResult * _Nonnull result) {
        NSLog(@"saveReceivedMessage cannot fetch parent data!");
    }];
}

-(void)initIMIMC
{
    //制定真机调试保存日志文件
    [self redirectNSlogToDocumentFolder];
    //日志总开关
    [MCUser setMIMCLogSwitch:YES];
    //设置打印的日志级别
    [MCUser setMIMCLogLevel:MIMC_WARN];
}
#pragma mark 初始化YTKNetwork
-(void)initNetwork
{
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
//    config.baseUrl = @"http://192.168.1.168";
    config.baseUrl = @"http://bot.gzz100.com";
}

-(void)toLauncherVC
{
    LauncherVC *launcher = [[LauncherVC alloc]init];
    self.window.rootViewController = launcher;
    self.window.rootViewController.view.backgroundColor=[UIColor whiteColor];
    [self startVisible];
}

//跳到登录页面
-(void)toLoginVC
{
    MainLoginVC *loginVC = [[MainLoginVC alloc]init];
    loginVC.delegate = self;
    self.window.rootViewController = loginVC;
    self.window.rootViewController.view.backgroundColor=[UIColor whiteColor];
    [self startVisible];
}

#pragma mark LoginVC loginDelegate
- (void)loginSuccessWithUser:(NSString *)userId
{
    [self toMainVC:userId];
}


#pragma mark 登录MIMC
- (BOOL)loginMimc:(NSString *)userName {
    self.mimcMsgHelper = [[RecordMessageHelper alloc]initWithUserId:userName];
    XMUserManager *userManager = [XMUserManager sharedInstance];
//    NSString *userName = [self getUserId];
    [userManager setAppAccount:userName];
    userManager.receiveMsgDelegate = self;
    userManager.returnUserStatusDelegate = self;
    return [userManager userLogin];
}

#pragma mark MIMC收到消息回调
- (void)onReceiveMessage:(MIMCMessage *)packet user:(MCUser *)user
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mimcMsgHelper saveMessage:packet];
    });
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//默认震动效果
    [[NSNotificationCenter defaultCenter] postNotificationName:MIMC_ReceiveMsgNotifyName object:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:packet,user, nil] forKeys:[NSArray arrayWithObjects:@"msg",@"user", nil]]];
    
}
#pragma mark MIMC登录状态改变回调
- (void)returnUserStatus:(MCUser *)user status:(int)status
{
    if (status==0) {
        [user login];
    }
}

//主页面
-(void)toMainVC:(NSString *)userId{
    [self fetchUnreadCount];
    [self loginMimc: userId];
    //1.
    ClassroomHomeVC *classroomVC = [[ClassroomHomeVC alloc] init];
    UINavigationController *navClassRoom = [[UINavigationController alloc] initWithRootViewController:classroomVC];
    ClassworkHomeVC *classworkVC = [[ClassworkHomeVC alloc] init];
    UINavigationController *navClasswork = [[UINavigationController alloc] initWithRootViewController:classworkVC];
    ClassSocietyHomeVC *classSocietyVC = [[ClassSocietyHomeVC alloc] init];
    UINavigationController *navSociety = [[UINavigationController alloc] initWithRootViewController:classSocietyVC];
    MessageHomeVC *messageVC = [[MessageHomeVC alloc] init];
    UINavigationController *navMessage = [[UINavigationController alloc] initWithRootViewController:messageVC];
    MineHomeVC *mineVC = [[MineHomeVC alloc] init];
    UINavigationController *navMine = [[UINavigationController alloc] initWithRootViewController:mineVC];
    classroomVC.title = @"课堂";
    classworkVC.title = @"班务";
    classSocietyVC.title = @"班级圈";
    messageVC.title = @"消息";
    mineVC.title = @"我的";
    //2.
    NSArray *viewCtrs = @[navClassRoom,navClasswork,navSociety,navMessage,navMine];
    //3.
    //    UITabBarController *tabbarCtr = [[UITabBarController alloc] init];rootTabbarCtr
    self.rootTabbarCtr  = [[UITabBarController alloc] init];
    //4.
    [self.rootTabbarCtr setViewControllers:viewCtrs animated:YES];
    
//    UINavigationController *sideNavigationController = [[UINavigationController alloc] initWithRootViewController:sourceSelectionTableViewController];
    LeftDrawerView *leftDrawerView = [[LeftDrawerView alloc]init];
    IIViewDeckController *viewDeckController = [[IIViewDeckController alloc] initWithCenterViewController:self.rootTabbarCtr leftViewController:leftDrawerView];
    [viewDeckController setPanningEnabled:NO];//禁止滑动出现
    leftDrawerView.viewDeckController =viewDeckController;
    //5.
//    self.window.rootViewController = self.rootTabbarCtr;
    self.window.rootViewController =viewDeckController;
    classroomVC.viewDeckController = viewDeckController;
    self.window.rootViewController.view.backgroundColor=[UIColor whiteColor];
    //6.
    UITabBar *tabbar = self.rootTabbarCtr.tabBar;
    UITabBarItem *itemRoom = [tabbar.items objectAtIndex:0];
    UITabBarItem *itemWork = [tabbar.items objectAtIndex:1];
    UITabBarItem *itemSociety = [tabbar.items objectAtIndex:2];
    UITabBarItem *itemMsg = [tabbar.items objectAtIndex:3];
    UITabBarItem *itemMine = [tabbar.items objectAtIndex:4];
    
    itemRoom.selectedImage = [[UIImage imageNamed:@"ic_tab_classroom_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    itemRoom.image = [[UIImage imageNamed:@"ic_tab_classroom_unselect"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    itemWork.selectedImage = [[UIImage imageNamed:@"ic_tab_classwork_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    itemWork.image = [[UIImage imageNamed:@"ic_tab_classwork_unselect"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    item2.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    itemSociety.selectedImage = [[UIImage imageNamed:@"ic_tab_society_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    itemSociety.image = [[UIImage imageNamed:@"ic_tab_society_unselect"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    item3.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    itemMsg.selectedImage = [[UIImage imageNamed:@"ic_tab_message_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    itemMsg.image = [[UIImage imageNamed:@"ic_tab_message_unselect"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    item4.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    itemMine.selectedImage = [[UIImage imageNamed:@"ic_tab_mine_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    itemMine.image = [[UIImage imageNamed:@"ic_tab_mine_unselect"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    item5.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    [self startVisible];
}

-(void)startVisible
{
    //改变UITabBarItem字体颜色 //UITextAttributeTextColor
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.window makeKeyAndVisible];
}

/// 统一设置导航栏外观
- (void)setNavigationBarStyle
{
    UINavigationBar *navBar = [UINavigationBar appearance];
    UIImage *navImg =[UIImage imageNamed:@"topbar_bg"];
    navImg = [navImg resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];

    /** 设置导航栏背景图片 */
    [navBar setBackgroundImage:navImg forBarMetrics:UIBarMetricsDefault];
    /** 设置导航栏标题文字颜色 */
    NSDictionary *dict = @{
                           NSForegroundColorAttributeName : [UIColor whiteColor]
                           };
    [navBar setTitleTextAttributes:dict];
    
//    NSDictionary *backDict = @{
//                           NSForegroundColorAttributeName : [UIColor_ColorChange colorWithHexString:@"666666"],
//                           NSFontAttributeName : [UIFont systemFontOfSize:0.1]
//                           };
//
//    [[UIBarButtonItem appearance ]setTitleTextAttributes:backDict forState:UIControlStateNormal];
    /** 设置返回箭头颜色 */
    navBar.tintColor = [UIColor_ColorChange blackColor];
    
    /** 设置取消导航栏返回按钮的字 */
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, 0.01)forBarMetrics:UIBarMetricsDefault];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ([self.window.rootViewController isKindOfClass:[IIViewDeckController class]]) {
        [self fetchUnreadCount];
    }
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// 将NSlog打印信息保存到Document目录下的文件中
- (void)redirectNSlogToDocumentFolder {
    //如果已经连接Xcode调试则不输出到文件
    if(isatty(STDOUT_FILENO)) {
        return;
    }
    
    UIDevice *device = [UIDevice currentDevice];
    //在模拟器不保存到文件中
    if([[device model] hasSuffix:@"Simulator"]){
        return;
    }
    
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"mimcDemo.log"];//注意不是NSData!
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
//    NSLog(@"logFilePath==%@",logFilePath);
    //先删除已经存在的文件
//    NSFileManager *defaultManager = [NSFileManager defaultManager];
//    [defaultManager removeItemAtPath:logFilePath error:nil];
    
    // 将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+", stderr);
}
#pragma mark 获取未读消息数量
-(void)fetchUnreadCount
{
    if ([UTCache readClassId]&&[UTCache readClassId].length>0) {
        UnreadApi *api = [[UnreadApi alloc]initWithClassId:[UTCache readClassId]];
        [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
            NSDictionary *dic= successMsg.responseData;
            NSDictionary *taskUnreadDic = [dic objectForKey:@"taskUnread"];
            NSNumber *noticeUR= [taskUnreadDic objectForKey:@"noticeUnread"];
            NSNumber *homeworkUR= [taskUnreadDic objectForKey:@"studentTaskUnread"];
            NSNumber *examUR= [taskUnreadDic objectForKey:@"examUnread"];
            NSNumber *circleUR = [dic objectForKey:@"circleUnread"];
            NSDictionary *msgUnreadDic = [dic objectForKey:@"uTMsg"];
            NSNumber *systemUR= [msgUnreadDic objectForKey:@"systemUnread"];
            NSNumber *schoolMsgUR= [msgUnreadDic objectForKey:@"schoolMsgUnread"];
            [RedDotHelper shareInstance].noticeUnread=(int)noticeUR.longValue;
            [RedDotHelper shareInstance].studentTaskUnread=(int)homeworkUR.longValue;
            [RedDotHelper shareInstance].examUnread=(int)examUR.longValue;
            [RedDotHelper shareInstance].circleUnread=circleUR.boolValue?1:0;
            [RedDotHelper shareInstance].systemUnread=(int)systemUR.longValue;
            [RedDotHelper shareInstance].schoolMsgUnread=(int)schoolMsgUR.longValue;
            [self updateTabbarItemBadgeView];
            
        } onFailure:^(FailureMsg * _Nonnull message) {
            
        }];
    }
    
    
}

-(void)updateTabbarItemBadgeView
{
    
    NSArray *items = [self.rootTabbarCtr.tabBar items];
    int workUnreadCount = [RedDotHelper shareInstance].examUnread
                            +[RedDotHelper shareInstance].studentTaskUnread
                            +[RedDotHelper shareInstance].noticeUnread;
    int messageUnreadCount =[RedDotHelper shareInstance].systemUnread
                            +[RedDotHelper shareInstance].chatUnread
                            +[RedDotHelper shareInstance].schoolMsgUnread;
    
    int momentUnreadCount = [RedDotHelper shareInstance].circleUnread;
    UITabBarItem *workItem = [items objectAtIndex:1];
//    UITabBarItem *momentItem = [items objectAtIndex:2];
    UITabBarItem *msgItem = [items objectAtIndex:3];
    if (workUnreadCount>0) {
        workItem.badgeValue = [NSString stringWithFormat:@"%d",workUnreadCount];
    }else{
        workItem.badgeValue=nil;
    }
    if(messageUnreadCount>0) {
        msgItem.badgeValue = [NSString stringWithFormat:@"%d",messageUnreadCount];
    }else{
        msgItem.badgeValue=nil;
    }
    if(momentUnreadCount>0) {
        [self.rootTabbarCtr.tabBar zb_showBadgeOnItemIndex:2];
    }else{

        [self.rootTabbarCtr.tabBar zb_hideBadgeOnItemIndex:2];
    }
}

@end
