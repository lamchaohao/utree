//
//  AwardVC.h
//  utree
//
//  Created by 科研部 on 2019/9/12.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYTabPagerController.h"
#import "BaseViewController.h"
#import "AwardModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol AwardVCDelegate <NSObject>

-(void)pushToViewController:(UIViewController *)vc;

-(void)onAwardSuccess:(AwardModel *)model;

@end

@interface AwardVC : BaseViewController
-(instancetype)initByPassStuList:(NSArray *)stuList groupId:(NSString *)groupId;

@property(nonatomic,assign)id<AwardVCDelegate> vcDelegate;

@end

NS_ASSUME_NONNULL_END
