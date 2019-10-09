//
//  UTStudentTableViewCell.m
//  utree
//
//  Created by 科研部 on 2019/9/20.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTStudentTableViewCell.h"

@implementation UTStudentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCustomUI];
    }
    return self;
}

-(void)createCustomUI
{
//    CGRect detailFrame = self.detailTextLabel.frame;
//    [self.detailTextLabel removeFromSuperview];
    
    UIView *rectView = [[UIView alloc] init];
    rectView.frame = CGRectMake(90,43,35.3,13.3);
    rectView.backgroundColor = [UIColor whiteColor];
    //    rectView.layer.cornerRadius = 7;
    rectView.myCenterX=0;
    rectView.myTop=(-6);
    CALayer *layer=[rectView layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框圆角的弧度
    [layer setCornerRadius:7];
    //设置边框线的宽
    [layer setBorderWidth:1];
    //设置边框线的颜色
    UIColor *color = [UIColor myColorWithHexString:@"#CCCCCC"];
    [layer setBorderColor:color.CGColor];
    
    
    _scoreLabel = [ZBPaddingLabel new];
    [_scoreLabel setText:@"34399"];
    _scoreLabel.frame=CGRectMake(90,43,35.3,13.3);
    _scoreLabel.myCenterX=0;
    _scoreLabel.font = [UIFont systemFontOfSize:10];
    _scoreLabel.textColor=[UIColor colorWithRed:248/255.0 green:162/255.0 blue:26/255.0 alpha:1.0];
    _scoreLabel.layer.cornerRadius = 7;
    _scoreLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:rectView];
    [self.contentView addSubview:_scoreLabel];
    
    self.imageView.frame = CGRectMake(0, 0, 54, 54);
    self.imageView.layer.cornerRadius=33 ;//裁成圆角
    self.imageView.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    self.imageView.layer.borderWidth = 1.5f;//边框宽度
    self.imageView.layer.borderColor = [UIColor myColorWithHexString:PrimaryColor].CGColor;//边框颜色
    self.imageView.myCenterY=0;
}

@end
