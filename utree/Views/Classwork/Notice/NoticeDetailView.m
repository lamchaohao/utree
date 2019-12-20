//
//  NoticeDetailView.m
//  utree
//
//  Created by 科研部 on 2019/12/2.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "NoticeDetailView.h"
#import "JXCategoryIndicatorLineView.h"
#import "ParentworkTableView.h"
#import "WorkHeaderViewModel.h"
@interface NoticeDetailView()<JXCategoryViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) NSArray <NSString *> *titles;
@property (nonatomic, strong) NoticeModel *noticeModel;
@property (nonatomic, strong)ParentworkTableView *parentCheckListView;
@property (nonatomic, strong)ParentworkTableView *parentUnCheckListView;
@property (nonatomic, strong)UIButton *onekeyRemindBtn;
@property (nonatomic, assign)BOOL needShowParentCheckList;

@end

@implementation NoticeDetailView



- (instancetype)initWithFrame:(CGRect)frame andNoticeModel:(NoticeModel *)notice needList:(BOOL)need
{
    self = [super initWithFrame:frame];
    if (self) {
        self.needShowParentCheckList = need;
        self.noticeModel = notice;
        [self setUpUI];
    }
    return self;
}


-(void)setUpUI
{
    self.backgroundColor = [UIColor myColorWithHexString:@"#F5F5F5"];
    _titles = @[@"已查看", @"未查看"];
    WorkHeaderViewModel *vm = [[WorkHeaderViewModel alloc]init];
    [vm setNoticeToCaculate:self.noticeModel];
    
    _userHeaderView = [[WorkHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, vm.cellHeight) viewModel:vm];
    
    [_userHeaderView setViewModel:vm];
    
    if (!_needShowParentCheckList) {
        [self addSubview:_userHeaderView];
        return;
    }
  
    _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    self.categoryView.titles = self.titles;
    self.categoryView.backgroundColor = [UIColor whiteColor];
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = [UIColor myColorWithHexString:PrimaryColor];
    self.categoryView.titleColor = [UIColor blackColor];
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.titleLabelZoomEnabled = YES;
    
    
    self.categoryView.contentScrollViewClickTransitionAnimationEnabled = NO;

    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = [UIColor myColorWithHexString:PrimaryColor];
    lineView.indicatorWidth = 30;
    self.categoryView.indicators = @[lineView];

    _pagerView = [self preferredPagingView];
    self.pagerView.mainTableView.gestureDelegate = self;
    [self addSubview:self.pagerView];
    
    self.categoryView.contentScrollView = self.pagerView.listContainerView.collectionView;
    
    CGFloat btnHeight=49;
    if (iPhone_Safe_BottomNavH==34) {
        btnHeight += 20;
    }
    self.onekeyRemindBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-btnHeight, ScreenWidth, btnHeight)];
    [self.onekeyRemindBtn setBackgroundColor:[UIColor myColorWithHexString:PrimaryColor]];
    [self.onekeyRemindBtn setTitle:@"一键提醒" forState:UIControlStateNormal];
    [self.onekeyRemindBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.pagerView.frame = self.bounds;
}

- (JXPagerView *)preferredPagingView {
    
    return [[JXPagerView alloc] initWithDelegate:self];
}


#pragma mark - JXPagerViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.userHeaderView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return _userHeaderView.frame.size.height;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return 50;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    //和categoryView的item数量一致
    return self.categoryView.titles.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    ParentworkTableView *listView=[[ParentworkTableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.frame.size.height-50)];
    listView.isNeedFooter= _isNeedFooter;
    listView.isNeedHeader = _isNeedHeader;
    if (index == 0) {
        [self.dataDelegate getParentListWithCheck:[NSNumber numberWithBool:YES]];
        self.parentCheckListView = listView;
    }else if (index == 1) {
       [self.dataDelegate getParentListWithCheck:[NSNumber numberWithBool:NO]];
        self.parentUnCheckListView = listView;
    }
    return listView;
}

-(void)setDataSourceWithCheck:(BOOL) isCheck parents:(NSArray *)parents
{
    if (isCheck) {
        self.parentCheckListView.dataSource = parents.mutableCopy;
        self.parentCheckListView.isCheckData = YES;
        [self.parentCheckListView beginFirstRefresh];
    }else{
        self.parentUnCheckListView.dataSource = parents.mutableCopy;
        self.parentCheckListView.isCheckData = NO;
        [self.parentUnCheckListView beginFirstRefresh];
        
        if (parents.count>0) {
            ParentCheckModel *checkModel =[parents objectAtIndex:0];
            if(checkModel.remindTime.intValue==0){
                [self.onekeyRemindBtn addTarget:self action:@selector(remindAllClick:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:self.onekeyRemindBtn];
            }else{
                
            }
        }
    }
    
}

-(void)remindAllClick:(id)send
{
    [self.dataDelegate onekeyRemindAll];
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index
{
    if (index==0) {
        [self.onekeyRemindBtn setHidden:YES];
    }else{
        [self.onekeyRemindBtn setHidden:NO];
    }
}

#pragma mark - JXPagerMainTableViewGestureDelegate

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

@end
