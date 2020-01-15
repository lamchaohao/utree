//
//  UITabBarController+Badge.m
//  utree
//
//  Created by 科研部 on 2020/1/15.
//  Copyright © 2020 科研部. All rights reserved.
//

#import "UITabBarController+Badge.h"

#define TabbarItemNums 5.0//tabbar的数量,根据情况设置

@implementation UITabBar (badge)

//显示小红点

- (void)zb_showBadgeOnItemIndex:(int)index{
    
    [self zb_removeBadgeOnItemIndex:index];
    //新建小红点
     
    UIView *badgeView = [[UIView alloc]init];
     
    badgeView.tag = 800 + index;
     
    badgeView.layer.cornerRadius = 5;
     
    badgeView.backgroundColor = [UIColor redColor];
     
    CGRect tabFrame = self.frame;
    //确定小红点的位置
    float percentX = (index +0.6) / TabbarItemNums;
     
    CGFloat x = ceilf(percentX * tabFrame.size.width);
     
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
     
    badgeView.frame = CGRectMake(x, y, 10, 10);
     
    [self addSubview:badgeView];
     
}
     
- (void)zb_hideBadgeOnItemIndex:(int)index{
     //移除小红点
     
    [self zb_removeBadgeOnItemIndex:index];

}

//移除小红点

- (void)zb_removeBadgeOnItemIndex:(int)index{
    //按照tag值进行移除
    for(UIView* subView in self.subviews) {
        if(subView.tag==800+index) {
            [subView removeFromSuperview];
        }
    }
}



@end
