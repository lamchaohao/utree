//
//  ClassSocietyHomeVC.m
//  utree
//
//  Created by 科研部 on 2019/8/7.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ClassSocietyHomeVC.h"
#import "MomentCell.h"
#import "WrapMomentListModel.h"
#import "PostMomentVC.h"
#import "MomentDC.h"
#import "MomentDetailVC.h"
#import "VideoViewController.h"
#import "RedDotHelper.h"

@interface ClassSocietyHomeVC ()<UITableViewDataSource,UITableViewDelegate,
MomentActionDelegate,SchollCircleDetailDelegate,PostMomentCallback>
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)MomentDC *dataController;
@property (nonatomic,strong)NSMutableArray *momentViewModels; //ViewModel(包含cell子控件的Frame)
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIImageView *likeImageAnim;
@property(nonatomic,strong)UIButton *postMomentBtn;
@property(nonatomic,strong)NSString *lastMomentID;

@end
static NSString *CellID = @"societyCell";
@implementation ClassSocietyHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    self.dataController = [[MomentDC alloc]init];
    _momentViewModels = [NSMutableArray array];
    _dataSource = [NSMutableArray array];
    
    [self initTableView];
    [self initPostBtn];
    [self loadDataFirstTime];
}


- (void)loadMoreMomentData{
    
    if (self.dataSource.count>0) {
        MomentModel *lastModel= [self.dataSource lastObject];
        [self.dataController requestMoreMoments:NO limitItems:[NSNumber numberWithInt:20] lastId:lastModel.schoolCircleId WithSuccess:^(UTResult * _Nonnull result) {
            
            WrapMomentListModel *wrapListModel = result.successResult;
            [self.dataSource addObjectsFromArray:wrapListModel.list];
            for (MomentModel *moment in wrapListModel.list) {
              MomentViewModel *momentVM = [[MomentViewModel alloc] init];
              [momentVM setMomentModel:moment] ;
              [self.momentViewModels addObject:momentVM];

            }
            if (self.dataSource.count==0) {
                self.tableView.tableHeaderView = self.headView;
            }else{
                self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.tableView.bounds.size.width,0.01)];
            }
            [self.tableView reloadData];
            if(wrapListModel.list.count>0){
                [self.tableView.mj_footer endRefreshing];
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } failure:^(UTResult * _Nonnull result) {
            [self.tableView.mj_footer endRefreshing];
            [self showAlertMessage:@"" title:result.failureResult];
        }];
    }else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    

}

-(void)initTableView
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    //tabBar遮挡tableview问题
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleWidth;
    [_tableView registerClass:[MomentCell class] forCellReuseIdentifier:CellID];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDataFirstTime)];
    
    // Set the ordinary state of animated images
    NSString *gifPath = [[NSBundle mainBundle] pathForResource:@"head_refresh_anim" ofType:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile:gifPath];
    UIImage *image = [UIImage sd_imageWithGIFData:gifData];
    [header setImages:[NSArray arrayWithObject:image] forState:MJRefreshStateIdle];
    [header setImages:[NSArray arrayWithObject:image] forState:MJRefreshStatePulling];
    [header setImages:[NSArray arrayWithObject:image] forState:MJRefreshStateRefreshing];
    // Hide the time
    header.lastUpdatedTimeLabel.hidden = YES;
    // Hide the status
    header.stateLabel.hidden = YES;
    header.gifView.frame=CGRectMake(0, 0, 210*0.5, 310*0.5);
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    header.gifView.frame=CGRectMake(0, 0, 210*0.5, 310*0.5);
    
    [self.view addSubview:_tableView];
    
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMomentData)];
    
    _tableView.estimatedRowHeight = 0;
    
}

-(void)loadDataFirstTime
{

    [self.dataController requestFirstTimeList:NO limitItems:[NSNumber numberWithInt:30] WithSuccess:^(UTResult * _Nonnull result) {
        [self.momentViewModels removeAllObjects];
//        [self.videoUrls removeAllObjects];
        [self.dataSource removeAllObjects];
        WrapMomentListModel *wrapListModel = result.successResult;
        [self.dataSource addObjectsFromArray:wrapListModel.list];
        for (MomentModel *moment in self.dataSource) {
            MomentViewModel *momentVM = [[MomentViewModel alloc] init];
            [momentVM setMomentModel:moment] ;
            [self.momentViewModels addObject:momentVM];
        }
        if (self.dataSource.count==0) {
            self.tableView.tableHeaderView = self.headView;
        }else{
            self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.tableView.bounds.size.width,0.01)];
        }
        [RedDotHelper shareInstance].circleUnread=0;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(UTResult * _Nonnull result) {
        [self.tableView.mj_header endRefreshing];
        [self showAlertMessage:@"" title:result.failureResult];
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      /// 到详情页
    MomentViewModel *viewModel=[self.momentViewModels objectAtIndex:indexPath.row];
    MomentDetailVC *detailVC = [[MomentDetailVC alloc]initWithViewModel:viewModel];
               detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.delegate=self;
    [self.navigationController pushViewController:detailVC animated:YES];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MomentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    cell.actionDelegate=self;
    //选中后不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setViewModelData:_momentViewModels[indexPath.row] atIndex:indexPath];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _momentViewModels.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)resizeVideoView:(NSIndexPath *)indexPath
{
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    MomentViewModel *vm = self.momentViewModels[indexPath.row];
    NSLog(@"vm height =%f,indexpath=%ld ",vm.cellHeight,indexPath.row);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MomentViewModel *vm = self.momentViewModels[indexPath.row];
    return vm.cellHeight;
}

-(void)onLikeClick:(NSString *)momentId showAnim:(BOOL)needShow
{
    
    [self.dataController requestLikeMoment:momentId WithSuccess:^(UTResult * _Nonnull result) {
        
        if (needShow) {
            [self.view addSubview:self.likeImageAnim];
            __weak UIImageView *weakLikeAnim = self.likeImageAnim;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakLikeAnim removeFromSuperview];
            });
        }
        
    } failure:^(UTResult * _Nonnull result) {
        [self showAlertMessage:@"" title:result.failureResult];
    }];
    
    
}

- (UIImageView *)likeImageAnim
{
    if(!_likeImageAnim){
        NSString *gifPath = [[NSBundle mainBundle] pathForResource:@"like_animation" ofType:@"gif"];
        NSData *gifData = [NSData dataWithContentsOfFile:gifPath];
        UIImage *image = [UIImage sd_imageWithGIFData:gifData];
        _likeImageAnim = [[UIImageView alloc]initWithImage:image];
        _likeImageAnim.frame = CGRectMake(0, 0, 96, 124);
        _likeImageAnim.center= self.view.center;
        NSLog(@"%s",__func__);
    }
    return _likeImageAnim;
}
#pragma mark MomentActionDelegate
- (void)playVideoAtIndex:(NSIndexPath *)indexPath moment:(MomentModel *)moment
{
    [self playVideoFullScreen:indexPath moment:moment];
}
#pragma mark MomentActionDelegate
- (void)playVideoFullScreen:(NSIndexPath *)indexPath moment:(MomentModel *)moment
{
    VideoViewController *videoVC = [[VideoViewController alloc]initWithVideo:moment.video];
    videoVC.hidesBottomBarWhenPushed = YES;
//    videoVC.diasblePopGesture = YES;
    [self.navigationController pushViewController:videoVC animated:YES];
}


-(void)initPostBtn
{
    _postMomentBtn=[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth*0.85, ScreenHeight*0.75, 54, 54)];
    [_postMomentBtn setImage:[UIImage imageNamed:@"ic_edit_work"] forState:UIControlStateNormal];
    
    [_postMomentBtn sizeToFit];
    [_postMomentBtn addTarget:self action:@selector(gotoPostMomentVC:) forControlEvents:UIControlEventTouchUpInside];
    
    UIPanGestureRecognizer *panGes= [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panScroll:)];
    
    [_postMomentBtn addGestureRecognizer:panGes];
    [self.view addSubview:_postMomentBtn];
}

- (void)panScroll:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {//设置拖动范围
        CGPoint translation = [recognizer locationInView:self.postMomentBtn];
        CGPoint newCenter = CGPointMake(recognizer.view.center.x+ translation.x,
                                        recognizer.view.center.y + translation.y);
        newCenter.y = MIN(ScreenHeight-iPhone_Bottom_NavH, newCenter.y);
        newCenter.y = MAX(iPhone_Top_NavH+24, newCenter.y);//iPhone_Top_NavH-SegmentTitleViewHeight
        newCenter.x = MAX(30, newCenter.x);
        newCenter.x = MIN(ScreenWidth-30,newCenter.x);
        if (newCenter.y>CGRectGetHeight(self.view.frame)-30) {
            
            newCenter.y =CGRectGetHeight(self.view.frame)-30;
        }
        recognizer.view.center = newCenter;
        [recognizer setTranslation:CGPointZero inView:self.postMomentBtn];

    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {//可以在这里做一些复位处理
        
    }
}

-(void)gotoPostMomentVC:(id)sender
{
    PostMomentVC *postM= [[PostMomentVC alloc]init];
    postM.hidesBottomBarWhenPushed=YES;
    postM.callback=self;
    [self.navigationController pushViewController:postM animated:YES];
}

- (void)onCommentClick:(MomentModel *)moment
{
    for (MomentViewModel *viewModel in self.momentViewModels) {
        if ([moment.schoolCircleId isEqualToString:viewModel.momentModel.schoolCircleId]) {
            MomentDetailVC *detailVC = [[MomentDetailVC alloc]initWithViewModel:viewModel];
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
            break;
        }
    }
}

- (void)onMoreClick:(MomentModel *)moment
{
    UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    /*
     参数说明：
     Title:弹框的标题
     message:弹框的消息内容
     preferredStyle:弹框样式：UIAlertControllerStyleActionSheet
     */
   
    //2.添加按钮动作
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"分享到微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self onDeleteMomentClick:moment];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    //3.添加动作
    [alertSheet addAction:action1];
    if ([moment.teacherDo.teacherId isEqualToString:[self getUserId]]) {
        [alertSheet addAction:action2];
    }
    
    [alertSheet addAction:cancel];
    
    //4.显示sheet
    [self presentViewController:alertSheet animated:YES completion:nil];
}

-(void)onDeleteMomentClick:(MomentModel *)moment
{
    [self.dataController deleteMomentById:moment.schoolCircleId WithSuccess:^(UTResult * _Nonnull result) {
        MomentViewModel *viewModelToDel;
        for (MomentViewModel *vm in self.momentViewModels) {
            if([vm.momentModel.schoolCircleId isEqualToString:moment.schoolCircleId]){
                viewModelToDel = vm;
                break;
            }
        }
        if (viewModelToDel) {
            [self.momentViewModels removeObject:viewModelToDel];
            [self.tableView reloadData];
        }
    } failure:^(UTResult * _Nonnull result) {
        [self showAlertMessage:@"" title:result.failureResult];
    }];
}

#pragma mark SchollCircleDetailDelegate
- (void)deleteMoment:(MomentModel *)moment
{
    [self onDeleteMomentClick:moment];
}

#pragma mark PostMomentCallback
- (void)onPostSuccess
{
    [self.tableView.mj_header beginRefreshing];
}

-(UIView *)headView
{
    if (!_headView) {
        UIView *rootView = [MyRelativeLayout new];
        rootView.frame = CGRectMake(0, 0, ScreenWidth, 240);
        UILabel *tips = [UILabel new];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 230, 170)];
        NSString *picPath;
        picPath =[[NSBundle mainBundle] pathForResource:@"pic_no_moment" ofType:@"png"];
        [tips setText:@"暂无分享"];
        UIImage *img = [UIImage imageWithContentsOfFile:picPath];
        [imageView setImage:img];
        imageView.myCenterX=0;
        imageView.myCenterY=0;
        [tips sizeToFit];
        tips.textColor = [UIColor myColorWithHexString:@"#666666"];
        tips.font=[UIFont systemFontOfSize:14];
        tips.topPos.equalTo(imageView.bottomPos).offset(20);
        tips.myCenterX =0;
        
        [rootView addSubview:imageView];
        [rootView addSubview:tips];
        _headView = rootView;
    }
    
    return _headView;
}


@end
