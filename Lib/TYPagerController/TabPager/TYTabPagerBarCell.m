//
//  TYTabTitleViewCell.m
//  TYPagerControllerDemo
//
//  Created by tany on 16/5/4.
//  Copyright © 2016年 tanyang. All rights reserved.
//

#import "TYTabPagerBarCell.h"

@interface TYTabPagerBarCell ()
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak)MyRelativeLayout *relativeLayout;
@end

@implementation TYTabPagerBarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addTabTitleLabel];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self addTabTitleLabel];
    }
    return self;
}

- (void)addTabTitleLabel
{
    MyRelativeLayout *relativeLayout = [MyRelativeLayout new];
    self.relativeLayout=relativeLayout;
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor darkTextColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [relativeLayout addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    _badgeView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 6, 6)];
    _badgeView.backgroundColor = [UIColor redColor];
    _badgeView.layer.cornerRadius=3;
    _badgeView.centerXPos.equalTo(titleLabel.centerXPos).offset(30);
    _badgeView.myTop=10;
    [relativeLayout addSubview:_badgeView];
    [self.contentView addSubview:relativeLayout];
}

- (void)setShowBadgeView:(BOOL)showBadgeView
{
    if (showBadgeView) {
        [self.relativeLayout addSubview:_badgeView];
    }else{
        [_badgeView removeFromSuperview];
    }
}

+ (NSString *)cellIdentifier {
    return @"TYTabPagerBarCell";
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame= self.contentView.bounds;
    self.relativeLayout.frame = self.contentView.bounds;
}
@end
