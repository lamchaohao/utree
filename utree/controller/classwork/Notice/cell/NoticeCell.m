//
//  NoticeCellTableViewCell.m
//  utree
//
//  Created by 科研部 on 2019/8/29.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "NoticeCell.h"
#import "NoticeViewModel.h"
@implementation NoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
        contentLayout.frame = CGRectMake(16, 80, ScreenWidth-32, 190);
        _titleLabel = [[UILabel alloc]init];
        _detailLabel = [[UILabel alloc]init];
        
        _titleLabel.myWidth =ScreenWidth-32;
        _titleLabel.myRight = 16;
        _titleLabel.myLeft = 0;
        [_titleLabel setNumberOfLines:0];
        [_titleLabel setTextColor:[UIColor_ColorChange colorWithHexString:@"#F8A21A"]];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        _detailLabel.myWidth =ScreenWidth-32;
        _detailLabel.myRight = 16;
        _detailLabel.myLeft = 0;
        _detailLabel.myTop=13;
        [_detailLabel setTextColor:[UIColor_ColorChange colorWithHexString:@"4D4D4D"]];
        [_detailLabel setFont:[UIFont systemFontOfSize:15]];
        _detailLabel.numberOfLines=0;

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
        
        
        MyRelativeLayout *toolbarLayout = [MyRelativeLayout new];
        toolbarLayout.frame = CGRectMake(0, 8, ScreenWidth-32, 36);
        toolbarLayout.myTop=5;
        toolbarLayout.myBottom=5;
        
        UILabel *readCountLabel = [[UILabel alloc]init];
        readCountLabel.myRight=15;
        readCountLabel.myTop=18;
        readCountLabel.trailingPos.equalTo(toolbarLayout.trailingPos);

        [readCountLabel setText:@"已查看 45/60"];
        [readCountLabel setFont:[UIFont systemFontOfSize:14]];
        [readCountLabel setTextColor:[UIColor_ColorChange colorWithHexString:@"#B3B3B3"]];
        [readCountLabel sizeToFit];
        [toolbarLayout addSubview:readCountLabel];
        
        [self.contentView addSubview:_headView];
        [self.contentView addSubview:_posterLabel];
        [self.contentView addSubview:_timeLabel];
        [contentLayout addSubview:_titleLabel];
        [contentLayout addSubview:_detailLabel];
        [contentLayout addSubview:_photosView];
        [contentLayout addSubview:toolbarLayout];
        [self.contentView addSubview:contentLayout];
        
    }
    return self;
}

-(void)setNoticeModel:(NoticeModel *)model
{
    
    [_posterLabel setText:model.poster];
    [_posterLabel sizeToFit];
    
    [_timeLabel setText:model.postTime];
    [_timeLabel sizeToFit];
//
    [_titleLabel setText:[NSString stringWithFormat:@"标题:%@",model.noticeTitle]];
    [_titleLabel sizeToFit];

    [_detailLabel setText:model.noticeDetail];
//    [_detailLabel sizeToFit];

    CGSize labelSize = {0, 0};
    labelSize = [model.noticeDetail boundingRectWithSize:CGSizeMake(300, 5000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _detailLabel.font} context:nil].size;

    _detailLabel.numberOfLines = 0;//表示label可以多行显示
    
    _detailLabel.lineBreakMode = NSLineBreakByWordWrapping;//换行模式，与上面的计算保持一致。
    
    _detailLabel.frame = CGRectMake(_detailLabel.frame.origin.x, _detailLabel.frame.origin.y, _detailLabel.frame.size.width, labelSize.height);//保持原来Label的位置和宽度，只是改变高度
//
    [_headView setImage:[UIImage imageNamed:@"head_boy"]];
//    [_singlePhotoView setImage:[UIImage imageNamed:@"tree_bg"]];
    
    //如果没有图片则隐藏 图片View
    if (self.noticeViewModel.notice.photoUrls.count!= 0) {
        self.photosView.hidden = NO;
        // 设置图片缩略图数组
        self.photosView.thumbnailUrls = self.noticeViewModel.notice.photoUrls;
        // 设置图片原图地址
        self.photosView.originalUrls = self.noticeViewModel.notice.photoUrls;
        // 设置图片frame
        self.photosView.frame = self.noticeViewModel.bodyPhotoFrame;
    }else{
        self.photosView.hidden = YES;
    }
    
}

- (void)setNoticeViewModel:(NoticeViewModel *)noticeVM{
    _noticeViewModel = noticeVM;
    
    [self setNoticeModel:noticeVM.notice];
    //设置子控件的frame
//    self.bodyView.frame = momentFrames.momentsBodyFrame;
//    self.bodyView.momentFrames = momentFrames;
//    self.toolBarView.frame = momentFrames.momentsToolBarFrame;
//    self.toolBarView.momentFrames = momentFrames;
}


@end
