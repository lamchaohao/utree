//
//  ParentWorkCell.h
//  utree
//
//  Created by 科研部 on 2019/12/2.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentCheckModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ParentWorkCell : UITableViewCell

@property (nonatomic, copy) void(^bgButtonClicked)(ParentCheckModel *model);

@property(nonatomic, strong)UIButton *remindBtn;
@property(nonatomic, strong)ParentCheckModel *parentModel;
-(void)setDataToView:(ParentCheckModel *)parent isCheck:(BOOL)isCheck;

@end

NS_ASSUME_NONNULL_END
