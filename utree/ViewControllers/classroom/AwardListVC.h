//
//  AwardListVC.h
//  utree
//
//  Created by 科研部 on 2019/9/12.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwardModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol AwardResponser <NSObject>

-(void)onAwardItemClick:(AwardModel *)model;

@end

@interface AwardListVC : UIView

@property(atomic,strong)UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *awardItemArray;


- (instancetype)initWithAwardData:(NSArray *)items;

@property (nonatomic, assign)id<AwardResponser> responser;

@end

NS_ASSUME_NONNULL_END
