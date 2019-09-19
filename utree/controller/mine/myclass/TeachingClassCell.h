//
//  TeachingClassModel.h
//  utree
//
//  Created by 科研部 on 2019/9/9.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeachClassModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TeachingClassCell : UITableViewCell
@property (strong, nonatomic) UILabel *classNameLabel;
@property (strong, nonatomic) UIImageView *iconImg;

@property (strong, nonatomic) UILabel *firstSubject;

@property (strong, nonatomic) UILabel *secondSubject;

@property (strong, nonatomic) UILabel *thirdSubject;

-(void)setTeachClassModel:(TeachClassModel *)model;

@end

NS_ASSUME_NONNULL_END
