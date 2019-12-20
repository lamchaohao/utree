//
//  AchievementDetailVC.m
//  utree
//
//  Created by 科研部 on 2019/12/10.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "AchievementDetailVC.h"
#import "AchievementDetailView.h"
#import "AppDelegate.h"
#import "AchievementModel.h"
#import "AchievementDC.h"
@interface AchievementDetailVC ()
@property(nonatomic,strong)AchievementDetailView *detailView;
@property(nonatomic,strong)AchievementModel *model;
@property(nonatomic,strong)AchievementDC *dataController;
@end

@implementation AchievementDetailVC

- (instancetype)initWithAchievementModel:(AchievementModel *)model
{
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataController = [[AchievementDC alloc]init];
    self.detailView = [[AchievementDetailView alloc]initWithFrame:CGRectMake(0, iPhone_Top_NavH, self.view.frame.size.width, self.view.frame.size.height-iPhone_Top_NavH) andAchievementModel:self.model];
    [self.view addSubview:self.detailView];
    
    [self loadData];
}

-(void)loadData
{
    [self.dataController requestStudentScoreListWithExamId:self.model.examId WithSuccess:^(UTResult * _Nonnull result) {
        NSArray *scores = result.successResult;
        [self.detailView addScoreListToView:scores];
    } failure:^(UTResult * _Nonnull result) {
        [self.view makeToast:result.failureResult];
    }];
}



- (void)viewWillAppear:(BOOL)animated
{
    self.title = @"成绩单";
    [self initNaviBar];
    /** 设置返回箭头颜色 */
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //改变UITabBarItem字体颜色 //UITextAttributeTextColor
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.rootTabbarCtr.tabBar.tintColor = [UIColor whiteColor];
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
