//
//  UITextView+ZBPlaceHolder.h
//  utree
//
//  Created by 科研部 on 2019/9/27.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (ZBPlaceHolder)
/**
 *  UITextView+placeholder
 */
@property (nonatomic, copy) NSString *zb_placeHolder;
/**
 *  IQKeyboardManager等第三方框架会读取placeholder属性并创建UIToolbar展示
 */
@property (nonatomic, copy) NSString *placeholder;
/**
 *  placeHolder颜色
 */
@property (nonatomic, strong) UIColor *zb_placeHolderColor;

@end
