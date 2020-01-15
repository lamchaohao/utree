//
//  ClassworkHomeVC.m
//  utree
//
//  Created by 科研部 on 2019/8/7.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ClassworkHomeVC.h"
#import "PostMenuVC.h"
#import "PostNoticeVC.h"
#import "SelectReadClassVC.h"
#import "PostHomeworkVC.h"
#import "TYTabPagerView.h"
#import "NoticeView.h"
#import "HomeworkListView.h"
#import "AchievementView.h"
#import "SelectSubjectsVC.h"
#import "UTCache.h"
#import "RedDotHelper.h"
@interface ClassworkHomeVC ()<PostMenuDelegate,TYTabPagerViewDataSource, TYTabPagerViewDelegate,UTViewDelegate>

@property(nonatomic,strong)NoticeView *noticeView;
@property(nonatomic,strong)HomeworkListView *homeworkView;
@property(nonatomic,strong)AchievementView *achievementView;
@property(strong, nonatomic)UIButton *mainMenuBtn;
@property(nonatomic,strong)TYTabPagerView *pagerView;
@property(nonatomic,strong)NSArray *titleArray;
@end

@implementation ClassworkHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeClassworkTitleName:) name:ClazzChangedNotifycationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBadgeViewStatus:) name:BadgeValueUpdateNotifyName object:nil];
    self.view.backgroundColor=[UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initScrollView];
    [self initPostButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self changeClassworkTitleName:nil];
    [self.pagerView.tabBar reloadData];
}

-(void)changeClassworkTitleName:(id)send
{
    NSString *className = @"";
    if ([UTCache readClassName]) {
        className=[UTCache readClassName];
    }
    self.title=[NSString stringWithFormat:@"%@班务",className];
}

-(void)updateBadgeViewStatus:(id)send
{
    [_pagerView reloadData];
}

-(void)initScrollView{
    
    _titleArray = @[@"通知",@"作业",@"成绩"];
    TYTabPagerView *pagerView = [[TYTabPagerView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) andTitles:_titleArray topTitle:YES andFullOfWidth:YES];
    pagerView.tabBar.frame = CGRectMake(0, 8, ScreenWidth-20, 36);
    pagerView.tabBar.layout.barStyle = TYPagerBarStyleProgressView;
    pagerView.tabBar.layout.normalTextColor = [UIColor myColorWithHexString:@"#666666"];
    pagerView.tabBar.layout.normalTextFont =[UIFont systemFontOfSize:16];
    pagerView.tabBar.layout.selectedTextColor =[UIColor myColorWithHexString:PrimaryColor];
    pagerView.tabBar.layout.selectedTextFont =[UIFont systemFontOfSize:16];
    pagerView.tabBar.progressView.backgroundColor= [UIColor myColorWithHexString:PrimaryColor];
    pagerView.dataSource = self;
    pagerView.delegate = self;
    _pagerView = pagerView;

    [self.view addSubview:pagerView];
    [_pagerView scrollToViewAtIndex:0 animate:YES];
    [_pagerView reloadData];
    self.pagerView.myTop=10;
    self.pagerView.myLeft=14;

}

- (NSInteger)numberOfViewsInTabPagerView {
    return _titleArray.count;
}

- (UIView *)tabPagerView:(TYTabPagerView *)tabPagerView viewForIndex:(NSInteger)index prefetching:(BOOL)prefetching
{
    switch (index) {
        case 0:
            return self.noticeView;
            break;
        case 1:
            return self.homeworkView;
        case 2:
            return self.achievementView;
        default:
            return self.noticeView;
            break;
    }
    
}


- (NSString *)tabPagerView:(TYTabPagerView *)tabPagerView titleForIndex:(NSInteger)index {
    return _titleArray[index];
}

- (BOOL)tabPagerView:(TYTabPagerView *)tabPagerView showbadgeViewForIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            NSLog(@"noticeUnread=%d",[RedDotHelper shareInstance].noticeUnread);
            return [RedDotHelper shareInstance].noticeUnread!=0;
        case 1:
            NSLog(@"studentTaskUnread=%d",[RedDotHelper shareInstance].studentTaskUnread);
            return [RedDotHelper shareInstance].studentTaskUnread!=0;
        case 2:
            NSLog(@"examUnread=%d",[RedDotHelper shareInstance].examUnread);
            return [RedDotHelper shareInstance].examUnread!=0;
        default:
            break;
    }
    return index%2!=0;
}

- (void)tabPagerView:(TYTabPagerView *)tabPagerView willAppearView:(UIView *)view forIndex:(NSInteger)index
{
    NSLog(@"classwork tabPagerView willAppearView %ld",index);
    switch (index) {
        case 0:
            [self.homeworkView viewWillDisappear:NO];
            [self.achievementView viewWillDisappear:NO];
            [self.noticeView viewWillAppear:NO];
            break;
        case 1:
            [self.noticeView viewWillDisappear:NO];
            [self.achievementView viewWillDisappear:NO];
            [self.homeworkView viewWillAppear:NO];
            break;
        case 2:
            [self.noticeView viewWillDisappear:NO];
            [self.homeworkView viewWillDisappear:NO];
            [self.achievementView viewWillAppear:NO];
            break;
        default:
            [self.homeworkView viewWillDisappear:NO];
            [self.achievementView viewWillDisappear:NO];
            [self.noticeView viewWillAppear:NO];
            break;
    }
}

- (NoticeView *)noticeView
{
    if (!_noticeView) {
        _noticeView = [[NoticeView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-iPhone_Bottom_NavH) isSelfData:NO];
        _noticeView.utViewDelegate = self;
    }
    return _noticeView;
}

- (HomeworkListView *)homeworkView
{
    if(!_homeworkView){
        _homeworkView =[[HomeworkListView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-iPhone_Bottom_NavH) isSelfData:NO];
        _homeworkView.utViewDelegate = self;
    }
    return _homeworkView;
}

- (AchievementView *)achievementView
{
    if(!_achievementView){
        _achievementView =[[AchievementView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-iPhone_Bottom_NavH) isSelfData:NO];
        _achievementView.utViewDelegate = self;
    }
    return _achievementView;
}


-(void)initPostButton
{
    _mainMenuBtn=[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth*0.85, ScreenHeight*0.7, 54, 54)];
    [_mainMenuBtn setImage:[UIImage imageNamed:@"ic_edit_work"] forState:UIControlStateNormal];
    
    [_mainMenuBtn sizeToFit];
    [_mainMenuBtn addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    UIPanGestureRecognizer *panGes= [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panScroll:)];
    
    [_mainMenuBtn addGestureRecognizer:panGes];
    [self.view addSubview:_mainMenuBtn];
}

- (void)panScroll:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {//设置拖动范围
        CGPoint translation = [recognizer locationInView:self.mainMenuBtn];
        CGPoint newCenter = CGPointMake(recognizer.view.center.x+ translation.x,
                                        recognizer.view.center.y + translation.y);
        newCenter.y = MIN(ScreenHeight-30, newCenter.y);
        newCenter.y = MAX(iPhone_Top_NavH, newCenter.y);//iPhone_Top_NavH-SegmentTitleViewHeight
        newCenter.x = MAX(30, newCenter.x);
        newCenter.x = MIN(ScreenWidth-30,newCenter.x);
        if (newCenter.y>ScreenHeight-iPhone_Top_NavH-iPhone_Bottom_NavH-iPhone_StatuBarHeight) {
            
            newCenter.y =ScreenHeight-iPhone_Top_NavH-iPhone_Bottom_NavH-iPhone_StatuBarHeight;
        }
        recognizer.view.center = newCenter;
        [recognizer setTranslation:CGPointZero inView:self.mainMenuBtn];

    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {//可以在这里做一些复位处理
        
    }
}

-(void)showMenu:(id)sender
{
    PostMenuVC *postMenuView = [[PostMenuVC alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    postMenuView.delegate = self;
    [postMenuView showMenuView];

}


-(void)postNotice:(id)sender
{
    SelectReadClassVC *selectClassVC = [[SelectReadClassVC alloc]init];
//    postVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    [self presentViewController:postVC animated:YES completion:nil];
    selectClassVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:selectClassVC animated:YES];

}

-(void)postHomework:(id)sender
{
    SelectSubjectsVC *selectSubVC = [[SelectSubjectsVC alloc]init];
    selectSubVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:selectSubVC animated:YES];

}

- (void)pushToViewController:(UIViewController *)vc
{
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
