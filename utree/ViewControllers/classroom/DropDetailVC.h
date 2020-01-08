//
//  DropDetailVC.h
//  utree
//
//  Created by 科研部 on 2019/8/9.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "BaseSecondVC.h"
#import "DropLevelProgressView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DropDetailVC : BaseSecondVC
- (instancetype)initWithStudentId:(NSString *)stuId;
@property(nonatomic,strong)DropLevelProgressView *uiProgress;

@end

NS_ASSUME_NONNULL_END
