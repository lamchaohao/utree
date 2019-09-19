//
//  MenuExpandView.h
//  utree
//
//  Created by 科研部 on 2019/9/19.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MenuExpandView : UIView
@property (strong, nonatomic)UIButton *mainMenuBtn;
@property (strong, nonatomic)UIButton *attendanceBtn;
@property (strong, nonatomic)UIButton *sortBtn;
@property (strong, nonatomic)UIButton *showListBtn;
@property (strong, nonatomic)UIButton *randomBtn;

- (instancetype)initWithFrame:(CGRect)frame andEx:(CGPoint)poi;
@end

NS_ASSUME_NONNULL_END
