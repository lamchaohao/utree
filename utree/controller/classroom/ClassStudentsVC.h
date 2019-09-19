//
//  ClassPersonVCViewController.h
//  utree
//
//  Created by 科研部 on 2019/8/7.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClassStudentsVC : UIViewController
@property(atomic,strong)UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *studentList;
//@property (nonatomic, weak) id<PhoneBookViewControllerDelegate> delegate;

/** 通讯录数据 <NSString,NSMutableArray>*/
@property (nonatomic, strong) NSMutableDictionary   *dataSource;
/** 首字母数组 <NSString>*/
@property (nonatomic, strong) NSMutableArray  *sectionTitleArray;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,assign)BOOL isMultiMode;

-(void)showCollectionView:(BOOL )enable;
-(BOOL)isCollectionViewOnShow;
-(void)switchToMultiChoice;

@end

NS_ASSUME_NONNULL_END
