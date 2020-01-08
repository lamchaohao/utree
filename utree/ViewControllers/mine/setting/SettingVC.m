//
//  SettingVC.m
//  utree
//
//  Created by 科研部 on 2019/9/5.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "SettingVC.h"
#import "AccountSafeVC.h"
#import "FeedbackVC.h"
#import "AboutVC.h"
#import "MainLoginVC.h"
#import "ClearCacheTool.h"
#import "MMAlertView.h"
#import "AppDelegate.h"
@interface SettingVC ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong) NSArray *itemNames;
@end

@implementation SettingVC
static NSString *CellID = @"staticCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}


-(void)initView
{
    self.title=@"设置";
    self.view.backgroundColor=[UIColor_ColorChange colorWithHexString:@"#F7F7F7"];
    _itemNames = [[NSArray alloc]initWithObjects:@"账号与安全",@"接收信息通知",@"清除缓存",@"关于优树成长",@"意见与反馈", nil] ;
  _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellID];
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.tableView.bounds.size.width,0.01)];
    [self.view addSubview:_tableView];
    
    UIButton *logoutBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth*0.086, ScreenHeight -ScreenWidth*0.26, ScreenWidth*0.8285, ScreenWidth*0.12)];
    logoutBtn.myLeft=logoutBtn.myRight=35;
//    logoutBtn.bottomPos.equalTo(self.bottomPos).offset(12);
    
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutBtn setBackgroundColor:[UIColor myColorWithHexString:@"#FB5B5B"]];
    logoutBtn.layer.cornerRadius = ScreenWidth*0.12/2;
    
//    UIButton *logoutBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth*0.086, ScreenHeight -ScreenWidth*0.26, ScreenWidth*0.8285, ScreenWidth*0.174)];
//    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
//    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [logoutBtn setBackgroundImage:[UIImage imageNamed:@"bg_red_round_conner"] forState:UIControlStateNormal];

    [logoutBtn addTarget:self action:@selector(logoutClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: logoutBtn];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            AccountSafeVC *accountVC = [[AccountSafeVC alloc]init];
            //注意是UIViewController调用hidesBottomBarWhenPushed而不是UINavigationController
            [self pushIntoWithoutNavChange:accountVC];
        }
            break;
        case 2:
        {
            [self clearCacheDialogShow];
        }
            break;
        case 3:
        {
            AboutVC *aboutVC = [[AboutVC alloc]init];
            [self pushIntoWithoutNavChange:aboutVC];
        }
            break;
        case 4:
        {
            FeedbackVC *feedbackVc = [[FeedbackVC alloc]init];
            //注意是UIViewController调用hidesBottomBarWhenPushed而不是UINavigationController
            [self pushIntoWithoutNavChange:feedbackVc];
        }
            break;
        default:
            break;
    }
    
    //选中后不变色
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1
                                      reuseIdentifier: CellID];
    }
    [cell.textLabel setText:_itemNames[indexPath.row]];
    if (indexPath.row==1) {
        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchview;

    }else if(indexPath.row==2){
        NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *sizeStr = [ClearCacheTool getCacheSizeWithFilePath:cachesPath];
        [cell.detailTextLabel setText:sizeStr];
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _itemNames.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (ScreenWidth*0.15);
}

- (void)viewWillAppear:(BOOL)animated
{
    self.showNavigationBarImageWhenDisappear = YES;
    [super viewWillAppear:animated];
    
}

-(void)clearCacheDialogShow
{
    MMPopupItemHandler positiveHandler = ^(NSInteger index){
         NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        [ClearCacheTool clearCacheWithFilePath:cachesPath];
        [self.tableView reloadData];
    };
    MMPopupItemHandler nagativeHandler = ^(NSInteger index){
        
    };
    NSArray *items =
    @[MMItemMake(@"确定", MMItemTypeNormal, positiveHandler),
      MMItemMake(@"取消", MMItemTypeHighlight, nagativeHandler)];
    
    MMAlertView *dismissAlert = [[MMAlertView alloc]initWithTitle:@"确定清理缓存?" detail:@"" items:items];
    
    [dismissAlert show];
}


-(void)logoutClick:(UIButton *)btn
{
    MMPopupItemHandler positiveHandler = ^(NSInteger index){
        
//        MainLoginVC *mainLogin = [[MainLoginVC alloc] init];
//        mainLogin.modalPresentationStyle=UIModalPresentationOverFullScreen;
//        [self presentViewController:mainLogin animated:YES completion:nil];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate toLoginVC];
    };
    MMPopupItemHandler nagativeHandler = ^(NSInteger index){
        
    };
    NSArray *items =
    @[MMItemMake(@"确定", MMItemTypeNormal, positiveHandler),
      MMItemMake(@"取消", MMItemTypeHighlight, nagativeHandler)];
    
    MMAlertView *dismissAlert = [[MMAlertView alloc]initWithTitle:@"确定退出登录？" detail:@"" items:items];
    
    [dismissAlert show];
    
    
}


@end
