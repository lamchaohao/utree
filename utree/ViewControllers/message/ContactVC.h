//
//  ContactVC.h
//  utree
//
//  Created by 科研部 on 2019/10/15.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSecondVC.h"
#import "ParentCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface ContactVC : BaseSecondVC
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) NSMutableArray  *sectionTitleArray;
@property (nonatomic, strong) NSMutableArray  *sortParentList;

@end

NS_ASSUME_NONNULL_END
