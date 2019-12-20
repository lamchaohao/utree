//
//  BaseWorkView.h
//  utree
//
//  Created by 科研部 on 2019/11/27.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UTViewDelegate <NSObject>

-(void)pushToViewController:(UIViewController *)vc;

@end

@interface BaseWorkView : UIView


@property(nonatomic,assign)id<UTViewDelegate> utViewDelegate;

@end

NS_ASSUME_NONNULL_END
