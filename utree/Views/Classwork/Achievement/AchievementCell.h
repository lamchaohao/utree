//
//  AchievementCellTableViewCell.h
//  utree
//
//  Created by 科研部 on 2019/12/9.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AchievementModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AchievementCell : UITableViewCell

@property(nonatomic,strong)UIImageView *headView;
@property(nonatomic,strong)UIImageView *unreadView;
@property(nonatomic,strong)UILabel *posterLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *subjectAndTitleLabel;

-(void)setDataToView:(AchievementModel *)model;
@end

NS_ASSUME_NONNULL_END
