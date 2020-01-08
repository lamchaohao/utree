//
//  MomentDetailView.m
//  utree
//
//  Created by 科研部 on 2019/11/20.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "MomentDetailView.h"
#import "CommentModel.h"
#import "CommentCell.h"
#import "MMAlertView.h"
#import "CommentCellViewModel.h"
#import "ZFUtilities.h"

@interface MomentDetailView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)MyLinearLayout *headerLayout;
@property(nonatomic,strong)MyRelativeLayout *toolbarLayout;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *playVideoBtn;
@property(nonatomic,strong)UILabel *likeCountLabel;
@property(nonatomic,strong)UILabel *commentCountLabel;
@property(nonatomic,strong)UIImageView *likeImageAnim;
@property(nonatomic,strong)NSMutableArray *cellViewModelList;
@property(nonatomic,assign)CGFloat headViewHeight;
@end

@implementation MomentDetailView
static NSString *CellID = @"commentID";


- (instancetype)initWithFrame:(CGRect)frame andViewModel:(MomentViewModel *)viewModel
{
    self = [super initWithFrame:frame];
    if (self) {
        self.viewModel = viewModel;
        self.cellViewModelList = [[NSMutableArray alloc]init];
        [self initHeaderView];
        [self bindViewWithData];
        [self initTableView];
        [self initToolBar];
    }
    return self;
}


-(void)initHeaderView
{
    self.headerLayout =[MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    CGRect mainFrame =self.viewModel.momentsBodyFrame;
    self.headerLayout.backgroundColor = [UIColor whiteColor];
    self.headerLayout.frame = CGRectMake(0, 20, mainFrame.size.width, mainFrame.size.height+46);
    
    MyRelativeLayout *topLayout = [MyRelativeLayout new];
    topLayout.frame = CGRectMake(circleCellMargin, 0, ScreenWidth, 48);

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
    
    [topLayout addSubview:_headView];
    [topLayout addSubview:_posterLabel];
    [topLayout addSubview:_timeLabel];
    [topLayout addSubview:moreBtn];
    

    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];

    contentLayout.frame = CGRectMake(circleCellMargin, 64, ScreenWidth-circleCellMargin*2, 190);
    contentLayout.myLeft=contentLayout.myTop=circleCellMargin;
    _detailLabel = [UILabel new];
    
    _detailLabel.myTop=circleCellMargin;
    [_detailLabel setTextColor:[UIColor_ColorChange colorWithHexString:@"4D4D4D"]];
    _detailLabel.numberOfLines = 0;//表示label可以多行显示
    _detailLabel.lineBreakMode = NSLineBreakByWordWrapping;//换行模式，与上面的计算保持一致。
    [_detailLabel setFont:circleCellTextFont];

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
    
    
    [contentLayout addSubview:_detailLabel];
    [contentLayout addSubview:_photosView];
    [contentLayout addSubview:_videoFrameLayout];
    //评论数与点赞数
    MyRelativeLayout *stateLayout = [MyRelativeLayout new];
    stateLayout.frame = CGRectMake(0, 0, ScreenWidth, 46);
    self.commentCountLabel = [UILabel new];
    [self.commentCountLabel setFont:[UIFont systemFontOfSize:15]];
    [self.commentCountLabel setTextColor:[UIColor myColorWithHexString:@"#4D4D4D"]];
    [self.commentCountLabel setText:@"评论 30"];
    [self.commentCountLabel sizeToFit];
    self.commentCountLabel.myLeft=self.commentCountLabel.myTop=circleCellMargin;
    
    self.likeCountLabel = [UILabel new];
    [self.likeCountLabel setFont:[UIFont systemFontOfSize:15]];
    [self.likeCountLabel setTextColor:[UIColor myColorWithHexString:@"#999999"]];
    [self.likeCountLabel setText:@"点赞 30"];
    [self.likeCountLabel sizeToFit];
    self.likeCountLabel.myRight=self.likeCountLabel.myTop=circleCellMargin;
    
    [stateLayout addSubview:self.commentCountLabel];
    [stateLayout addSubview:self.likeCountLabel];
    

    
    [self.headerLayout addSubview:topLayout];
    [self.headerLayout addSubview:contentLayout];
    [self.headerLayout addSubview:stateLayout];
}


-(void)initTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, iPhone_Top_NavH, ScreenWidth, self.bounds.size.height-iPhone_Bottom_NavH) style:UITableViewStyleGrouped];
    [_tableView registerClass:[CommentCell class] forCellReuseIdentifier:CellID];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    //tabBar遮挡tableview问题
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleWidth;
    
    _tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, iPhone_Bottom_NavH, 0.0f);
    [self addSubview:_tableView];
    
    _tableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshComment)];
    
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellViewModelList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCellViewModel *viewModel = [self.cellViewModelList objectAtIndex:indexPath.row];
    CommentCell *cell =(CommentCell*) [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellID withViewModel:viewModel];
    }else{
        [cell setCellViewModel:viewModel];
    }
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerLayout;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        return self.headViewHeight+8;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCellViewModel *viewModel =[self.cellViewModelList objectAtIndex:indexPath.row];
    return viewModel.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
      //选中后不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CommentCellViewModel *viewModel = [self.cellViewModelList objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(onCommentClickAndShowOption:)]) {
        [self.delegate onCommentClickAndShowOption:viewModel.commentModel];
    }
    
}


-(void)initToolBar
{
    self.toolbarLayout = [MyRelativeLayout new];
    self.toolbarLayout.frame = CGRectMake(0, 0, ScreenWidth-32, 40);
    self.toolbarLayout.bottomPos.equalTo(self.bottomPos).offset(10);

    //中分符
    UIImageView *dividerVertical = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_devider_vertical"]];
    dividerVertical.myCenterX=0;
    dividerVertical.myCenterY=0;

    //评论按钮
    self.commentBtn= [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    [self.commentBtn setImage:[UIImage imageNamed:@"ic_comment"] forState:UIControlStateNormal];

    [self.commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    [self.commentBtn setTitleColor:[UIColor myColorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [self.commentBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];

    [self.commentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, self.commentBtn.imageView.image.size.width+5, 0, 0)];
    [self.commentBtn addTarget:self action:@selector(onCommentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.commentBtn.myCenterY=0;
    self.commentBtn.myTop=2;
    self.commentBtn.myLeft = ScreenWidth*0.15;
     

    //点赞按钮
    self.likeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    [self.likeButton setImage:[UIImage imageNamed:@"ic_like"] forState:UIControlStateNormal];
    [self.likeButton setTitle:@"点赞" forState:UIControlStateNormal];
    [self.likeButton setTitleColor:[UIColor myColorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [self.likeButton.titleLabel setFont:[UIFont systemFontOfSize:16]];

    [self.likeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, self.likeButton.imageView.image.size.width+5, 0, 0)];

    self.likeButton.myTop=2;
    self.likeButton.myCenterY=0;
    self.likeButton.myRight = ScreenWidth*0.15;
    [self.likeButton addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];


    [self.toolbarLayout addSubview:self.commentBtn];
    [self.toolbarLayout addSubview:dividerVertical];
    [self.toolbarLayout addSubview:self.likeButton];
    
    [self addSubview:self.toolbarLayout];
}

-(void)bindViewWithData
{
    self.headViewHeight = self.viewModel.cellHeight;
    [_headView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.momentModel.teacherDo.path] placeholderImage:[UIImage imageNamed:@"default_head"]];

    [_posterLabel setText:self.viewModel.momentModel.teacherDo.teacherName];
    [_posterLabel sizeToFit];

    [_timeLabel setText:self.viewModel.momentModel.createTime];
    [_timeLabel sizeToFit];

    [_detailLabel setText:self.viewModel.momentModel.content];
    _detailLabel.frame = self.viewModel.bodyTextFrame;
    [_detailLabel sizeToFit];
    //如果没有图片则隐藏 图片View

    if (self.viewModel.momentModel.picList.count!= 0) {
        self.photosView.hidden = NO;
        // 设置图片缩略图数组
        self.photosView.thumbnailUrls = self.viewModel.momentModel.picList;
        // 设置图片原图地址
        self.photosView.originalUrls = self.viewModel.momentModel.picList;
        // 设置图片frame
        self.photosView.frame = self.viewModel.bodyPhotoFrame;
    }else{
        self.photosView.hidden = YES;
        
    }
    
    if (self.viewModel.momentModel.video) {
        self.videoFrameLayout.hidden=NO;
         UIImage *placeholder = [ZFUtilities imageWithColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:0.8] size:self.videoView.bounds.size];
        [_videoView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.momentModel.video.minPath] placeholderImage:placeholder completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            self.viewModel.momentModel.video.videoHeight=image.size.height;
            self.viewModel.momentModel.video.videoWidth=image.size.width;
            CGFloat videoH = 9*20;
            CGFloat videoW = 16*20;
            
            if(image.size.width < image.size.height){//竖屏
                self.videoFrameLayout.frame = CGRectMake(0, 0, circleCellWidth, circleCellWidth);
                self.headViewHeight+=(circleCellWidth-videoH);
            }else{
                self.videoFrameLayout.frame = CGRectMake(0, 0, videoW, videoH);
            }
        }];
        _videoView.contentMode=UIViewContentModeScaleAspectFit;
        [_playVideoBtn addTarget:self action:@selector(onPlayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _videoView.userInteractionEnabled = YES;
    }else{
        self.videoFrameLayout.hidden=YES;
    }
    
    [self.commentCountLabel setText:[NSString stringWithFormat:@"评论 %ld",self.viewModel.momentModel.commentCount.longValue]];
    [self.likeCountLabel setText:[NSString stringWithFormat:@"点赞 %ld",self.viewModel.momentModel.likeCount.longValue]];
    
    [self setLikeLayout];
    [self.tableView reloadData];
}

-(void)setLikeLayout
{
    if ([self.viewModel.momentModel.hasLike boolValue]) {
         [self.likeButton setImage:[UIImage imageNamed:@"ic_liked"] forState:UIControlStateNormal];
    }else{
        [self.likeButton setImage:[UIImage imageNamed:@"ic_like"] forState:UIControlStateNormal];
    }
}

- (UIImageView *)likeImageAnim
{
    if(!_likeImageAnim){
        NSString *gifPath = [[NSBundle mainBundle] pathForResource:@"like_animation" ofType:@"gif"];
        NSData *gifData = [NSData dataWithContentsOfFile:gifPath];
        UIImage *image = [UIImage sd_imageWithGIFData:gifData];
        _likeImageAnim = [[UIImageView alloc]initWithImage:image];
        _likeImageAnim.frame = CGRectMake(0, 0, 96, 124);
        _likeImageAnim.myCenter=CGPointMake(0, 0);
    }
    return _likeImageAnim;
}

-(void)onPlayButtonClick:(id)send
{
    if ([self.delegate respondsToSelector:@selector(onPlayVideoClick)]) {
        [self.delegate onPlayVideoClick];
    }
    
}



-(void)onMoreBtnClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(onMoreButtonClick)]) {
        [self.delegate onMoreButtonClick];
    }
}

-(void)likeBtnClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(requestLikeMoment)]) {
        [self.delegate requestLikeMoment];
    }
}

-(void)showLikeAnim:(BOOL)needShow
{
    if (needShow) {
        [self addSubview:self.likeImageAnim];
        __weak UIImageView *weakLikeAnim = self.likeImageAnim;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakLikeAnim removeFromSuperview];
        });
    }
}

-(void)onCommentBtnClick:(id)sender
{
    MMAlertView *inputView = [[MMAlertView alloc]initWithInputTitle:@"评论" detail:[NSString stringWithFormat:@"评论给%@",self.viewModel.momentModel.teacherDo.teacherName] placeholder:@"评论" handler:^(NSString *text) {
        if (text.length>0) {
            if ([self.delegate respondsToSelector:@selector(sendComment:)]) {
                [self.delegate sendComment:text];
            }
        }
    }];
    [inputView show];
}

-(void)refreshComment
{
    if([self.delegate respondsToSelector:@selector(loadCommentDataFirstTime)])
    {
        [self.delegate loadCommentDataFirstTime];
    }
}

-(void)loadMoreData
{
    if([self.delegate respondsToSelector:@selector(loadMoreData)])
    {
        [self.delegate loadMoreData];
    }
}

- (void)refreshFinish:(NSArray *)commentList
{
    [self.cellViewModelList removeAllObjects];
    for (CommentModel *model in commentList) {
        CommentCellViewModel *viewModel = [[CommentCellViewModel alloc]init];
        [viewModel caculateFrameWith:model];
        [self.cellViewModelList addObject:viewModel];
    }
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
    [self bindViewWithData];
}

- (void)loadMoreFinish:(NSArray *)addictionalList
{
    if (addictionalList) {
        
        for (CommentModel *model in addictionalList) {
            CommentCellViewModel *viewModel = [[CommentCellViewModel alloc]init];
            [viewModel caculateFrameWith:model];
            [self.cellViewModelList addObject:viewModel];
        }
        if (addictionalList.count==0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
           [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView reloadData];
    }else{
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    }
    
    
}

- (void)likeMomentActionResult:(NSNumber *)hasLike
{
    self.viewModel.momentModel.hasLike = hasLike;
    if (self.viewModel.momentModel.hasLike.boolValue) {
        long likeCount = self.viewModel.momentModel.likeCount.longValue +1;
        self.viewModel.momentModel.likeCount =[NSNumber numberWithLong:likeCount];
    }else{
        long likeCount = self.viewModel.momentModel.likeCount.longValue - 1;
        self.viewModel.momentModel.likeCount =[NSNumber numberWithLong:likeCount];
    }
    [self bindViewWithData];
    
    [self showLikeAnim:self.viewModel.momentModel.hasLike.boolValue];
}




@end
