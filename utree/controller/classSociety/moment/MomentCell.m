//
//  MomentCell.m
//  utree
//
//  Created by 科研部 on 2019/8/28.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "MomentCell.h"

@implementation MomentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

// 1. 初始化子视图
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
       
        _headView = [[UIImageView alloc]initWithFrame:CGRectMake(18, 18, 48, 48)];
        _posterLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 23, 254, 20)];
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 45, 260, 18)];
        [_timeLabel setTextColor:[UIColor_ColorChange colorWithHexString:SecondTextColor]];
        [_timeLabel setFont:[UIFont systemFontOfSize:13]];
        [_posterLabel setFont:[UIFont systemFontOfSize:17]];
        
        MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
        contentLayout.frame = CGRectMake(16, 64, ScreenWidth-32, 190);
        _detailLabel = [UILabel new];
        

        _detailLabel.myWidth =ScreenWidth-32;
        _detailLabel.myRight = 16;
        _detailLabel.myLeft = 0;
        _detailLabel.myTop=8;
        [_detailLabel setTextColor:[UIColor_ColorChange colorWithHexString:@"4D4D4D"]];
        [_detailLabel setNumberOfLines:0];
        [_detailLabel setFont:[UIFont systemFontOfSize:15]];
        
        // 图片
        // 创建一个流水布局photosView(默认为流水布局)
        PYPhotosView *flowPhotosView = [PYPhotosView photosView];
        // 设置分页指示类型
        //    flowPhotosView.pageType = PYPhotosViewPageTypeLabel;
        //    flowPhotosView.py_centerX = self.py_centerX;
        //    flowPhotosView.py_y = 20 + 64;
        flowPhotosView.photoWidth = circleCellPhotosWH;
        flowPhotosView.photoHeight = circleCellPhotosWH;
        flowPhotosView.photoMargin = circleCellPhotosMargin;
//        [self addSubview:flowPhotosView];
        _photosView = flowPhotosView;
        _photosView.myTop=4;
        
        MyLinearLayout *toolbarLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
        toolbarLayout.frame = CGRectMake(0, 8, ScreenWidth-32, circleCellToolBarHeight);
        toolbarLayout.myTop=5;
        toolbarLayout.myBottom=5;
//        toolbarLayout.gravity = MyGravity_Vert_Center|MyGravity_Vert_Between;
        
        //评论按钮
        UIButton *commentBtn= [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 23)];
        [commentBtn setImage:[UIImage imageNamed:@"ic_comment"] forState:UIControlStateNormal];
        commentBtn.myCenterY=0;
        commentBtn.myTop=2;
        commentBtn.myLeft = ScreenWidth*0.2 - 16;
        
        //评论数
        UILabel *commentCountLabel = [UILabel new];
        commentCountLabel.myRight=15;
        commentCountLabel.myLeft = 2;
        commentCountLabel.myTop=2;
        commentCountLabel.myCenterY=0;
        
        [commentCountLabel setText:@"45"];
        [commentCountLabel setFont:[UIFont systemFontOfSize:14]];
        [commentCountLabel setTextColor:[UIColor_ColorChange colorWithHexString:@"#B3B3B3"]];
        [commentCountLabel sizeToFit];
        
        
        //点赞按钮
        UIButton *likeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 23)];
        [likeBtn setImage:[UIImage imageNamed:@"ic_like"] forState:UIControlStateNormal];
        likeBtn.myCenterY=0;
        likeBtn.myTop=2;
        likeBtn.myLeft = ScreenWidth*0.31 -16;
        
        //点赞人数
        UILabel *likeCount = [UILabel new];
        [likeCount setFont:[UIFont systemFontOfSize:13]];
        [likeCount setText:@"1299"];
        [likeCount setTextColor:[UIColor_ColorChange colorWithHexString:@"#B3B3B3"]];
        [likeCount sizeToFit];
        likeCount.myCenterY=0;
        likeCount.myTop=2;
        likeCount.myLeft = 2;
        likeCount.myTrailing = 10; //右边边距10
        
        
        
        [toolbarLayout addSubview:commentBtn];
        [toolbarLayout addSubview:commentCountLabel];
        [toolbarLayout addSubview:likeBtn];
        [toolbarLayout addSubview:likeCount];
        
        [self.contentView addSubview:_headView];
        [self.contentView addSubview:_posterLabel];
        [self.contentView addSubview:_timeLabel];
        
        [contentLayout addSubview:_detailLabel];
        [contentLayout addSubview:_photosView];
        [contentLayout addSubview:toolbarLayout];
        [self.contentView addSubview:contentLayout];
        
    }
     return self;
}

-(void)setViewModel:(MomentViewModel *)viewModel{
    
    [_posterLabel setText:viewModel.momentModel.poster];
    [_posterLabel sizeToFit];
    
    [_timeLabel setText:viewModel.momentModel.postTime];
    [_timeLabel sizeToFit];
    
    [_detailLabel setText:viewModel.momentModel.momentDetail];
//    [_detailLabel sizeToFit];
    CGSize labelSize = {0, 0};
    labelSize = [viewModel.momentModel.momentDetail boundingRectWithSize:CGSizeMake(300, 5000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _detailLabel.font} context:nil].size;
    
    _detailLabel.numberOfLines = 0;//表示label可以多行显示
    
    _detailLabel.lineBreakMode = NSLineBreakByWordWrapping;//换行模式，与上面的计算保持一致。
    
    _detailLabel.frame = CGRectMake(_detailLabel.frame.origin.x, _detailLabel.frame.origin.y, _detailLabel.frame.size.width, labelSize.height);//保持原来Label的位置和宽度，只是改变高度
    
    //
    [_headView setImage:[UIImage imageNamed:@"head_boy"]];
    
    //如果没有图片则隐藏 图片View
    
    if (viewModel.momentModel.photoUrls.count!= 0) {
        self.photosView.hidden = NO;
        // 设置图片缩略图数组
        self.photosView.thumbnailUrls = viewModel.momentModel.photoUrls;
        // 设置图片原图地址
        self.photosView.originalUrls = viewModel.momentModel.photoUrls;
        // 设置图片frame
        self.photosView.frame = viewModel.bodyPhotoFrame;
    }else{
        self.photosView.hidden = YES;
        
    }
    

}




@end
