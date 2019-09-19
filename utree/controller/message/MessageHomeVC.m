//
//  MessageHomeVC.m
//  utree
//
//  Created by 科研部 on 2019/8/7.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "MessageHomeVC.h"
#import "FSScrollContentView.h"
@interface MessageHomeVC ()<FSPageContentViewDelegate,FSSegmentTitleViewDelegate>

@property (nonatomic, strong) FSPageContentView *pageContentView;
@property (nonatomic, strong) FSSegmentTitleView *titleView;

@end

@implementation MessageHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self initTabItem];
}

-(void)initTabItem
{
    self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 8, CGRectGetWidth(self.view.bounds), 30) titles:@[@"系统信息",@"私信",@"学校通知"] delegate:self indicatorType:FSIndicatorTypeDefault];
    self.titleView.titleSelectFont = [UIFont systemFontOfSize:16];
    self.titleView.selectIndex = 0;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:_titleView];
}

@end
