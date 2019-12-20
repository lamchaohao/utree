//
//  ClassroomHomeVC.m
//  utree
//
//  Created by 科研部 on 2019/8/7.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ClassroomHomeVC.h"
#import "ZBTabView.h"
#import "MMAlertView.h"
#import "ClassStudentsVC.h"
#import "ClassGroupVC.h"
#import "FSScrollContentView.h"
#import "AutoScaleFrameMain.h"
#import "AttendanceVC.h"
#import "RandomVC.h"
#import "LeftDrawerView.h"


@interface ClassroomHomeVC ()<FSPageContentViewDelegate,FSSegmentTitleViewDelegate>

@property (nonatomic, strong) FSPageContentView *pageContentView;
@property (nonatomic, strong) FSSegmentTitleView *titleView;

@property (strong, nonatomic)ClassStudentsVC *personVC;
@property (strong, nonatomic)ClassGroupVC *groupVC;
@property (strong, nonatomic)UIView *maskView;
@property (strong, nonatomic)UIButton *mainMenuBtn;
@property (strong, nonatomic)UIButton *attendanceBtn;
@property (strong, nonatomic)UIButton *sortBtn;
@property (strong, nonatomic)UIButton *showListBtn;
@property (strong, nonatomic)UIButton *randomBtn;
@property (strong, nonatomic)UIBarButtonItem *rightbarItem;
@end

@implementation ClassroomHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBarbutton];
    [self initTabButton];
    [self initScrollView];
    [self initMenuBtn];
    self.view.backgroundColor=[UIColor whiteColor];

}

-(void)initBarbutton{
     self.tabBarController.tabBar.translucent = false;//列表不需被隐藏到tabbar下面
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIImage *leftNaviMenuImg= [[UIImage imageNamed:@"ic_navi_menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftbarItem= [[UIBarButtonItem alloc]initWithImage:leftNaviMenuImg style:UIBarButtonItemStylePlain target:self action:@selector(showLeftView:)];
    self.navigationItem.leftBarButtonItem=leftbarItem;
    
    _rightbarItem = [[UIBarButtonItem alloc]initWithTitle:@"多选" style:UIBarButtonItemStylePlain target:self action:@selector(onMultiChoiceClick:)];
    _rightbarItem.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem=_rightbarItem;
}

#pragma mark 左边菜单显示
-(void)showLeftView:(UIButton *)sender{
    [self.viewDeckController openSide:IIViewDeckSideLeft animated:YES];

}

#pragma mark 多选按钮点击
-(void)onMultiChoiceClick:(UIButton *)sender{
    if ([_rightbarItem.title containsString:@"方案"]) {
        [_groupVC onRightMenuClick];
    }else{
        [_personVC switchToMultiChoice];
    }
}



-(void)initTabButton{

    self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 8, CGRectGetWidth(self.view.bounds), 30) titles:@[@"个人",@"小组"] delegate:self indicatorType:FSIndicatorTypeDefault];
    self.titleView.titleSelectFont = [UIFont systemFontOfSize:16];
    self.titleView.selectIndex = 0;

    [self.view addSubview:_titleView];
   
}

-(void)initScrollView{
    _personVC = [[ClassStudentsVC alloc]init];
    _groupVC = [[ClassGroupVC alloc]init];
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    [childVCs addObject:_personVC];
    [childVCs addObject:_groupVC];
    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-90) childVCs:childVCs parentVC:self delegate:self];
    self.pageContentView.contentViewCurrentIndex = 2;

    self.pageContentView.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:_pageContentView];
   

}

- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.pageContentView.contentViewCurrentIndex = endIndex;
    if (endIndex==0) {
        _rightbarItem.title=@"多选";
    }else{
        _rightbarItem.title=@"方案";
    }
    
}

- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.titleView.selectIndex = endIndex;
    if (endIndex==0) {
        _rightbarItem.title=@"多选";
    }else{
        _rightbarItem.title=@"方案";
    }

}

-(void)initMenuBtn{
    
    _attendanceBtn=[[UIButton alloc]init];
    [_attendanceBtn setImage:[UIImage imageNamed:@"btn_attendance_menu"] forState:UIControlStateNormal];
    [_attendanceBtn sizeToFit];
    [_attendanceBtn addTarget:self action:@selector(jumpToAttendance:) forControlEvents:UIControlEventTouchUpInside];
    
    _sortBtn=[[UIButton alloc]init];
    [_sortBtn setImage:[UIImage imageNamed:@"btn_sort_menu"] forState:UIControlStateNormal];
    [_sortBtn sizeToFit];
    [_sortBtn addTarget:self action:@selector(sortMenuClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _randomBtn=[[UIButton alloc]init];
    [_randomBtn setImage:[UIImage imageNamed:@"btn_random_menu"] forState:UIControlStateNormal];
    [_randomBtn sizeToFit];
    [_randomBtn addTarget:self action:@selector(showRandomDialog:) forControlEvents:UIControlEventTouchUpInside];
    
    _showListBtn=[[UIButton alloc]init];
    [_showListBtn setImage:[UIImage imageNamed:@"btn_list_menu"] forState:UIControlStateNormal];
    [_showListBtn sizeToFit];
    [_showListBtn addTarget:self action:@selector(showListView:) forControlEvents:UIControlEventTouchUpInside];
    
    //展开菜单按钮
    _mainMenuBtn=[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth*0.85, ScreenHeight-ScreenWidth*0.30-[self getStatusBarAndNavHeight], 54, 54)];
    [_mainMenuBtn setImage:[UIImage imageNamed:@"btn_classroom_menu"] forState:UIControlStateNormal];
    
    [_mainMenuBtn sizeToFit];
    [_mainMenuBtn addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    UIPanGestureRecognizer *panGes= [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panScroll:)];
    
    [_mainMenuBtn addGestureRecognizer:panGes];
//    menuBtn.myBottom=ScreenWidth*0.203-18;
//    menuBtn.myTrailing = 8;
    [self.view addSubview:_mainMenuBtn];
    
    _attendanceBtn.frame=CGRectMake(0, 0, 54, 54);
    _sortBtn.frame=CGRectMake(0, 0, 54, 54);
    _randomBtn.frame=CGRectMake(0, 0, 54, 54);
    _showListBtn.frame=CGRectMake(0, 0, 54, 54);
    [self layoutMenuButton];
    
    
    _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
//    _maskView
    _maskView.userInteractionEnabled = YES;

    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureEvent:)];
    [_maskView addGestureRecognizer:tapGesture];
    [tapGesture setNumberOfTapsRequired:1];
    
    [self.view addSubview:_maskView];
    [self.view addSubview:_attendanceBtn];
    [self.view addSubview:_sortBtn];
    [self.view addSubview:_randomBtn];
    [self.view addSubview:_showListBtn];
    
    [self hideExtendButton];
}

#pragma mark 处理点击菜单外的屏幕
-(void)gestureEvent:(UITapGestureRecognizer *)gesture
{
    [self hideExtendButton];
}

-(void)hideExtendButton
{
    [_maskView setHidden:YES];
    [_attendanceBtn setHidden:true];
    [_sortBtn setHidden:true];
    [_randomBtn setHidden:true];
    [_showListBtn setHidden:true];
}

-(void)showMenu:(UIButton *)sender
{
    bool hid = ![_attendanceBtn isHidden];
    [_maskView setHidden:hid];
    [_attendanceBtn setHidden:hid];
    [_sortBtn setHidden:hid];
    [_randomBtn setHidden:hid];
    [_showListBtn setHidden:hid];
   
}

-(void)jumpToAttendance:(UIButton *)sender
{
    
    AttendanceVC *detailVC = [[AttendanceVC alloc]init];
//注意是UIViewController调用hidesBottomBarWhenPushed而不是UINavigationController
    detailVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    [self hideExtendButton];
}

-(void)showRandomDialog:(UIButton *)sender
{
    RandomVC *randomVC= [[RandomVC alloc]init];
    randomVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:randomVC animated:YES completion:nil];
    [self hideExtendButton];
}

-(void)showListView:(UIButton *)sender
{
     BOOL showingGrid = [_personVC switchToGridView];
    if (showingGrid) {
        [_showListBtn setImage:[UIImage imageNamed:@"btn_list_menu"] forState:UIControlStateNormal];
    }else{
        [_showListBtn setImage:[UIImage imageNamed:@"btn_grid_menu"] forState:UIControlStateNormal];
    }
     [self hideExtendButton];
}

-(void)sortMenuClick:(UIButton *)sender
{

    MMPopupItemHandler block = ^(NSInteger index){
        NSLog(@"clickd %@ button",@(index));
        
    };
    MMPopupCompletionBlock completeBlock = ^(MMPopupView *popupView, BOOL finished){
        NSLog(@"animation complete");
    };
    //MMAlertView
    NSArray *items =
  @[MMItemMake(@"按名字首字母排序", MMItemTypeNormal, block),
    MMItemMake(@"按水滴最多排序", MMItemTypeHighlight, block)];
    
    [[[MMAlertView alloc] initWithTitle:nil
                                 detail:@"请选择排序"
                                  items:items]
     showWithBlock:completeBlock];
    
    
    [self hideExtendButton];
}

-(CGFloat)getStatusBarAndNavHeight
{
    //获取状态栏的rect
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    //获取导航栏的rect
    CGRect navRect = self.navigationController.navigationBar.frame;
    //那么导航栏+状态栏的高度
    CGFloat height =statusRect.size.height+navRect.size.height;
    height += self.tabBarController.tabBar.frame.size.height;
    return height;
    
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
        
        [self layoutMenuButton];

    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {//可以在这里做一些复位处理
        
    }
}

#define degreesToRadians(degrees) ((degrees * (float)M_PI) / 180.0f)  //这个公式是计算弧度的

-(void)layoutMenuButton
{
    int startValue = 0;
    int separateValue = 4;
    NSArray *menuButtonArr = [NSArray arrayWithObjects:self.showListBtn, self.randomBtn,self.sortBtn,self.attendanceBtn,nil];
    for (int i= 1; i<=menuButtonArr.count;i++) {
        //_separateValue 几等分  _startValue 布局开始的位置,通过它来控制左半圆或者右半圆
        float angle = degreesToRadians((180 / separateValue) * (i+startValue));
        int radius = 80;
        //下面两个就是通过正余弦计算中心点的
        float y = cos(angle) * radius;
        float x = sin(angle) * radius;
        CGPoint center = CGPointMake(0, 0);
        if (_mainMenuBtn.center.x>ScreenWidth/2) {
            center.x = _mainMenuBtn.center.x - x;
        }else{
            center.x = _mainMenuBtn.center.x + x;
        }
        center.y =_mainMenuBtn.center.y + y;
        ((UIButton *) [menuButtonArr objectAtIndex:(i-1)]).center = center;
    }
}

@end
