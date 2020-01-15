//
//  StudentGroupCell.h
//  utree
//
//  Created by 科研部 on 2019/11/4.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StuGMemberModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface StuGMemberCell : UITableViewCell
@property(strong,atomic)UIImageView *headView;
@property(strong,atomic)UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *selectedModeImg;

- (void)setStudentModel:(StuGMemberModel *)studentModel;
@end

NS_ASSUME_NONNULL_END
