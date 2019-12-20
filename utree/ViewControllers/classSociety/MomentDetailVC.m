//
//  MomentDetailVC.m
//  utree
//
//  Created by 科研部 on 2019/11/20.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "MomentDetailVC.h"
#import "MomentDetailView.h"
#import "MomentDC.h"
#import "WrapCommentListModel.h"
#import "ZBTextField.h"
#import "MomentCommentDC.h"
#import "ComplainCommentVC.h"
@interface MomentDetailVC ()<MomentDetailDelegate>
@property(nonatomic,strong)MomentDetailView *rootView;
@property(nonatomic,strong)MomentDC *momentDC;
@property(nonatomic,strong)MomentCommentDC *dataController;
@property(nonatomic,strong)WrapCommentListModel *wrapListModel;


@end

@implementation MomentDetailVC

- (instancetype)initWithViewModel:(MomentViewModel *)viewModel
{
    self = [super init];
    if (self) {
        self.momentDC = [[MomentDC alloc]init];
        self.dataController = [[MomentCommentDC alloc]init];
        self.momentViewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"班级圈正文";
    MomentDetailView *momentView = [[MomentDetailView alloc]initWithFrame:self.view.frame andViewModel:self.momentViewModel];
    momentView.delegate = self;
    [self.view addSubview:momentView];
    [self.player addPlayerViewToContainerView:momentView.videoFrameLayout];
    self.rootView = momentView;
    [self loadCommentDataFirstTime];
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    if (!parent) {
        if (self.detailVCPopCallback) {
            self.detailVCPopCallback();
        }
    }
}


- (void)onPlayVideoClick
{
    if (self.detailVCPlayCallback) {
        self.detailVCPlayCallback();
    }
    [self.player addPlayerViewToContainerView:self.rootView.videoFrameLayout];
}

- (void)requestLikeMoment
{
    
    [self.momentDC requestLikeMoment:self.momentViewModel.momentModel.schoolCircleId WithSuccess:^(UTResult * _Nonnull result) {
        BOOL isLike = self.momentViewModel.momentModel.hasLike.boolValue;
        self.momentViewModel.momentModel.hasLike = [NSNumber numberWithBool:!isLike];
        [self.rootView likeMomentActionResult:self.momentViewModel.momentModel.hasLike];
        
    } failure:^(UTResult * _Nonnull result) {
        [self showAlertMessage:@"" title:result.failureResult];
    }];
}

- (void)sendComment:(NSString *)comment
{
    [self.dataController sendComment:comment toMoment:self.momentViewModel.momentModel.schoolCircleId withSuccess:^(UTResult * _Nonnull result) {
        [self loadCommentDataFirstTime];
    } failure:^(UTResult * _Nonnull result) {
        [self showAlertMessage:@"" title:result.failureResult];
    }];
}

- (void)loadCommentDataFirstTime
{
    [self.dataController requestCommentFirstTimeWithId:self.momentViewModel.momentModel.schoolCircleId withSuccess:^(UTResult * _Nonnull result) {
        
        WrapCommentListModel *wrapModel = result.successResult;
        self.wrapListModel = wrapModel;
        if (wrapModel) {
            self.momentViewModel.momentModel.likeCount=wrapModel.likeCount;
            self.momentViewModel.momentModel.commentCount=wrapModel.commentCount;
            self.momentViewModel.momentModel.hasLike =wrapModel.isLike;
            [self.rootView refreshFinish:wrapModel.list];
        
        }
        
    } failure:^(UTResult * _Nonnull result) {
        [self.rootView makeToast:result.failureResult];
    }];
}


- (void)loadMoreData
{
    if (self.wrapListModel) {
        CommentModel *lastComment = [self.wrapListModel.list lastObject];
        [self.dataController requestCommentMoreWithId:self.momentViewModel.momentModel.schoolCircleId lastCommentId:lastComment.commentId withSuccess:^(UTResult * _Nonnull result)
        {
            WrapCommentListModel *wrapModel = result.successResult;
            self.wrapListModel = wrapModel;
                if (wrapModel)
                {
                    [self.rootView loadMoreFinish:wrapModel.list];
                }
        } failure:^(UTResult * _Nonnull result)
        {
            [self.rootView makeToast:result.failureResult];
        }];
    }
    
}

-(void)onMoreButtonClick
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
        if ([self.delegate respondsToSelector:@selector(deleteMoment:)]) {
            [self.delegate deleteMoment:self.momentViewModel.momentModel];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    //3.添加动作
    [alertSheet addAction:action1];

    if ([self.momentViewModel.momentModel.teacherDo.teacherId isEqualToString:[self getUserId]]) {
        [alertSheet addAction:action2];
    }

    [alertSheet addAction:cancel];

    //4.显示sheet
    [self presentViewController:alertSheet animated:YES completion:nil];
}


-(void)onCommentClickAndShowOption:(CommentModel *)comment
{
    UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        /*
         参数说明：
         Title:弹框的标题
         message:弹框的消息内容
         preferredStyle:弹框样式：UIAlertControllerStyleActionSheet
         */
       
    //2.添加按钮动作
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"投诉" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        ComplainCommentVC *complainVC = [[ComplainCommentVC alloc]initWithCommentId:comment.commentId];
        [self.navigationController pushViewController:complainVC animated:YES];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self onDeleteComment:comment];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    //3.添加动作
    if ([comment.commentator isEqualToString:[self getUserId]]) {
        [alertSheet addAction:action2];
    }else{
        //投诉
        [alertSheet addAction:action1];
    }

    [alertSheet addAction:cancel];

    //4.显示sheet
    [self presentViewController:alertSheet animated:YES completion:nil];
    
}

-(void)onDeleteComment:(CommentModel *)comment
{
    [self.dataController deleteCommentById:comment.commentId WithSuccess:^(UTResult * _Nonnull result) {
        [self loadCommentDataFirstTime];
    } failure:^(UTResult * _Nonnull result) {
        [self showAlertMessage:@"" title:result.failureResult];
    }];
}

@end