//
//  EditGroupVC.h
//  utree
//
//  Created by 科研部 on 2019/9/26.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupModel.h"
#import "BaseSecondVC.h"
NS_ASSUME_NONNULL_BEGIN

@interface EditGroupVC :BaseSecondVC

-(instancetype)initWithGroup:(GroupModel *)group;

@end

NS_ASSUME_NONNULL_END