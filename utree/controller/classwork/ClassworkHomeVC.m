//
//  ClassworkHomeVC.m
//  utree
//
//  Created by 科研部 on 2019/8/7.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ClassworkHomeVC.h"
#import "FSScrollContentView.h"
#import "Notice/NoticeVC.h"
#import "PostMenuVC.h"
@interface ClassworkHomeVC ()<FSPageContentViewDelegate,FSSegmentTitleViewDelegate>

@property (nonatomic, strong) FSPageContentView *pageContentView;
@property (nonatomic, strong) FSSegmentTitleView *titleView;
@property(nonatomic,strong)NoticeVC *noticeVC;
@property(nonatomic,strong)NoticeVC *homeworkVC;
@property(nonatomic,strong)NoticeVC *gradeVC;
@property (strong, nonatomic)UIButton *mainMenuBtn;

@end

@implementation ClassworkHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self initTabItem];
    [self initScrollView];
    [self initPostButton];
}

-(void)initTabItem
{
    self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 8, CGRectGetWidth(self.view.bounds), SegmentTitleViewHeight) titles:@[@"通知",@"作业",@"成绩"] delegate:self indicatorType:FSIndicatorTypeDefault];
    self.titleView.titleSelectFont = [UIFont systemFontOfSize:16];
    self.titleView.selectIndex = 0;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:_titleView];
}


-(void)initScrollView{
    _noticeVC = [[NoticeVC alloc]init];
    _homeworkVC =  [[NoticeVC alloc]init];
    _gradeVC = [[NoticeVC alloc]init];
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    [childVCs addObject:_noticeVC];
    [childVCs addObject:_homeworkVC];
    [childVCs addObject:_gradeVC];
    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-90) childVCs:childVCs parentVC:self delegate:self];
    self.pageContentView.contentViewCurrentIndex = 2;
    //    self.pageContentView.contentViewCanScroll = NO;//设置滑动属性
    _titleView.myTop=0;
    [self.view addSubview:_pageContentView];
    
}

- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.pageContentView.contentViewCurrentIndex = endIndex;
   
    
}

- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.titleView.selectIndex = endIndex;
    //    self.title = @[@"个人",@"小组"][endIndex];
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
    PostMenuVC *menuVC = [[PostMenuVC alloc]init];
    menuVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    [self presentViewController:menuVC animated:NO completion:nil];
    [self.navigationController pushViewController:menuVC animated:NO];


}

@end
