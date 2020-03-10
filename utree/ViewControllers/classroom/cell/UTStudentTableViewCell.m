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

#pragma mark 保持imageview不变形
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect imageFrame = CGRectMake(10, 10,48, 48);
    [self.imageView setFrame:imageFrame];

    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    CGRect oldTextLabelFrame =self.textLabel.frame;
    CGRect textLabelFrame = CGRectMake(CGRectGetMaxX(imageFrame)+15, oldTextLabelFrame.origin.y,oldTextLabelFrame.size.width, oldTextLabelFrame.size.height);
    [self.textLabel setFrame:textLabelFrame];
    
    CGRect oldDetailLabelFrame =self.detailTextLabel.frame;
    CGRect detailLabelFrame = CGRectMake(CGRectGetMaxX(imageFrame)+15, oldDetailLabelFrame.origin.y,oldDetailLabelFrame.size.width, oldDetailLabelFrame.size.height);
    [self.detailTextLabel setFrame:detailLabelFrame];
    
    self.scoreLabel.frame=CGRectMake(detailLabelFrame.origin.x,43,35.5,13.5);
}

-(void)createCustomUI
{
//    CGRect detailFrame = self.detailTextLabel.frame;
//    [self.detailTextLabel removeFromSuperview];
    
    UIView *rectView = [[UIView alloc] init];
    rectView.frame = CGRectMake(74,43,35.3,13.3);
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
    _scoreLabel.frame=CGRectMake(70,43,35.5,13.5);
    _scoreLabel.myCenterX=0;
    _scoreLabel.font = [UIFont systemFontOfSize:10];
    _scoreLabel.textColor=[UIColor colorWithRed:248/255.0 green:162/255.0 blue:26/255.0 alpha:1.0];
    _scoreLabel.layer.cornerRadius = 7;
    _scoreLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:rectView];
    [self.contentView addSubview:_scoreLabel];
    
    self.imageView.layer.cornerRadius=24 ;//裁成圆角
    self.imageView.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    self.imageView.layer.borderWidth = 1.5f;//边框宽度
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;//边框颜色
    self.imageView.myCenterY=0;
    self.imageView.contentMode=UIViewContentModeScaleAspectFill;
}

-(void)setDataToView:(UTStudent *)student
{
    self.textLabel.text=student.studentName;
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld",student.dropRecord];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:student.fileDo.path] placeholderImage:[UIImage imageNamed:student.gender.boolValue?@"head_boy":@"head_girl"]];
    if (student.selectMode==1) {
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_selected_green"]];
        
    }else if(student.selectMode==2){
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_unselected_gray_small"]];
    }else{
        self.accessoryType=UITableViewCellAccessoryNone;
    }
    
    CGSize itemSize = CGSizeMake(48, 48);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [self.imageView.image drawInRect:imageRect];
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.imageView.layer.cornerRadius=24 ;//裁成圆角
    self.imageView.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    self.imageView.myCenterY=0;
    self.imageView.clipsToBounds=YES;
    self.imageView.contentMode=UIViewContentModeScaleAspectFill;
    
}

@end
