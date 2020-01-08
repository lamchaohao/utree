//
//  MomentDetailView.h
//  utree
//
//  Created by 科研部 on 2019/11/20.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MomentViewModel.h"
#import "CommentModel.h"
#import "JXPagerView.h"
#import "JXCategoryTitleView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MomentDetailDelegate <NSObject>


-(void)requestLikeMoment;

-(void)sendComment:(NSString *)comment;

-(void)loadCommentDataFirstTime;

-(void)loadMoreData;

-(void)onPlayVideoClick;

-(void)onCommentClickAndShowOption:(CommentModel *)comment;

-(void)onMoreButtonClick;
@end

@interface MomentDetailView : MyFrameLayout
@property(nonatomic,strong)UIImageView *headView;
@property(nonatomic,strong)UILabel *posterLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *detailLabel;
@property(nonatomic,strong)PYPhotosView *photosView;
@property(nonatomic,strong)UIImageView *videoView;
@property(nonatomic,strong)MyFrameLayout *videoFrameLayout;
@property(nonatomic,strong)UIButton *likeButton;
@property(nonatomic,strong)UIButton *commentBtn;
@property(nonatomic,strong)MomentViewModel *viewModel;

@property(nonatomic,assign)id<MomentDetailDelegate> delegate;
-(void)refreshFinish:(NSArray *)commentList;

-(void)loadMoreFinish:(NSArray *)addictionalList;

-(void)likeMomentActionResult:(NSNumber *)hasLike;



- (instancetype)initWithFrame:(CGRect)frame andViewModel:(MomentViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
