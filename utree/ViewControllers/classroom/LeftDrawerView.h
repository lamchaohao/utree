//
//  LeftDrawerView.h
//  utree
//
//  Created by 科研部 on 2019/8/22.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"
NS_ASSUME_NONNULL_BEGIN

@interface LeftDrawerView : UINavigationController

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,weak)IIViewDeckController *viewDeckController;

@end

NS_ASSUME_NONNULL_END
