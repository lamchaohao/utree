//
//  UITabBarController+Badge.h
//  utree
//
//  Created by 科研部 on 2020/1/15.
//  Copyright © 2020 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar(badge)

- (void)zb_showBadgeOnItemIndex:(int)index;  //显示小红点

- (void)zb_hideBadgeOnItemIndex:(int)index;//隐藏小红点

- (void)zb_removeBadgeOnItemIndex:(int)index;//移除小红点标记
@end

NS_ASSUME_NONNULL_END
