//
//  UtChatFunctionItem.m
//  utree
//
//  Created by 科研部 on 2020/1/7.
//  Copyright © 2020 科研部. All rights reserved.
//

#import "UTChatFunctionItem.h"
#import "Masonry.h"

@interface UTChatFunctionItem   ()

@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation UTChatFunctionItem

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(self.mas_top).with.offset(4);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(self.button.mas_bottom).with.offset(3);
        make.centerX.equalTo(self.mas_centerX);
    }];
}

#pragma mark - 公有方法

- (void)fillViewWithTitle:(NSString *)strTitle imageName:(NSString *)strImageName
{
    self.titleLabel.text = strTitle;
    [self.button setBackgroundImage:[UIImage imageNamed:strImageName] forState:UIControlStateNormal];
    [self updateConstraintsIfNeeded];
}

#pragma mark - 私有方法

- (void)setup
{
    [self addSubview:self.button];
    [self addSubview:self.titleLabel];
    [self updateConstraintsIfNeeded];
}

- (void)buttonAction
{
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.button setHighlighted:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [self.button setHighlighted:NO];
}

#pragma mark - Getters方法
- (UIButton *)button
{
    if (!_button)
    {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13.0f];
        _titleLabel.textColor = [UIColor darkTextColor];
    }
    return _titleLabel;
}
@end

