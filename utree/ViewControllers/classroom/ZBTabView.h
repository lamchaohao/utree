//
//  TabView.h
//  utree
//
//  Created by 科研部 on 2019/8/7.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//定义block，用来传递点击的第几个按钮
typedef void (^PassValueBlock)(NSInteger index);

@interface ZBTabView : UIView

//定义一下block
@property(strong,nonatomic)PassValueBlock returnBlock;


//初始化按钮组，传入frame和名称
-(id)initWithFrame:(CGRect)frame withTitleArray:(NSArray *)array;

-(void)setTitleArray:(NSArray *)title;
//block传递值的方法
-(void)setReturnBlock:(PassValueBlock)returnBlock;

@end

NS_ASSUME_NONNULL_END
