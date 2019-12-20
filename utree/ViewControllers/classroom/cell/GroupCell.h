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
@property(strong,nonatomic)UIImageView *headView;
@property(strong,nonatomic)UILabel *groupNameLabel;
@property(strong,nonatomic)ZBPaddingLabel *memberCountLabel;
-(void)loadData:(GroupModel *)groupModel;
-(void)loadAddAction;
@end

NS_ASSUME_NONNULL_END
