//
//  ParentWorkCell.m
//  utree
//
//  Created by 科研部 on 2019/12/2.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ParentWorkCell.h"
#import "ParentCheckModel.h"

@implementation ParentWorkCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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
    
}



-(void)createView
{
    [self.imageView setImage:[UIImage imageNamed:@"head_boy"]];
    self.imageView.layer.cornerRadius=24 ;//裁成圆角
    self.imageView.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    self.imageView.layer.borderWidth = 1.5f;//边框宽度
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;//边框颜色
    self.imageView.myCenterY=0;
    
    self.remindBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    self.frame = CGRectMake(0, 0, 70, 40);
    [self.remindBtn setTitle:@"再次提醒" forState:UIControlStateNormal];
    self.remindBtn.layer.cornerRadius = 6;
    self.remindBtn.clipsToBounds = YES;
    [self.remindBtn setTitleColor:[UIColor_ColorChange colorWithHexString:PrimaryColor] forState:UIControlStateNormal];
    [self.remindBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    self.remindBtn.layer.borderColor = [UIColor_ColorChange colorWithHexString:PrimaryColor].CGColor;
    self.remindBtn.layer.borderWidth = 1.0;
    [self.remindBtn addTarget:self action:@selector(onRemindBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)onRemindBtnClick:(id)send
{
    self.bgButtonClicked(self.parentModel);
}

-(void)setDataToView:(ParentCheckModel *)parent isCheck:(BOOL)isCheck
{
//    [self createView];
    self.parentModel = parent;
    self.textLabel.text=parent.studentName;
    self.detailTextLabel.textColor = [UIColor myColorWithHexString:@"#B3B3B3"];
    if (parent.parentList) {
        NSString *parentName = @"";
        for (UTParent *parentMo in parent.parentList) {
            parentName = [parentName stringByAppendingFormat:@" %@:%@",parentMo.relation,parentMo.parentName];
        }
        self.detailTextLabel.text=parentName;
    }
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:parent.studentPic] placeholderImage:[UIImage imageNamed:@"default_head"]];
    
    if (isCheck) {
        self.accessoryType=UITableViewCellAccessoryNone;
    }else{
        if(parent.remindTime.intValue==1){
            self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            self.accessoryView = self.remindBtn;
        }else if(parent.remindTime.intValue==2){
            self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            self.remindBtn.layer.borderColor = [UIColor_ColorChange colorWithHexString:@"#B3B3B3"].CGColor;
            [self.remindBtn setTitleColor:[UIColor_ColorChange colorWithHexString:@"#B3B3B3"] forState:UIControlStateNormal];
             [self.remindBtn setTitle:@"已提醒" forState:UIControlStateNormal];
            self.remindBtn.enabled=NO;
            self.accessoryView = self.remindBtn;
        }
    }
    
    CGSize itemSize = CGSizeMake(48, 48);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [self.imageView.image drawInRect:imageRect];
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    self.imageView.layer.cornerRadius=24 ;//裁成圆角
    self.imageView.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    self.imageView.layer.borderWidth = 1.5f;//边框宽度
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;//边框颜色
    self.imageView.layer.shadowColor=[UIColor myColorWithHexString:@"#EAEAEA"].CGColor;
    self.imageView.layer.shadowRadius=1.5f;
    
}

@end
