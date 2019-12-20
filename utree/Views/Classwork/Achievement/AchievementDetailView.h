//
//  AchievementDetailView.h
//  utree
//
//  Created by 科研部 on 2019/12/10.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AchievementModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AchievementDetailView : UIView

- (instancetype)initWithFrame:(CGRect)frame andAchievementModel:(AchievementModel *)model;

-(void)addScoreListToView:(NSArray *)scoreList;

@end

NS_ASSUME_NONNULL_END
