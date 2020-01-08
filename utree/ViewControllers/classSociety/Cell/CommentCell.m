//
//  CommentCell.m
//  utree
//
//  Created by 科研部 on 2019/11/21.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withViewModel:(CommentCellViewModel *)viewModel
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.viewModel = viewModel;
        [self createCustomUI];
        [self setCellViewModel:viewModel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

//    [self.imageView setFrame:CGRectMake(8, 8,48, 48)];
//
//    self.imageView.contentMode = UIViewContentModeScaleAspectFit;//不会变形
    
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
    MyRelativeLayout *contentLayout = [MyRelativeLayout new];
    contentLayout.frame = self.viewModel.commentBodyFrame;
    contentLayout.myCenterX=0;
    
    self.headView = [[UIImageView alloc]initWithFrame:self.viewModel.headViewFrame];
    [self.headView setImage:[UIImage imageNamed:@"default_head"]];
    self.headView.myTop = self.headView.myLeft = 0;
    self.headView.contentMode = UIViewContentModeScaleAspectFit;
    CGSize itemSize = CGSizeMake(48, 48);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [self.headView.image drawInRect:imageRect];
    self.headView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.headView.layer.cornerRadius=24 ;//裁成圆角
    self.headView.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    
    self.writerLabel = [UILabel new];
    self.writerLabel.frame = self.viewModel.writerLabelFrame;
    self.writerLabel.text = @"null";
    [self.writerLabel setFont:[UIFont systemFontOfSize:14]];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.frame=self.viewModel.timeLabelFrame;
    [self.timeLabel setText:@"1970-01-01 00:00"];
    [self.timeLabel setFont:[CFTool font:13]];
    [self.timeLabel setTextColor:[UIColor myColorWithHexString:@"#B3B3B3"]];
    
    
    self.commentLabel = [UILabel new];
    self.commentLabel.frame = self.viewModel.commentDetailFrame;
    self.commentLabel.text=@"...";
    [self.commentLabel setFont:[UIFont systemFontOfSize:15]];
    [self.commentLabel setTextColor:[UIColor myColorWithHexString:@"#666666"]];

    self.writerLabel.leftPos.equalTo(self.headView.rightPos).offset(12);
    self.writerLabel.topPos.equalTo(self.headView.topPos).offset(4);
    
    self.commentLabel.leftPos.equalTo(self.headView.rightPos).offset(12);
    self.commentLabel.topPos.equalTo(self.writerLabel.bottomPos).offset(8);
    self.commentLabel.rightPos.equalTo(contentLayout.rightPos).offset(4);

    self.timeLabel.topPos.equalTo(self.headView.topPos);
    self.timeLabel.rightPos.equalTo(contentLayout.rightPos).offset(4);
    
    [contentLayout addSubview:self.headView];
    [contentLayout addSubview:self.writerLabel];
    [contentLayout addSubview:self.commentLabel];
    [contentLayout addSubview:self.timeLabel];
    
    [self.contentView addSubview:contentLayout];
    
}

-(void)setCellViewModel:(CommentCellViewModel *)viewModel
{
    self.viewModel = viewModel;
    
    CommentModel *commentModel = viewModel.commentModel;
    
    [self.headView sd_setImageWithURL:[NSURL URLWithString:commentModel.facePath] placeholderImage:[UIImage imageNamed:@"default_head"]];
    self.writerLabel.text=commentModel.name;
    [self.timeLabel setText:commentModel.createTime];
    [self.writerLabel sizeToFit];
    [self.timeLabel sizeToFit];
    

    [self.commentLabel setText:commentModel.comment];
    CGSize labelSize = {0, 0};
    labelSize = [viewModel.commentModel.comment boundingRectWithSize:CGSizeMake(CGRectGetWidth(viewModel.commentDetailFrame), 5000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size;
   
    self.commentLabel.lineBreakMode = NSLineBreakByWordWrapping;//换行模式，与上面的计算保持一致。

    self.commentLabel.frame = CGRectMake(_commentLabel.frame.origin.x, _commentLabel.frame.origin.y, _commentLabel.frame.size.width, labelSize.height);//保持原来Label的位置和宽度，只是改变高度
//    [self.commentLabel sizeToFit];
    NSLog(@"cellHeight=%f,labelHeight=%f",viewModel.cellHeight,labelSize.height);
    self.commentLabel.numberOfLines = 0;//表示label可以多行显示
    [self.commentLabel sizeToFit];
}
@end
