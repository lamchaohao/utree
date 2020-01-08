//
//  NoticeCellTableViewCell.m
//  utree
//
//  Created by 科研部 on 2019/8/29.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "NoticeCell.h"
#import "NoticeViewModel.h"

@interface NoticeCell()

@property(nonatomic,strong)MyRelativeLayout *topLayout;
@property(nonatomic,strong) UILabel *readCountLabel;
@property(nonatomic,strong)MyLinearLayout *contentLayout;
@end

@implementation NoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

// 1. 初始化子视图
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    MyRelativeLayout *topLayout = [MyRelativeLayout new];
    topLayout.frame = CGRectMake(0, 0, ScreenWidth, 50);
    _headView = [[UIImageView alloc]initWithFrame:CGRectMake(18, 18, 48, 48)];
    _posterLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 23, 254, 20)];
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 45, 260, 18)];
    _parentVisView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
    _feedbackView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 26, 20)];
    
    _headView.myTop=_headView.myLeft=circleCellMargin;
    _posterLabel.topPos.equalTo(_headView.topPos).offset(5);
    _posterLabel.leftPos.equalTo(_headView.rightPos).offset(10);
    _timeLabel.topPos.equalTo(_posterLabel.bottomPos).offset(5);
    _timeLabel.leftPos.equalTo(_headView.rightPos).offset(10);
    
    _feedbackView.rightPos.equalTo(topLayout.rightPos).offset(10);
    _feedbackView.myCenterY=0;
    _parentVisView.rightPos.equalTo(topLayout.rightPos)
    .offset(CGRectGetMaxX(_feedbackView.frame)+16);
    
    _parentVisView.myCenterY=0;
    
    [_timeLabel setTextColor:[UIColor_ColorChange colorWithHexString:SecondTextColor]];
    [_timeLabel setFont:[UIFont systemFontOfSize:13]];
    [_posterLabel setFont:[UIFont systemFontOfSize:17]];

    _headView.layer.cornerRadius=_headView.frame.size.width/2 ;//裁成圆角
    _headView.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    _headView.layer.borderWidth = 0.1f;//边框宽度
    [_feedbackView setImage:[UIImage imageNamed:@"ic_need_feedback"]];
    [_parentVisView setImage:[UIImage imageNamed:@"ic_parent_only"]];
    
    [topLayout addSubview:_headView];
    [topLayout addSubview:_posterLabel];
    [topLayout addSubview:_timeLabel];
//    [topLayout addSubview:_feedbackView];
//    [topLayout addSubview:_parentVisView];

    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    contentLayout.frame = CGRectMake(circleCellMargin, 80, ScreenWidth-circleCellMargin*2, 190);
    _titleLabel = [[UILabel alloc]init];
    _detailLabel = [[UILabel alloc]init];

    _titleLabel.myWidth =contentLayout.frame.size.width;
    _titleLabel.myRight = circleCellMargin;
    _titleLabel.myLeft = 0;
    _titleLabel.myBottom=circleCellMargin;
    [_titleLabel setNumberOfLines:0];
    [_titleLabel setTextColor:[UIColor_ColorChange colorWithHexString:@"#F8A21A"]];
    [_titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    [_detailLabel setTextColor:[UIColor_ColorChange colorWithHexString:@"4D4D4D"]];
    [_detailLabel setFont:circleCellTextFont];
    _detailLabel.numberOfLines=0;

    _audioButton = [[UTAudioButton alloc]initWithFrame:CGRectMake(0,0,163,40)];
    _audioButton.myLeft=0;
    _audioButton.myTop=circleCellMargin;
    
//    _audioButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_audioButton setBackgroundImage:[UIImage imageNamed:@"bg_audio_record"] forState:UIControlStateNormal];
//    [_audioButton setTitle:@"120'" forState:UIControlStateNormal];
//    [_audioButton setTitleColor:[UIColor myColorWithHexString:@"#028CC3"] forState:UIControlStateNormal];
//    _audioButton.frame = CGRectMake(0,0,163,40);
//    _audioButton.myLeft=0;
//    _audioButton.myTop=circleCellMargin;
//
//    [_audioButton setImage:[UIImage imageNamed:@"ic_voice_wave"] forState:UIControlStateNormal];
//    [_audioButton setTitleEdgeInsets:UIEdgeInsetsMake(0, _audioButton.imageView.image.size.width-20, 0, 0)];
//    [_audioButton setImageEdgeInsets:UIEdgeInsetsMake(0, -46, 0, 0)];
    
    
    // 图片
    // 创建一个流水布局photosView(默认为流水布局)
    PYPhotosView *flowPhotosView = [PYPhotosView photosView];
    flowPhotosView.bounces=NO;
    flowPhotosView.myTop=circleCellMargin;
    // 设置分页指示类型
    flowPhotosView.pageType = PYPhotosViewPageTypeLabel;
    flowPhotosView.photoWidth = circleCellPhotosWH;
    flowPhotosView.photoHeight = circleCellPhotosWH;
    flowPhotosView.photoMargin = circleCellPhotosMargin;
    _photosView = flowPhotosView;
    
    
    self.webButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, circleCellWidth, 56)];
    self.webButton.backgroundColor = [UIColor myColorWithHexString:@"#FFEBEBEB"];
    [self.webButton setImage:[UIImage imageNamed:@"head_boy"] forState:UIControlStateNormal];
    self.webButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    [self.webButton setTitle:@"http://www.gzz100.com" forState:UIControlStateNormal];
    self.webButton.titleLabel.numberOfLines=0;
    [self.webButton setTitleColor:[UIColor myColorWithHexString:@"#4D4D4D"] forState:UIControlStateNormal];
    [self.webButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.webButton setImageEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
    [self.webButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 0)];
    self.webButton.myTop=circleCellMargin;
    
    UILabel *readCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, circleCellWidth, 36)];
    readCountLabel.myRight=circleCellMargin;
    readCountLabel.myTop=circleCellMargin;
    readCountLabel.textAlignment = NSTextAlignmentRight;
    [readCountLabel setText:@"已查看 45/60"];
    [readCountLabel setFont:[UIFont systemFontOfSize:14]];
    [readCountLabel setTextColor:[UIColor_ColorChange colorWithHexString:@"#B3B3B3"]];
    [readCountLabel sizeToFit];
    self.readCountLabel = readCountLabel;

    [contentLayout addSubview:_titleLabel];
    [contentLayout addSubview:_detailLabel];
    [contentLayout addSubview:_audioButton];
    [contentLayout addSubview:_photosView];
    [contentLayout addSubview:self.webButton];
    [contentLayout addSubview:readCountLabel];
    self.contentLayout = contentLayout;
    [self.contentView addSubview:topLayout];
    [self.contentView addSubview:contentLayout];
    self.topLayout = topLayout;
}


-(void)setNoticeModel:(NoticeModel *)model
{
    
    [_posterLabel setText:model.teacherDo.teacherName];
    [_posterLabel sizeToFit];
    
    [_timeLabel setText:model.createTime];
    [_timeLabel sizeToFit];
//
    [_titleLabel setText:[NSString stringWithFormat:@"标题:%@",model.topic]];
    [_titleLabel sizeToFit];

    [_detailLabel setText:model.content];
//    [_detailLabel sizeToFit];

    _detailLabel.numberOfLines = 0;//表示label可以多行显示
    _detailLabel.lineBreakMode = NSLineBreakByWordWrapping;//换行模式，与上面的计算保持一致。
    _detailLabel.frame = _noticeViewModel.detailTextFrame;

    [_headView sd_setImageWithURL:[NSURL URLWithString:model.teacherDo.path] placeholderImage:[UIImage imageNamed:@"default_head"]];
    //1全部人可见，2只有家长可见
    if (model.needReceipt.boolValue) {
        [self.topLayout addSubview:self.feedbackView];
    }else{
        [self.feedbackView removeFromSuperview];
    }
    if (model.readType.longValue==2) {
        [self.topLayout addSubview:self.parentVisView];
    }else{
        [self.parentVisView removeFromSuperview];

    }
    
    if (self.noticeViewModel.notice.audio) {
        [_audioButton setHidden:NO];
        [_audioButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [_audioButton setHidden:YES];
    }
    //如果没有图片则隐藏 图片View
    if (self.noticeViewModel.notice.picList.count!= 0) {
        self.photosView.hidden = NO;
        
        // 设置图片缩略图数组
        self.photosView.thumbnailUrls = self.noticeViewModel.notice.picList;
        // 设置图片原图地址
        self.photosView.originalUrls = self.noticeViewModel.notice.picList;
        
        // 设置图片frame
        self.photosView.frame = self.noticeViewModel.bodyPhotoFrame;
    }else{
        self.photosView.hidden = YES;
    }
    
    if (self.noticeViewModel.notice.link) {
        [self.webButton setHidden:NO];
        [self.webButton setTitle:self.noticeViewModel.notice.link forState:UIControlStateNormal];
        [self.webButton addTarget:self action:@selector(onWebUrlClick:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.webButton setHidden:YES];
    }
    
    if (self.noticeViewModel.isNeedSummaryCount) {
        long checkNum = model.allCheckNum.longValue - model.unCheck.longValue;
        if(checkNum<0){
            checkNum =0;
        }
        NSString *readCountStr = [NSString stringWithFormat:@"已查看 %ld/%ld",checkNum,model.allCheckNum.longValue];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:readCountStr];
        
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor myColorWithHexString:PrimaryColor] range:NSMakeRange(3, 2+[NSString stringWithFormat:@"%ld",checkNum].length-1)];
        [self.readCountLabel setAttributedText:attStr];
        [self.readCountLabel sizeToFit];
        [self.contentLayout addSubview:self.readCountLabel];

    }else{
         [self.readCountLabel removeFromSuperview];
    }
    
}

- (void)setNoticeViewModel:(NoticeViewModel *)noticeVM{
    if (!noticeVM) {
        return;
    }
    _noticeViewModel = noticeVM;
    
    [self setNoticeModel:noticeVM.notice];
}

-(void)playAudio:(id)sender
{
    if ([self.mediaDelegate respondsToSelector:@selector(playAudioClick:)]) {
        [self.mediaDelegate playAudioClick:self];
    }
}

-(void)onWebUrlClick:(id)send
{
    if ([self.mediaDelegate respondsToSelector:@selector(openWebView:)]) {
        [self.mediaDelegate openWebView:self.noticeViewModel.notice.link];
    }
}

@end
