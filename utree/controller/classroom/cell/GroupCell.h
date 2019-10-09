//
//  GroupCell.h
//  utree
//
//  Created by 科研部 on 2019/8/22.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBPaddingLabel.h"
#import "DCAvatar.h"
#import "GroupModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GroupCell : UICollectionViewCell
@property(strong,atomic)UIImageView *headView;
@property(strong,atomic)UILabel *groupNameLabel;
@property(strong,atomic)ZBPaddingLabel *memberCountLabel;

-(void)loadData:(GroupModel *)groupModel;

@end

NS_ASSUME_NONNULL_END
