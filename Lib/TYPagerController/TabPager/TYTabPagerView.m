//
//  TYTabPagerView.m
//  TYPagerControllerDemo
//
//  Created by tanyang on 2017/7/18.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYTabPagerView.h"

@interface TYTabPagerView ()<TYTabPagerBarDataSource,TYTabPagerBarDelegate,TYPagerViewDataSource, TYPagerViewDelegate>

// UI
@property (nonatomic, weak) TYTabPagerBar *tabBar;
@property (nonatomic, weak) TYPagerView *pageView;

// Data
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong)NSArray *titles;
@property(nonatomic,assign)BOOL isTitleOnTop;
@property(nonatomic,assign)BOOL isFullOrWidth;
@property(nonatomic,assign)CGRect titleFrame;
@property(nonatomic,assign)CGRect pageViewFrame;
@end

@implementation TYTabPagerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
           _tabBarHeight = 36;
           self.backgroundColor = [UIColor clearColor];
           self.isTitleOnTop=NO;
           [self initPosition];
           [self addTabBar];
           [self addPagerView];
       }
       return self;
}

- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles {
    if (self = [super initWithFrame:frame]) {
        _tabBarHeight = 36;
        self.backgroundColor = [UIColor clearColor];
        _titles = titles;
        self.isTitleOnTop=NO;
        [self initPosition];
        [self addTabBar];
        [self addPagerView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles topTitle:(BOOL)isOnTop andFullOfWidth:(BOOL)isFull{
    if (self = [super initWithFrame:frame]) {
        _tabBarHeight = 36;
        self.isTitleOnTop = isOnTop;
        self.isFullOrWidth=isFull;
        self.backgroundColor = [UIColor clearColor];
        _titles = titles;
        [self initPosition];
        [self addTabBar];
        
        [self addPagerView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _tabBarHeight = 36;
        self.backgroundColor = [UIColor clearColor];
        self.isTitleOnTop=NO;
        [self initPosition];
        [self addTabBar];
        
        [self addPagerView];
    }
    return self;
}

-(void)initPosition
{
    if (self.isTitleOnTop) {
        self.titleFrame = CGRectMake(0, 0, CGRectGetWidth(self.frame), _tabBarHeight);
        self.pageViewFrame = CGRectMake(0, _tabBarHeight, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - _tabBarHeight);
    }else{
       self.titleFrame = CGRectMake(0, self.frame.size.height-_tabBarHeight, CGRectGetWidth(self.frame), _tabBarHeight);
        self.pageViewFrame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - _tabBarHeight);
    }
}

- (void)addTabBar {
//    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc]initWithFrame:CGRectMake(0, self.frame.size.height-_tabBarHeight, CGRectGetWidth(self.frame), _tabBarHeight)];
    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc]initWithFrame:self.titleFrame];
    tabBar.dataSource = self;
    tabBar.delegate = self;
    
    [self addSubview:tabBar];
    _tabBar = tabBar;
    [self registerClass:[TYTabPagerBarCell class] forTabBarCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    CGFloat sumTitilesWidth = 0;
    //计算两标题之间的间隔
    for (NSString *title in _titles) {
        CGFloat width =[self cellWidthForTitle:title];
        sumTitilesWidth +=width;
    }
    CGFloat edgeWidth = (self.frame.size.width-sumTitilesWidth)/10;
    _tabBar.layout.cellEdging = edgeWidth;
}

- (void)addPagerView {
    TYPagerView *pageView = [[TYPagerView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), MAX(CGRectGetHeight(self.frame) - _tabBarHeight, 0))];
    pageView.dataSource = self;
    pageView.delegate = self;
    [self addSubview:pageView];
    _pageView = pageView;
}

//获取标题的宽度
- (CGFloat)cellWidthForTitle:(NSString *)title {
    if (!title) {
        return CGSizeZero.width;
    }
    //如果充满屏幕宽度
    if (self.isFullOrWidth) {
        CGFloat width = self.frame.size.width/3;
        NSLog(@"width== %f",width);
        return self.frame.size.width/3 -2;
    }
    //iOS 7
    CGRect frame = [title boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName:self.tabBar.layout.selectedTextFont} context:nil];
    return CGSizeMake(ceil(frame.size.width), ceil(frame.size.height) + 1).width;
}

#pragma mark - getter setter

- (void)setTabBarHeight:(CGFloat)tabBarHeight {
    BOOL isChangeValue = _tabBarHeight != tabBarHeight;
    _tabBarHeight = tabBarHeight;
    if (isChangeValue && self.superview && !CGRectEqualToRect(self.bounds, CGRectZero)) {
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

- (TYPagerViewLayout<UIView *> *)layout {
    return _pageView.layout;
}

#pragma mark - public

- (void)updateData {
    [_tabBar reloadData];
    [_pageView updateData];
}

- (void)reloadData {
    [_tabBar reloadData];
    [_pageView reloadData];
}

// scroll to index
- (void)scrollToViewAtIndex:(NSInteger)index animate:(BOOL)animate {
    [_pageView scrollToViewAtIndex:index animate:animate];
}

- (void)registerClass:(Class)Class forTabBarCellWithReuseIdentifier:(NSString *)identifier {
    _identifier = identifier;
    [_tabBar registerClass:Class forCellWithReuseIdentifier:identifier];
}
- (void)registerNib:(UINib *)nib forTabBarCellWithReuseIdentifier:(NSString *)identifier {
    _identifier = identifier;
    [_tabBar registerNib:nib forCellWithReuseIdentifier:identifier];
}

- (void)registerClass:(Class)Class forPagerCellWithReuseIdentifier:(NSString *)identifier {
    [_pageView registerClass:Class forViewWithReuseIdentifier:identifier];
}
- (void)registerNib:(UINib *)nib forPagerCellWithReuseIdentifier:(NSString *)identifier {
    [_pageView registerNib:nib forViewWithReuseIdentifier:identifier];
}
- (UIView *)dequeueReusablePagerCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index {
    return [_pageView dequeueReusableViewWithReuseIdentifier:identifier forIndex:index];
}

#pragma mark - TYTabPagerBarDataSource

- (NSInteger)numberOfItemsInPagerTabBar {
    return [_dataSource numberOfViewsInTabPagerView];
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:_identifier forIndex:index];
    cell.titleLabel.text = [_dataSource tabPagerView:self titleForIndex:index];
    if ([_delegate respondsToSelector:@selector(tabPagerView:willDisplayCell:atIndex:)]) {
        [_delegate tabPagerView:self willDisplayCell:cell atIndex:index];
    }
    return cell;
}

#pragma mark - TYTabPagerBarDelegate

- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
  //如果充满屏幕宽度
  if (self.isFullOrWidth) {
      CGFloat width = self.frame.size.width/3;
      NSLog(@"width== %f",width);
      return self.frame.size.width/3-2;
  }
    NSString *title = [_dataSource tabPagerView:self titleForIndex:index];
    
    return [pagerTabBar cellWidthForTitle:title];
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [_pageView scrollToViewAtIndex:index animate:YES];
    if ([_delegate respondsToSelector:@selector(tabPagerView:didSelectTabBarItemAtIndex:)]) {
        [_delegate tabPagerView:self didSelectTabBarItemAtIndex:index];
    }
}

#pragma mark - TYPagerViewDataSource

- (NSInteger)numberOfViewsInPagerView {
    return [_dataSource numberOfViewsInTabPagerView];
}

- (UIView *)pagerView:(TYPagerView *)pagerView viewForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    UIView *view = [_dataSource tabPagerView:self viewForIndex:index prefetching:prefetching];
    return view;
}

#pragma mark - TYPagerViewDelegate

- (void)pagerView:(TYPagerView *)pagerView transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

- (void)pagerView:(TYPagerView *)pagerView transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

- (void)pagerView:(TYPagerView *)pagerView willAppearView:(UIView *)view forIndex:(NSInteger)index {
    if ([_delegate respondsToSelector:@selector(tabPagerView:willAppearView:forIndex:)]) {
        [_delegate tabPagerView:self willAppearView:view forIndex:index];
    }
}

- (void)pagerView:(TYPagerView *)pagerView didDisappearView:(UIView *)view forIndex:(NSInteger)index {
    if ([_delegate respondsToSelector:@selector(tabPagerView:didDisappearView:forIndex:)]) {
        [_delegate tabPagerView:self didDisappearView:view forIndex:index];
    }
}

- (void)pagerViewWillBeginScrolling:(TYPagerView *)pageView animate:(BOOL)animate {
    if ([_delegate respondsToSelector:@selector(tabPagerViewWillBeginScrolling:animate:)]) {
        [_delegate tabPagerViewWillBeginScrolling:self animate:animate];
    }
}

- (void)pagerViewDidEndScrolling:(TYPagerView *)pageView animate:(BOOL)animate {
    if ([_delegate respondsToSelector:@selector(tabPagerViewDidEndScrolling:animate:)]) {
        [_delegate tabPagerViewDidEndScrolling:self animate:animate];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    _tabBar.frame = CGRectMake(0, self.frame.size.height-_tabBarHeight, CGRectGetWidth(self.frame), _tabBarHeight);
//    _pageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - _tabBarHeight);
    
    _tabBar.frame = self.titleFrame;
    _pageView.frame = self.pageViewFrame;
}

@end
