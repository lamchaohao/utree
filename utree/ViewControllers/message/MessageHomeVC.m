//
//  MessageHomeVC.m
//  utree
//
//  Created by 科研部 on 2019/8/7.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "MessageHomeVC.h"
#import "FSScrollContentView.h"
#import "ChatListVC.h"
#import "SystemNoticeVC.h"
#import "SchoolInfoVC.h"
@interface MessageHomeVC ()<FSPageContentViewDelegate,FSSegmentTitleViewDelegate>

@property (nonatomic, strong) FSPageContentView *pageContentView;
@property (nonatomic, strong) FSSegmentTitleView *titleView;
@end

@implementation MessageHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initTabItem];
    [self initScrollView];
}

-(void)initTabItem
{
    self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 8, CGRectGetWidth(self.view.bounds), 30) titles:@[@"系统信息",@"私信",@"学校通知"] delegate:self indicatorType:FSIndicatorTypeDefault];
    self.titleView.titleSelectFont = [UIFont systemFontOfSize:16];
    self.titleView.selectIndex = 0;
    
    [self.view addSubview:_titleView];
}


-(void)initScrollView{
    SystemNoticeVC *systemVC= [[SystemNoticeVC alloc]init];
    ChatListVC *chatVC = [[ChatListVC alloc]init];
    SchoolInfoVC *schoolVC = [[SchoolInfoVC alloc]init];
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    [childVCs addObject:systemVC];
    [childVCs addObject:chatVC];
    [childVCs addObject:schoolVC];
    
    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-90) childVCs:childVCs parentVC:self delegate:self];
    self.pageContentView.contentViewCurrentIndex = 1;
    self.titleView.selectIndex = 1;
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
