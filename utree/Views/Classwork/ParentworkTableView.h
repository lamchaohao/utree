//
//  ParentworkTableView.h
//  utree
//
//  Created by 科研部 on 2019/12/2.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagerView.h"
#import "ParentCheckModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ParentworkTableView : UIView <JXPagerViewListViewDelegate>

@property (nonatomic, weak) UINavigationController *naviController;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <ParentCheckModel *> *dataSource;
@property (nonatomic, assign) BOOL isNeedFooter;
@property (nonatomic, assign) BOOL isNeedHeader;
@property (nonatomic, assign) BOOL isHeaderRefreshed;   //默认为YES
@property (nonatomic, assign) BOOL isCheckData; //已查看 未查看

- (void)beginFirstRefresh;
@end

NS_ASSUME_NONNULL_END
