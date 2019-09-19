//
//  ListStudentVC.h
//  utree
//
//  Created by 科研部 on 2019/8/20.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ListStudentVC : ViewController
@property (nonatomic, strong) NSArray *arrayWithTableV;
//@property (nonatomic, weak) id<PhoneBookViewControllerDelegate> delegate;

/** 通讯录数据 <NSString,NSMutableArray>*/
@property (nonatomic, strong) NSMutableDictionary   *dataSource;
/** 首字母数组 <NSString>*/
@property (nonatomic, strong) NSMutableArray  *sectionTitleArray;

@property(nonatomic,strong)UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
