//
//  SelectStudentGroupVC.h
//  utree
//
//  Created by 科研部 on 2019/11/4.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseSecondVC.h"
NS_ASSUME_NONNULL_BEGIN
@protocol SelectStudentDelegate <NSObject>

-(void)onSelectedStuSuccess;


@end

@interface SelectStudentGroupVC : BaseSecondVC

- (instancetype)initWithGroupName:(NSString *)name;

- (instancetype)initWithEditGroupId:(NSString *)groupId;

@property(nonatomic,assign)id<SelectStudentDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
