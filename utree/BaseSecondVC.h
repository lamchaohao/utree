//
//  BaseSecondVC.h
//  utree
//
//  Created by 科研部 on 2019/9/6.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseSecondVC : ViewController

-(void)pushIntoWithoutNavChange:(UIViewController *)viewController;
@property(nonatomic,assign)BOOL showNavWhenDisappear;

@end

NS_ASSUME_NONNULL_END
