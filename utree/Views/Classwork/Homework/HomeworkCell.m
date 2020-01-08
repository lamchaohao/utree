//
//  HomeworkCell.m
//  utree
//
//  Created by 科研部 on 2019/11/26.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "HomeworkCell.h"
#import "HomeworkModel.h"

@interface HomeworkCell()

@property(nonatomic,strong)MyRelativeLayout *topLayout;
@property(nonatomic,strong)UILabel *readCountLabel;
@property(nonatomic,strong)MyRelativeLayout *toolbarLayout;
@property(nonatomic,strong)MyLinearLayout *contentLayout;

@end

@implementation HomeworkCell

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
    
    _feedbackView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    
    _headView.myTop=_headView.myLeft=circleCellMargin;
    _posterLabel.topPos.equalTo(_headView.topPos).offset(5);
    _posterLabel.leftPos.equalTo(_headView.rightPos).offset(10);
    _timeLabel.topPos.equalTo(_posterLabel.bottomPos).offset(5);
    _timeLabel.leftPos.equalTo(_headView.rightPos).offset(10);
    
    _feedbackView.rightPos.equalTo(topLayout.rightPos).offset(10);
    _feedbackView.myCenterY=0;

    [_timeLabel setTextColor:[UIColor_ColorChange colorWithHexString:SecondTextColor]];
    [_timeLabel setFont:[UIFont systemFontOfSize:13]];
    [_posterLabel setFont:[UIFont systemFontOfSize:17]];

    _headView.layer.cornerRadius=_headView.frame.size.width/2 ;//裁成圆角
    _headView.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    _headView.layer.borderWidth = 0.1f;//边框宽度
    [_feedbackView setImage:[UIImage imageNamed:@"ic_online_submit"]];

    
    [topLayout addSubview:_headView];
    [topLayout addSubview:_posterLabel];
    [topLayout addSubview:_timeLabel];
    [topLayout addSubview:_feedbackView];

    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    contentLayout.frame = CGRectMake(circleCellMargin, topLayout.frame.size.height+circleCellMargin, ScreenWidth-32, 190);
    _titleLabel = [[UILabel alloc]init];
    _subjectLabel = [[UILabel alloc]init];
    _detailLabel = [[UILabel alloc]init];

    _subjectLabel.myWidth =ScreenWidth-32;
    _subjectLabel.myRight = circleCellMargin;
    _subjectLabel.myTop=circleContentTextMargin;
    _subjectLabel.myLeft = 0;
    [_subjectLabel setNumberOfLines:0];
    [_subjectLabel setTextColor:[UIColor_ColorChange colorWithHexString:@"#F8A21A"]];
    [_subjectLabel setFont:[UIFont systemFontOfSize:14]];
    
    _titleLabel.myWidth =ScreenWidth-32;
    _titleLabel.myRight = circleCellMargin;
    _titleLabel.myLeft = 0;
    _titleLabel.myTop=circleContentTextMargin;
    [_titleLabel setNumberOfLines:0];
    [_titleLabel setTextColor:[UIColor_ColorChange colorWithHexString:@"#F8A21A"]];
    [_titleLabel setFont:[UIFont systemFontOfSize:14]];

    _detailLabel.myWidth =ScreenWidth-32;
    _detailLabel.myTop=circleContentTextMargin;
    [_detailLabel setTextColor:[UIColor_ColorChange colorWithHexString:@"4D4D4D"]];
    [_detailLabel setFont:circleCellTextFont];
    _detailLabel.numberOfLines=0;
    _detailLabel.lineBreakMode = NSLineBreakByWordWrapping;//换行模式，与上面的计算保持一致。
    
    _audioButton = [[UTAudioButton alloc]initWithFrame:CGRectMake(0,0,163,40)];
    _audioButton.myLeft=0;
//    _audioButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_audioButton setBackgroundImage:[UIImage imageNamed:@"bg_audio_record"] forState:UIControlStateNormal];
//    [_audioButton setTitle:@"120'" forState:UIControlStateNormal];
//    [_audioButton setTitleColor:[UIColor myColorWithHexString:@"#028CC3"] forState:UIControlStateNormal];
//    _audioButton.frame = CGRectMake(0,0,163,40);
//    _audioButton.myLeft=0;
//    _audioButton.myTop=circleContentTextMargin;
//
//
//    [_audioButton setImage:[UIImage imageNamed:@"ic_voice_wave"] forState:UIControlStateNormal];
//    [_audioButton setTitleEdgeInsets:UIEdgeInsetsMake(0, _audioButton.imageView.image.size.width-20, 0, 0)];
//    [_audioButton setImageEdgeInsets:UIEdgeInsetsMake(0, -46, 0, 0)];
    
    
    // 图片
    // 创建一个流水布局photosView(默认为流水布局)
    PYPhotosView *flowPhotosView = [PYPhotosView photosView];
    flowPhotosView.bounces=NO;
    // 设置分页指示类型
        flowPhotosView.pageType = PYPhotosViewPageTypeLabel;
    //    flowPhotosView.py_centerX = self.py_centerX;
    //    flowPhotosView.py_y = 20 + 64;
    flowPhotosView.photoWidth = circleCellPhotosWH;
    flowPhotosView.photoHeight = circleCellPhotosWH;
    flowPhotosView.photoMargin = circleCellPhotosMargin;
    //        [self addSubview:flowPhotosView];
    _photosView = flowPhotosView;
    _photosView.myTop=circleContentTextMargin;
    
    self.webButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-30, 56)];
    self.webButton.backgroundColor = [UIColor myColorWithHexString:@"#FFEBEBEB"];
    [self.webButton setImage:[UIImage imageNamed:@"head_boy"] forState:UIControlStateNormal];
    self.webButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    [self.webButton setTitle:@"http://www.gzz100.com" forState:UIControlStateNormal];
    self.webButton.titleLabel.numberOfLines=0;
    [self.webButton setTitleColor:[UIColor myColorWithHexString:@"#4D4D4D"] forState:UIControlStateNormal];
    [self.webButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.webButton setImageEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
    [self.webButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 0)];
    self.webButton.myTop=circleContentTextMargin;

    self.videoButton = [[UTVideoButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-30, 56)];
    self.videoButton.backgroundColor = [UIColor myColorWithHexString:@"#FFEBEBEB"];
    [self.videoButton setImage:[UIImage imageNamed:@"ic_video_playbtn"] forState:UIControlStateNormal];
    self.videoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    [self.videoButton setTitle:@"视频附件📎" forState:UIControlStateNormal];
    self.videoButton.titleLabel.numberOfLines=0;
    [self.videoButton setTitleColor:[UIColor myColorWithHexString:@"#4D4D4D"] forState:UIControlStateNormal];
    [self.videoButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    self.videoButton.myTop=circleContentTextMargin;
    
    MyRelativeLayout *toolbarLayout = [MyRelativeLayout new];
    toolbarLayout.frame = CGRectMake(0, 8, ScreenWidth-32, 36);
    toolbarLayout.myTop=circleContentTextMargin;
    toolbarLayout.myBottom=circleContentTextMargin;

    UILabel *readCountLabel = [[UILabel alloc]init];
    readCountLabel.myRight=circleCellMargin;
    readCountLabel.myTop=circleContentTextMargin;
    readCountLabel.trailingPos.equalTo(toolbarLayout.trailingPos);

    [readCountLabel setText:@"已查看 45/60"];
    [readCountLabel setFont:[UIFont systemFontOfSize:14]];
    [readCountLabel setTextColor:[UIColor_ColorChange colorWithHexString:@"#B3B3B3"]];
    [readCountLabel sizeToFit];
    self.readCountLabel=readCountLabel;
    [toolbarLayout addSubview:readCountLabel];
    self.toolbarLayout = toolbarLayout;
    
    [contentLayout addSubview:_subjectLabel];
    [contentLayout addSubview:_titleLabel];
    [contentLayout addSubview:_detailLabel];
    [contentLayout addSubview:_audioButton];
    [contentLayout addSubview:_photosView];
    [contentLayout addSubview:_webButton];
    [contentLayout addSubview:_videoButton];
    [contentLayout addSubview:toolbarLayout];
    self.contentLayout = contentLayout;
    [self.contentView addSubview:topLayout];
    [self.contentView addSubview:contentLayout];
    self.topLayout = topLayout;
}

- (void)setTaskViewModel:(HomeworkViewModel *)taskVM
{
    if (!taskVM) {
        return;
    }
    _taskViewModel = taskVM;
    [self setTaskModel:self.taskViewModel.taskModel];
}

-(void)setTaskModel:(HomeworkModel *)model
{
    [_posterLabel setText:model.teacherDo.teacherName];
    [_posterLabel sizeToFit];

    [_timeLabel setText:model.createTime];
    [_timeLabel sizeToFit];
    //
    [_subjectLabel setText:[NSString stringWithFormat:@"科目:%@",model.subjectName]];
    [_subjectLabel sizeToFit];
    
    [_titleLabel setText:[NSString stringWithFormat:@"标题:%@",model.topic]];
    [_titleLabel sizeToFit];

    [_detailLabel setText:model.content];
 
    _detailLabel.numberOfLines = 0;//表示label可以多行显示
    _detailLabel.lineBreakMode = NSLineBreakByWordWrapping;//换行模式，与上面的计算保持一致。
    _detailLabel.frame=_taskViewModel.detailTextFrame;
    
    [_headView sd_setImageWithURL:[NSURL URLWithString:model.teacherDo.path] placeholderImage:[UIImage imageNamed:@"default_head"]];
    long checkNum = model.allCheckNum.longValue - model.unCheck.longValue;
    if(checkNum<0){
        checkNum =0;
    }
   
    if (model.uploadOnline.boolValue) {
        [self.topLayout addSubview:self.feedbackView];
    }else{
        [self.feedbackView removeFromSuperview];
    }
    
       //1全部人可见，2只有家长可见
    //    [self.parentVisView setHidden:model.readType.longValue==1];

    if (self.taskViewModel.taskModel.audio) {
        [_audioButton setHidden:NO];
        [_audioButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [_audioButton setHidden:YES];
    }
    //如果没有图片则隐藏 图片View
    if (self.taskViewModel.taskModel.picList.count!= 0) {
        self.photosView.hidden = NO;
        // 设置图片缩略图数组
        self.photosView.thumbnailUrls = self.taskViewModel.taskModel.picList;
        // 设置图片原图地址
        self.photosView.originalUrls = self.taskViewModel.taskModel.picList;
        // 设置图片frame
        self.photosView.frame = self.taskViewModel.bodyPhotoFrame;
    }else{
        self.photosView.hidden = YES;
    }
    //链接按钮
    if (self.taskViewModel.taskModel.link) {
        [self.webButton setHidden:NO];
        [self.webButton setTitle:self.taskViewModel.taskModel.link forState:UIControlStateNormal];
        [self.webButton addTarget:self action:@selector(onWebUrlClick:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.webButton setHidden:YES];
    }
    //video
    if (self.taskViewModel.taskModel.video) {
        [self.videoButton setHidden:NO];
        [self.videoButton sd_setImageWithURL:[NSURL URLWithString:self.taskViewModel.taskModel.video.minPath] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ic_video_playbtn"]];
        [self.videoButton addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.videoButton setHidden:YES];
    }
    
    if (self.taskViewModel.isNeedSummaryCount) {
        NSString *readCountStr = [NSString stringWithFormat:@"已查看 %ld/%ld",checkNum,model.allCheckNum.longValue];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:readCountStr];

        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor myColorWithHexString:PrimaryColor] range:NSMakeRange(3, 2+[NSString stringWithFormat:@"%ld",checkNum].length-1)];
        [self.readCountLabel setAttributedText:attStr];
        [self.readCountLabel sizeToFit];
        [self.contentLayout addSubview:self.toolbarLayout];
    }else{
//         [self.readCountLabel removeFromSuperview];
        [self.toolbarLayout removeFromSuperview];
    }
    
}

-(void)playAudio:(id)sender
{
    if ([self.mediaDelegate respondsToSelector:@selector(playAudioClick:)]) {
        [self.mediaDelegate playAudioClick:self];
    }
}

-(void)playVideo:(id)sender
{
    if ([self.mediaDelegate respondsToSelector:@selector(playVideoClick:)]) {
        [self.mediaDelegate playVideoClick:self.taskViewModel.taskModel.video];
    }
}

-(void)onWebUrlClick:(id)sender
{
    if ([self.mediaDelegate respondsToSelector:@selector(openWebView:)]) {
        [self.mediaDelegate openWebView:self.taskViewModel.taskModel.link];
    }
}

@end
