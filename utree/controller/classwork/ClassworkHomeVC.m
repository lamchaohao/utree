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
@interface ClassworkHomeVC ()<FSPageContentViewDelegate,FSSegmentTitleViewDelegate>

@property (nonatomic, strong) FSPageContentView *pageContentView;
@property (nonatomic, strong) FSSegmentTitleView *titleView;
@property(nonatomic,strong)NoticeVC *noticeVC;
@property(nonatomic,strong)NoticeVC *homeworkVC;
@property(nonatomic,strong)NoticeVC *gradeVC;
@end

@implementation ClassworkHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self initTabItem];
    [self initScrollView];
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

@end
