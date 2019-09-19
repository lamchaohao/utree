//
//  AwardListVC.h
//  utree
//
//  Created by 科研部 on 2019/9/12.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AwardListVC : UIViewController

@property(atomic,strong)UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *awardItemArray;

/** 通讯录数据 <NSString,NSMutableArray>*/
@property (nonatomic, strong) NSMutableDictionary   *dataSource;
@end

NS_ASSUME_NONNULL_END
