//
//  NoticeMessageCell.m
//  utree
//
//  Created by 科研部 on 2019/12/24.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "NoticeMessageCell.h"

@implementation NoticeMessageCell

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
    
//    self.timeLabel.frame=CGRectMake(0, 5, self.frame.size.width-15, 30);
    
    CGRect textFrame = self.textLabel.frame;
    self.unreadDotView.frame = CGRectMake(textFrame.size.width, 5, 8, 8);
}



-(void)createView
{
    
    self.timeLabel = [UILabel new];
    self.timeLabel.frame=CGRectMake(0, 5, 50, 30);
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.timeLabel setFont:[CFTool font:12]];
    [self.timeLabel setTextColor:[UIColor myColorWithHexString:@"#B3B3B3"]];
    
    self.unreadDotView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 8)];
    self.unreadDotView.backgroundColor = [UIColor redColor];
    self.unreadDotView.layer.cornerRadius=4;
    
    [self.textLabel addSubview:self.unreadDotView];
    [self.contentView addSubview:self.timeLabel];
    
}

-(void)setNoticeMsgToView:(NoticeMessageModel *)message
{
    self.textLabel.text=message.topic;
    self.textLabel.font = [UIFont systemFontOfSize:15];
    self.textLabel.textColor = [UIColor myColorWithHexString:@"#666666"];
    self.textLabel.numberOfLines = 0;//表示label可以多行显示
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;//换行模式，与上面的计算保持一致。
    
    if (!message.read.boolValue) {
        [self.textLabel addSubview:_unreadDotView];
    }else{
        [_unreadDotView removeFromSuperview];
    }
    
    [self.timeLabel setText:message.createTime];
    [self.timeLabel sizeToFit];
    self.accessoryView = self.timeLabel;
    
    
}

@end
