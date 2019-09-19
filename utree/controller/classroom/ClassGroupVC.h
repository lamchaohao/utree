//
//  ClassGroupVC.h
//  utree
//
//  Created by 科研部 on 2019/8/7.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupMenuView.h"
NS_ASSUME_NONNULL_BEGIN

@interface ClassGroupVC : UIViewController
@property(nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *arrayWithGroups;
@property(nonatomic,strong)GroupMenuView *menuView;
-(void)onRightMenuClick;

@end

NS_ASSUME_NONNULL_END
