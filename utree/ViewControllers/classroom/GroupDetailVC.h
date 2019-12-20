//
//  GroupDetailVC.h
//  utree
//
//  Created by 科研部 on 2019/9/26.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupModel.h"
#import "ClassGroupVC.h"
NS_ASSUME_NONNULL_BEGIN

@protocol GroupViewControllerDelegate <NSObject>

-(void)pushToViewController:(UIViewController *)controller;

@end

@interface GroupDetailVC : UIViewController

-(instancetype)initWithGroup:(GroupModel *)group;

@property(nonatomic,assign)id<GroupViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
