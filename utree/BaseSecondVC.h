//
//  BaseSecondVC.h
//  utree
//
//  Created by 科研部 on 2019/9/6.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaseSecondVC : BaseViewController

-(void)pushIntoWithoutNavChange:(UIViewController *)viewController;

@property(nonatomic,assign)BOOL showNavigationBarImageWhenDisappear;

@property(nonatomic,assign)BOOL diasblePopGesture;//default is YES;

@end

NS_ASSUME_NONNULL_END
