//
//  ParentCell.m
//  utree
//
//  Created by 科研部 on 2019/10/22.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ParentCell.h"

@implementation ParentCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
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
}



-(void)createView
{
    [self.imageView setImage:[UIImage imageNamed:@"head_boy"]];
    self.imageView.layer.cornerRadius=24 ;//裁成圆角
    self.imageView.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    self.imageView.layer.borderWidth = 1.5f;//边框宽度
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;//边框颜色
    self.imageView.myCenterY=0;
    
}

-(void)setDataToView:(UTParent *)parent
{
    self.textLabel.text=parent.parentName;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:parent.picPath] placeholderImage:[UIImage imageNamed:@"default_head"]];
    self.accessoryType=UITableViewCellAccessoryNone;
    self.detailTextLabel.text=[NSString stringWithFormat:@"%@家长",parent.studentName];

    self.imageView.layer.cornerRadius=24 ;//裁成圆角
    self.imageView.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    self.imageView.layer.shadowColor=[UIColor myColorWithHexString:@"#EAEAEA"].CGColor;
    self.imageView.layer.shadowRadius=1.5f;
    
    CGSize itemSize = CGSizeMake(48, 48);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [self.imageView.image drawInRect:imageRect];
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    
    
}


@end
