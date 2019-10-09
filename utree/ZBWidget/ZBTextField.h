//
//  ZBTextField.h
//  utree
//
//  Created by 科研部 on 2019/7/26.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZBTextField : UITextField
@property(nonatomic,assign)CGFloat leftMargin;
@property(nonatomic,assign)CGFloat textMargin;

-(instancetype)initWitheLeftMargin:(CGFloat)x andTextMargin:(CGFloat)textMargin;

@end

NS_ASSUME_NONNULL_END
