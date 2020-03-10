//
//  NoticeDetailView.h
//  utree
//
//  Created by 科研部 on 2019/12/2.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagerView.h"
#import "JXCategoryTitleView.h"
#import "WorkHeaderView.h"
#import "ParentCheckModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NoticeDataDelegate <NSObject>

-(void)getParentListWithCheck:(NSNumber *)isCheck;

-(void)onekeyRemindAll;

-(void)onRemindAgainWithParent:(ParentCheckModel *)model;
@end

@interface NoticeDetailView : UIView <JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate>

@property (nonatomic, strong)JXPagerView *pagerView;
@property (nonatomic, strong) WorkHeaderView *userHeaderView;
@property (nonatomic, strong, readonly) JXCategoryTitleView *categoryView;
@property (nonatomic, assign) BOOL isNeedFooter;
@property (nonatomic, assign) BOOL isNeedHeader;
- (JXPagerView *)preferredPagingView;

- (instancetype)initWithFrame:(CGRect)frame andNoticeModel:(NoticeModel *)notice needList:(BOOL)need;

-(void)setDataSourceWithCheck:(BOOL) isCheck parents:(NSArray *)parents;

@property (nonatomic, assign)id<NoticeDataDelegate> dataDelegate;

- (void)reloadTableViewWithParents:(NSArray *)parents;
@end

NS_ASSUME_NONNULL_END
