//
//  ChatContactCell.m
//  utree
//
//  Created by 科研部 on 2019/12/11.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ChatContactCell.h"
#import "UTParent.h"
@implementation ChatContactCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
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
    self.timeLabel.frame=CGRectMake(0, 5, self.frame.size.width-15, 30);
}



-(void)createView
{
    [self.imageView setImage:[UIImage imageNamed:@"head_boy"]];
    self.imageView.layer.cornerRadius=24 ;//裁成圆角
    self.imageView.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    self.imageView.myCenterY=0;
    
    self.timeLabel = [UILabel new];
    self.timeLabel.frame=CGRectMake(0, 5, self.frame.size.width-15, 30);
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.timeLabel setFont:[CFTool font:12]];
    [self.timeLabel setTextColor:[UIColor myColorWithHexString:@"#B3B3B3"]];

    [self.contentView addSubview:self.timeLabel];
    
}

-(void)setDataToView:(RecentContact *)contact
{
    self.textLabel.text=contact.parent.parentName;
    switch (contact.lastMessage.type) {
        case UTMessageTypeText:
            self.detailTextLabel.text=contact.lastMessage.contentStr;
            break;
        case UTMessageTypeVoice:
            self.detailTextLabel.text =@"[语音]";
            break;
        case UTMessageTypePicture:
            self.detailTextLabel.text =@"[图片]";
            break;
        default:
            self.detailTextLabel.text =@"[不支持消息类型]";
            break;
    }
    
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:contact.parent.picPath]];

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

    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 35)];
    
    if (contact.unreadCount>0) {
        JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:rightView alignment:JSBadgeViewAlignmentBottomCenter];
        badgeView.badgeText = [NSString stringWithFormat:@"%d",contact.unreadCount];
    }
    
    [self.timeLabel setText:contact.lastMessage.timeForShow];
    self.accessoryView = rightView;
    
    
}

@end
