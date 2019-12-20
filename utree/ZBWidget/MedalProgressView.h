//
//  MedalProgressView.h
//  utree
//
//  Created by 科研部 on 2019/10/11.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MedalProgressView : MyRelativeLayout
@property(nonatomic,strong)UILabel *bottomLabel;
@property(nonatomic,assign)CGFloat progress;
@property(nonatomic,strong)UIView *progressView;
@property(nonatomic,strong)UIView *totalProgressView;

- (instancetype)initWithFrame:(CGRect)frame andProgress:(CGFloat)progress;

- (void)setProgressForView:(CGFloat)progress;

@end

NS_ASSUME_NONNULL_END
