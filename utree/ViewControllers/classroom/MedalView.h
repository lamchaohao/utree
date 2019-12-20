//
//  MedalView.h
//  utree
//
//  Created by 科研部 on 2019/10/11.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StuMedalModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MedalView : MyFrameLayout
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)MyFrameLayout *contentView;
@property(nonatomic,strong)UICollectionView *collectionView;
- (void)showAlert;
- (void)dismissAlert :(id)sender;
-(void)setMedalData:(NSArray<StuMedalModel *> *)mData;
@end

NS_ASSUME_NONNULL_END
