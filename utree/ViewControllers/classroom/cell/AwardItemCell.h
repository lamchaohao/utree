//
//  AwardItemCell.h
//  utree
//
//  Created by 科研部 on 2019/9/12.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwardModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AwardItemCell : UICollectionViewCell

-(void)setAwardDataToView:(AwardModel *)model;

@end

NS_ASSUME_NONNULL_END
