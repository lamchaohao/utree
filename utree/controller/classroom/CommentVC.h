//
//  CommentVC.h
//  utree
//
//  Created by 科研部 on 2019/9/25.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSecondVC.h"
#import "UTStudent.h"
NS_ASSUME_NONNULL_BEGIN

@interface CommentVC : BaseSecondVC

-(instancetype)initWithStuName:(UTStudent *)student;

@end

NS_ASSUME_NONNULL_END