//
//  MyClassCell.h
//  utree
//
//  Created by 科研部 on 2019/9/9.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UTClassModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MyClassCell : UITableViewCell
@property (strong, nonatomic) UILabel *classNameLabel;
@property (strong, nonatomic) UIImageView *iconImg;

- (void)setClassModel:(UTClassModel *)classModel;
@end

NS_ASSUME_NONNULL_END
