//
//  MomentCell.m
//  utree
//
//  Created by 科研部 on 2019/8/28.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "MomentCell.h"
#import "ZFUtilities.h"
@interface MomentCell()

@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)MyFrameLayout *videoFrameLayout;
@end

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
        [self setupUI];
    }
     return self;
}

-(void)setupUI
{
    MyRelativeLayout *topLayout = [MyRelativeLayout new];
    topLayout.frame = CGRectMake(0, 0, ScreenWidth, 50);

    _headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, circleCellMargin, 48, 48)];
    _headView.layer.cornerRadius=_headView.frame.size.width/2 ;//裁成圆角
    _headView.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    _headView.layer.borderWidth = 0.1f;//边框宽度

    _posterLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 254, 20)];
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 260, 18)];
    [_timeLabel setTextColor:[UIColor_ColorChange colorWithHexString:SecondTextColor]];
    [_timeLabel setFont:[UIFont systemFontOfSize:13]];
    [_posterLabel setFont:[UIFont systemFontOfSize:17]];
    _headView.myTop=_headView.myLeft=18;
    _posterLabel.topPos.equalTo(_headView.topPos).offset(5);
    _posterLabel.leftPos.equalTo(_headView.rightPos).offset(10);
    _timeLabel.topPos.equalTo(_posterLabel.bottomPos).offset(5);
    _timeLabel.leftPos.equalTo(_headView.rightPos).offset(10);
    UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 46)];
    [moreBtn setImage:[UIImage imageNamed:@"ic_more_horizontal"] forState:UIControlStateNormal];
    moreBtn.rightPos.equalTo(topLayout.rightPos).offset(18);
    moreBtn.myCenterY=0;
    [moreBtn addTarget:self action:@selector(onMoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];

    contentLayout.frame = CGRectMake(circleCellMargin, 64, circleCellWidth, 190);
    _detailLabel = [UILabel new];
    _detailLabel.myTop=circleCellMargin;
    [_detailLabel setTextColor:[UIColor_ColorChange colorWithHexString:@"4D4D4D"]];
    _detailLabel.numberOfLines = 0;//表示label可以多行显示
    _detailLabel.lineBreakMode = NSLineBreakByWordWrapping;//换行模式，与上面的计算保持一致。
    [_detailLabel setFont:circleCellTextFont];

    // 图片
    // 创建一个流水布局photosView(默认为流水布局)
    PYPhotosView *flowPhotosView = [PYPhotosView photosView];
    flowPhotosView.photoWidth = circleCellPhotosWH;
    flowPhotosView.photoHeight = circleCellPhotosWH;
    flowPhotosView.photoMargin = circleCellPhotosMargin;

    //        [self addSubview:flowPhotosView];
    _photosView = flowPhotosView;
    _photosView.myTop=circleCellMargin;

    _videoFrameLayout = [MyFrameLayout new];
    _videoFrameLayout.frame =CGRectMake(0, 0, ScreenWidth-30, 200);
    _videoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-30, 200)];
    _videoView.backgroundColor = [UIColor grayColor];


    _videoView.myVertMargin=0;
    _videoView.myHorzMargin=0;

    _playVideoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 38, 38)];
    [_playVideoBtn setImage:[UIImage imageNamed:@"ic_video_playbtn"] forState:UIControlStateNormal];
    _playVideoBtn.myCenterY=0;
    _playVideoBtn.myCenterX=0;
    _videoFrameLayout.hidden=YES;
    _videoFrameLayout.tag = 100;
    _videoFrameLayout.myTop=circleCellMargin;
    [_videoFrameLayout addSubview:_videoView];
    [_videoFrameLayout addSubview:_playVideoBtn];

    MyRelativeLayout *toolbarLayout = [MyRelativeLayout new];
    toolbarLayout.frame = CGRectMake(0, 8, ScreenWidth-32, circleCellToolBarHeight);
    toolbarLayout.myTop=circleCellMargin;
    toolbarLayout.myBottom=5;
    //        toolbarLayout.gravity = MyGravity_Vert_Center|MyGravity_Vert_Between;
    //中分符
    UIImageView *dividerVertical = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_devider_vertical"]];
    dividerVertical.myCenterX=0;
    dividerVertical.myCenterY=0;

    //评论按钮
    self.commentBtn= [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 25)];
    [self.commentBtn setImage:[UIImage imageNamed:@"ic_comment"] forState:UIControlStateNormal];

    [self.commentBtn setTitle:@"179" forState:UIControlStateNormal];
    [self.commentBtn setTitleColor:[UIColor myColorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [self.commentBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];

    [self.commentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, self.commentBtn.imageView.image.size.width+5, 0, 0)];
    [self.commentBtn addTarget:self action:@selector(onCommentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.commentBtn.myCenterY=0;
    self.commentBtn.myTop=2;
    self.commentBtn.myLeft = ScreenWidth*0.15;
     

    //点赞按钮
    self.likeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 25)];
    [self.likeButton setImage:[UIImage imageNamed:@"ic_like"] forState:UIControlStateNormal];
    [self.likeButton setTitle:@"228" forState:UIControlStateNormal];
    [self.likeButton setTitleColor:[UIColor myColorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [self.likeButton.titleLabel setFont:[UIFont systemFontOfSize:16]];

    [self.likeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, self.likeButton.imageView.image.size.width+5, 0, 0)];

    self.likeButton.myCenterY=0;
    self.likeButton.myTop=2;
    self.likeButton.myRight = ScreenWidth*0.15;
    [self.likeButton addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];


    [toolbarLayout addSubview:self.commentBtn];
    [toolbarLayout addSubview:dividerVertical];
    [toolbarLayout addSubview:self.likeButton];

    [topLayout addSubview:_headView];
    [topLayout addSubview:_posterLabel];
    [topLayout addSubview:_timeLabel];
    [topLayout addSubview:moreBtn];

    [contentLayout addSubview:_detailLabel];
    [contentLayout addSubview:_videoFrameLayout];
    [contentLayout addSubview:_photosView];
    [contentLayout addSubview:toolbarLayout];
    [self.contentView addSubview:topLayout];
    [self.contentView addSubview:contentLayout];
}

-(void)setViewModelData:(MomentViewModel *)viewModel atIndex:(NSIndexPath *)indexPath{
    self.viewModel = viewModel;
    self.indexPath = indexPath;
    [_headView sd_setImageWithURL:[NSURL URLWithString:viewModel.momentModel.teacherDo.path] placeholderImage:[UIImage imageNamed:@"default_head"]];
    
    [_posterLabel setText:viewModel.momentModel.teacherDo.teacherName];
    [_posterLabel sizeToFit];
    
    [_timeLabel setText:viewModel.momentModel.createTime];
    [_timeLabel sizeToFit];
    
    [_detailLabel setText:viewModel.momentModel.content];
    CGRect oldFrame = _detailLabel.frame;
    _detailLabel.frame = (CGRect){oldFrame.origin,self.viewModel.bodyTextFrame.size};
    [_detailLabel sizeToFit];
    
    //如果没有图片则隐藏 图片View
    if (viewModel.momentModel.picList.count!= 0) {
        self.photosView.hidden = NO;
        // 设置图片缩略图数组
        self.photosView.thumbnailUrls = viewModel.momentModel.picList;
        // 设置图片原图地址
        self.photosView.originalUrls = viewModel.momentModel.picList;
        // 设置图片frame
        self.photosView.frame = viewModel.bodyPhotoFrame;
        
    }else{
        self.photosView.hidden = YES;
        
    }
    if (viewModel.momentModel.video) {
        UIImage *placeholder = [ZFUtilities imageWithColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1] size:self.videoView.bounds.size];
        [_videoView sd_setImageWithURL:[NSURL URLWithString:viewModel.momentModel.video.minPath] placeholderImage:placeholder completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            self.viewModel.momentModel.video.videoHeight=image.size.height;
            self.viewModel.momentModel.video.videoWidth=image.size.width;
            if(image.size.width > image.size.height){//竖屏 image可能为nil，默认要与viewModel的bodyVideoFrame一致，否则会一直刷新
                self.videoFrameLayout.frame =CGRectMake(0, 0, 16*20, 9*20);
            }else{
                self.videoFrameLayout.frame = CGRectMake(0, 0, 9*20, 16*20);
            }
            self.videoFrameLayout.hidden=NO;
            //两个区域不相等 则更新
    if(!CGSizeEqualToSize(self.viewModel.bodyVideoFrame.size,self.videoFrameLayout.frame.size)) {
                [self.actionDelegate resizeVideoView:indexPath];
                [self.viewModel setMomentModel:viewModel.momentModel];
            }
            
        }];
        
        _videoView.userInteractionEnabled = YES;
        [_playVideoBtn addTarget:self action:@selector(playTheVideoAtIndexPath) forControlEvents:UIControlEventTouchUpInside];
        [_videoView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playFullScreenVideo)]];
    }else{
        self.videoFrameLayout.hidden=YES;
    }
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%ld",self.viewModel.momentModel.commentCount.longValue] forState:UIControlStateNormal];
    [self setLikeLayout];
    

}

//全屏播放
-(void)playFullScreenVideo
{
    if ([self.actionDelegate respondsToSelector:@selector(playVideoFullScreen:moment:)]) {
        [self.actionDelegate playVideoFullScreen:self.indexPath moment:self.viewModel.momentModel];
    }
}

-(void)playTheVideoAtIndexPath
{
    if ([self.actionDelegate respondsToSelector:@selector(playVideoAtIndex:moment:)]) {
        [self.actionDelegate playVideoAtIndex:self.indexPath moment:self.viewModel.momentModel];
    }
}

-(void)setLikeLayout
{
    [self.likeButton setTitle:[NSString stringWithFormat:@"%ld",self.viewModel.momentModel.likeCount.longValue] forState:UIControlStateNormal];
    if ([self.viewModel.momentModel.hasLike boolValue]) {
         [self.likeButton setImage:[UIImage imageNamed:@"ic_liked"] forState:UIControlStateNormal];
        [self.likeButton setTitleColor:[UIColor myColorWithHexString:@"#FD9D05"] forState:UIControlStateNormal];
    }else{
        [self.likeButton setImage:[UIImage imageNamed:@"ic_like"] forState:UIControlStateNormal];
        [self.likeButton setTitleColor:[UIColor myColorWithHexString:@"#666666"] forState:UIControlStateNormal];
    }
//    [self.likeButton setTitle:@"1299" forState:UIControlStateNormal];
}

-(void)likeBtnClick:(id)sender
{
    //先改变状态,并且点赞数增加
    self.viewModel.momentModel.hasLike= [NSNumber numberWithBool:!self.viewModel.momentModel.hasLike.boolValue];
    if (self.viewModel.momentModel.hasLike.boolValue) {
        
        long likeCount = self.viewModel.momentModel.likeCount.longValue +1;
        self.viewModel.momentModel.likeCount =[NSNumber numberWithLong:likeCount];
    }else{
        long likeCount = self.viewModel.momentModel.likeCount.longValue - 1;
             self.viewModel.momentModel.likeCount =[NSNumber numberWithLong:likeCount];
    }
    
    [self.actionDelegate onLikeClick:self.viewModel.momentModel.schoolCircleId showAnim:self.viewModel.momentModel.hasLike.boolValue];
    [self setLikeLayout];
    
}

-(void)onMoreBtnClick:(id)sender
{
    if([self.actionDelegate respondsToSelector:@selector(onMoreClick:)])
    {
        [self.actionDelegate onMoreClick:self.viewModel.momentModel];
    }
}

-(void)onCommentBtnClick:(id)sender
{
    if([self.actionDelegate respondsToSelector:@selector(onCommentClick:)])
       {
           [self.actionDelegate onCommentClick:self.viewModel.momentModel];
       }
}


@end
