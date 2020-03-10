//
//  HomeworkDetailView.h
//  utree
//
//  Created by 科研部 on 2019/12/3.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagerView.h"
#import "JXCategoryTitleView.h"
#import "WorkHeaderView.h"
#import "HomeworkModel.h"
#import "ParentCheckModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol HomeWorkDataDelegate <NSObject>

-(void)getParentListWithCheck:(NSNumber *)isCheck;

-(void)onekeyRemindAll;

-(void)onRemindAgainClick:(ParentCheckModel *)model;

@end


@interface HomeworkDetailView : UIView <JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate>

@property (nonatomic, strong)JXPagerView *pagerView;
@property (nonatomic, strong)WorkHeaderView *userHeaderView;
@property (nonatomic, strong, readonly)JXCategoryTitleView *categoryView;
@property (nonatomic, assign) BOOL isNeedFooter;
@property (nonatomic, assign) BOOL isNeedHeader;

-(JXPagerView *)preferredPagingView;

-(instancetype)initWithFrame:(CGRect)frame andTaskModel:(HomeworkModel *)task needList:(BOOL)need;

-(void)setDataSourceWithCheck:(BOOL) isCheck parents:(NSArray *)parents;

@property (nonatomic, assign)id<HomeWorkDataDelegate> workDelegate;

@end

NS_ASSUME_NONNULL_END
