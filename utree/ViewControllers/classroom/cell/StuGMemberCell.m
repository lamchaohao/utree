//
//  StudentGroupCell.m
//  utree
//
//  Created by 科研部 on 2019/11/4.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "StuGMemberCell.h"

@implementation StuGMemberCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCustomUI];
    }
    return self;
}

- (void)layoutSubviews
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

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createCustomUI];
    }
    return self;
}

-(void)createCustomUI
{
    [self.imageView setImage:[UIImage imageNamed:@"head_boy"]];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
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
    
}

-(void)setStudentModel:(StuGMemberModel *)student
{
    self.textLabel.text=student.studentName;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:student.fileDo.path] placeholderImage:[UIImage imageNamed:student.gender.boolValue?@"head_boy":@"head_girl"]];
    self.imageView.contentMode=UIViewContentModeScaleAspectFill;
    self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

    if (student.selectMode==1) {
        self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_selected_green"]];
        
    }else if(student.selectMode==2){
        self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_unselected_gray_small"]];
    }else{
        self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_selected_disable"]];
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

}
@end
