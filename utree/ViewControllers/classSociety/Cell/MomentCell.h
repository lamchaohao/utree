//
//  MomentCell.h
//  utree
//
//  Created by 科研部 on 2019/8/28.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MomentModel.h"
#import "MomentViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol MomentActionDelegate <NSObject>
@optional

-(void)onLikeClick:(NSString *)momentId showAnim:(BOOL)needShow;

-(void)onMoreClick:(MomentModel *)moment;

-(void)onCommentClick:(MomentModel *)moment;

-(void)playVideoAtIndex:(NSIndexPath *)indexPath moment:(MomentModel *)moment;

-(void)playVideoFullScreen:(NSIndexPath *)indexPath moment:(MomentModel *)moment;

-(void)resizeVideoView:(NSIndexPath *)indexPath;

@end

@interface MomentCell : UITableViewCell

@property(nonatomic,strong)UIImageView *headView;
@property(nonatomic,strong)UILabel *posterLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *detailLabel;
@property(nonatomic,strong)PYPhotosView *photosView;
@property(nonatomic,strong)UIImageView *videoView;
@property(nonatomic,strong)UIButton *playVideoBtn;
@property(nonatomic,strong)UIButton *likeButton;
@property(nonatomic,strong)UIButton *commentBtn;
@property(nonatomic,strong)MomentViewModel *viewModel;
@property (nonatomic, assign) id<MomentActionDelegate> actionDelegate;
-(void)setViewModelData:(MomentViewModel *)viewModel atIndex:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
