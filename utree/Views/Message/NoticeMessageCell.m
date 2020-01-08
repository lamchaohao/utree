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
    
    self.timeLabel.frame=CGRectMake(0, 5, self.frame.size.width-15, 30);
    
}



-(void)createView
{
    
    self.timeLabel = [UILabel new];
    self.timeLabel.frame=CGRectMake(0, 5, self.frame.size.width-15, 30);
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.timeLabel setFont:[CFTool font:12]];
    [self.timeLabel setTextColor:[UIColor myColorWithHexString:@"#B3B3B3"]];

    [self.contentView addSubview:self.timeLabel];
    
}

-(void)setNoticeMsgToView:(NoticeMessageModel *)message
{
    self.textLabel.text=message.topic;
    self.textLabel.font = [UIFont systemFontOfSize:15];
    self.textLabel.textColor = [UIColor myColorWithHexString:@"#666666"];
    
    
    if (!message.read.boolValue) {
        UIView *unreadDotView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        unreadDotView.backgroundColor = [UIColor redColor];
        unreadDotView.layer.cornerRadius=5;
        self.accessoryView = unreadDotView;
    }else{
        self.accessoryView = nil;
    }
    
    [self.timeLabel setText:message.createTime];
    
    
    
}

@end
