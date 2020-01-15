//
//  WorkHeaderView.m
//  utree
//
//  Created by 科研部 on 2019/12/2.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "WorkHeaderView.h"

@interface WorkHeaderView()

@property(nonatomic,strong)UIView *contentView;
@property(nonatomic,assign)CGFloat *height;
@property(nonatomic,assign)MyRelativeLayout *titleLayout;
@end

@implementation WorkHeaderView

- (instancetype)initWithFrame:(CGRect)frame viewModel:(WorkHeaderViewModel *)vm
{
    if (frame.size.height>=ScreenHeight-iPhone_Top_NavH) {
        frame.size.height = ScreenHeight-iPhone_Top_NavH;
    }
    self = [super initWithFrame:frame];
    if (self) {
        self.viewModel=vm;
         [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.frame = self.frame;
    scrollView.contentSize = self.frame.size;
    if (self.frame.size.height>=(ScreenHeight-iPhone_Top_NavH)) {
        scrollView.contentSize = CGSizeMake(ScreenWidth, self.viewModel.cellHeight+iPhone_Top_NavH);
    }
    
    
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self addSubview:scrollView];
    
    self.backgroundColor = [UIColor myColorWithHexString:@"#F5F5F5"];
    _bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 212)];
    [_bgView setImage:[UIImage imageNamed:@"bg_work_green"]];
    
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(circleCellMargin,circleCellMargin, circleCellWidth, self.viewModel.cellHeight-24)];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius=8;
    [scrollView addSubview:_bgView];
    
    [scrollView addSubview:self.contentView];
    
    MyRelativeLayout *topLayout = [MyRelativeLayout new];
    topLayout.frame = CGRectMake(0, 0, circleCellWidth, 50);
    _headView = [[UIImageView alloc]initWithFrame:CGRectMake(18, 18, 48, 48)];
    _posterLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 23, 254, 20)];
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 45, 260, 18)];

    _headView.myTop=_headView.myLeft=circleCellMargin;
    _posterLabel.topPos.equalTo(_headView.topPos).offset(5);
    _posterLabel.leftPos.equalTo(_headView.rightPos).offset(10);
    _timeLabel.topPos.equalTo(_posterLabel.bottomPos).offset(5);
    _timeLabel.leftPos.equalTo(_headView.rightPos).offset(10);
    
    _classListBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 153, 20)];
    [_classListBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
    [_classListBtn setTitleColor:[UIColor myColorWithHexString:@"#999999"] forState:UIControlStateNormal]; ;
    _classListBtn.rightPos.equalTo(topLayout.rightPos).offset(8);
    _classListBtn.topPos.equalTo(_headView.topPos).offset(5);
    [_classListBtn setTitle:@"三年三班、三年四班、三年五班..." forState:UIControlStateNormal];
    
    [_timeLabel setTextColor:[UIColor_ColorChange colorWithHexString:SecondTextColor]];
    [_timeLabel setFont:[UIFont systemFontOfSize:13]];
    [_posterLabel setFont:[UIFont systemFontOfSize:17]];

    _headView.layer.cornerRadius=_headView.frame.size.width/2 ;//裁成圆角
    _headView.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    _headView.layer.borderWidth = 0.1f;//边框宽度

    [topLayout addSubview:_headView];
    [topLayout addSubview:_posterLabel];
    [topLayout addSubview:_timeLabel];
    [topLayout addSubview:_classListBtn];
    
    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    contentLayout.frame = CGRectMake(circleCellMargin, topLayout.frame.size.height+circleCellMargin, ScreenWidth-32, 190);
    
    MyRelativeLayout *titleLayout = [MyRelativeLayout new];
    titleLayout.frame =CGRectMake(circleCellMargin, 0, ScreenWidth-32, 46);
    MyLinearLayout *titleLinearLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    titleLinearLayout.frame =CGRectMake(circleCellMargin, 0, ScreenWidth-32, 46);
    _titleLabel = [[UILabel alloc]init];
    _subjectLabel = [[UILabel alloc]init];
    _detailLabel = [[UILabel alloc]init];

    _subjectLabel.myWidth =ScreenWidth-32;
    _subjectLabel.myRight = circleCellMargin;
    _subjectLabel.myTop=circleContentTextMargin;
    _subjectLabel.myLeft = 0;
    [_subjectLabel setNumberOfLines:0];
    [_subjectLabel setTextColor:[UIColor_ColorChange colorWithHexString:@"#F8A21A"]];
    [_subjectLabel setFont:[UIFont systemFontOfSize:15]];

    _titleLabel.myWidth =ScreenWidth-32;
    _titleLabel.myRight = circleCellMargin;
    _titleLabel.myLeft = 0;
    _titleLabel.myTop=circleContentTextMargin;
    [_titleLabel setNumberOfLines:0];
    [_titleLabel setTextColor:[UIColor_ColorChange colorWithHexString:@"#F8A21A"]];
    [_titleLabel setFont:[UIFont systemFontOfSize:15]];
    
    _feedbackView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    _feedbackView.rightPos.equalTo(titleLayout.rightPos).offset(25);
    _feedbackView.topPos.equalTo(titleLayout.topPos).offset(10);
    [_feedbackView setImage:[UIImage imageNamed:@"ic_online_submit"]];
    
    
    _detailLabel.myWidth =circleCellWidth-2*circleCellMargin;
    _detailLabel.myRight = circleCellMargin;
    _detailLabel.myLeft=0;
    _detailLabel.myTop=circleCellMargin;
    [_detailLabel setTextColor:[UIColor_ColorChange colorWithHexString:@"4D4D4D"]];
    [_detailLabel setFont:circleCellTextFont];
    _detailLabel.numberOfLines=0;
    _detailLabel.lineBreakMode = NSLineBreakByWordWrapping;//换行模式，与上面的计算保持一致。

    _audioButton = [[UTAudioButton alloc]initWithFrame:CGRectMake(0,0,163,40)];
    _audioButton.myLeft=0;


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

    self.webButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-60, 56)];
    self.webButton.backgroundColor = [UIColor myColorWithHexString:@"#FFEBEBEB"];
    [self.webButton setImage:[UIImage imageNamed:@"ic_link"] forState:UIControlStateNormal];
    self.webButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示
    [self.webButton setTitle:@"http://www.gzz100.com" forState:UIControlStateNormal];
    self.webButton.titleLabel.numberOfLines=0;
    [self.webButton setTitleColor:[UIColor myColorWithHexString:@"#4D4D4D"] forState:UIControlStateNormal];
    [self.webButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.webButton setImageEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
    [self.webButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 0)];
    self.webButton.myTop=circleContentTextMargin;

    self.videoButton = [[UTVideoButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-60, 56)];
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

    [titleLinearLayout addSubview:_subjectLabel];
    [titleLinearLayout addSubview:_titleLabel];
    [titleLayout addSubview:titleLinearLayout];
    [titleLayout addSubview:_feedbackView];
    [contentLayout addSubview:titleLayout];
    [contentLayout addSubview:_detailLabel];
    [contentLayout addSubview:_audioButton];
    [contentLayout addSubview:_photosView];
    [contentLayout addSubview:_webButton];
    [contentLayout addSubview:_videoButton];
    [contentLayout addSubview:toolbarLayout];
    
    [self.contentView addSubview:topLayout];
    [self.contentView addSubview:contentLayout];
    self.titleLayout = titleLayout;
    
}

-(void)setClassLabelStr:(NSString *)str
{
    [self.classListBtn setTitle:str forState:UIControlStateNormal];
}

- (void)setViewModel:(WorkHeaderViewModel *)viewModel
{
    _viewModel = viewModel;
    [self setTaskModel:viewModel.taskModel];
}


-(void)setTaskModel:(HomeworkModel *)model
{
    [_posterLabel setText:model.teacherDo.teacherName];
    [_posterLabel sizeToFit];

    [_timeLabel setText:model.createTime];
    [_timeLabel sizeToFit];
    
    if (model.subjectName) {
        [_subjectLabel setText:[NSString stringWithFormat:@"科目:%@",model.subjectName]];
        [_subjectLabel sizeToFit];
    }else{
        self.titleLayout.frame =CGRectMake(circleCellMargin, 0, ScreenWidth-32, 24);
        [_subjectLabel removeFromSuperview];
    }
    
    [_titleLabel setText:[NSString stringWithFormat:@"标题:%@",model.topic]];
    _titleLabel.frame=self.viewModel.titleFrame;
    [_titleLabel sizeToFit];

    [_detailLabel setText:model.content];
    _detailLabel.frame = _viewModel.detailTextFrame;

    
    [_headView sd_setImageWithURL:[NSURL URLWithString:model.teacherDo.path] placeholderImage:[UIImage imageNamed:@"default_head"]];
    long checkNum = model.allCheckNum.longValue - model.unCheck.longValue;
    if(checkNum<0){
        checkNum =0;
    }
    
    
    if (model.uploadOnline.boolValue) {
//        [self.topLayout addSubview:self.feedbackView];
    }else{
        [self.feedbackView removeFromSuperview];
    }
    
    if (model.audio) {
        [_audioButton setHidden:NO];
        [_audioButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [_audioButton setHidden:YES];
    }
    //如果没有图片则隐藏 图片View
    if (model.picList.count!= 0) {
        self.photosView.hidden = NO;
        // 设置图片缩略图数组
        self.photosView.thumbnailUrls = model.picList;
        // 设置图片原图地址
        self.photosView.originalUrls = model.picList;
        // 设置图片frame
        self.photosView.frame = self.viewModel.bodyPhotoFrame;
    }else{
        self.photosView.hidden = YES;
    }
    //链接按钮
    if (model.link&&model.link.length>0) {
        [self.webButton setHidden:NO];
        [self.webButton setTitle:model.link forState:UIControlStateNormal];
        [self.webButton addTarget:self action:@selector(onWebUrlClick:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.webButton setHidden:YES];
    }
    //video
    if (model.video) {
        [self.videoButton setHidden:NO];
        [self.videoButton sd_setImageWithURL:[NSURL URLWithString:model.video.minPath] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ic_video_playbtn"]];
        [self.videoButton addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.videoButton setHidden:YES];
    }
    
}

-(void)playAudio:(id)sender
{
    if ([self.mediaDelegate respondsToSelector:@selector(playAudioClick:)]) {
        [self.mediaDelegate playAudioClick:self.viewModel.taskModel.audio];
    }
}

-(void)playVideo:(id)sender
{
    if ([self.mediaDelegate respondsToSelector:@selector(playVideoClick:)]) {
        [self.mediaDelegate playVideoClick:self.viewModel.taskModel.video];
    }
}

-(void)onWebUrlClick:(id)sender
{
    if ([self.mediaDelegate respondsToSelector:@selector(openWebView:)]) {
        [self.mediaDelegate openWebView:self.viewModel.taskModel.link];
    }
}

@end
