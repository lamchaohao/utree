//
//  NoticeCellTableViewCell.h
//  utree
//
//  Created by 科研部 on 2019/8/29.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeModel.h"
#import "NoticeViewModel.h"
#import "FileObject.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NoticeMediaDelegate <NSObject>

-(void)playAudioClick:(FileObject *)audioFile;

-(void)openWebView:(NSString *)webUrl;

@end

@interface NoticeCell : UITableViewCell

@property(nonatomic,strong)UIImageView *headView;
@property(nonatomic,strong)UILabel *posterLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UIImageView *parentVisView;
@property(nonatomic,strong)UIImageView *feedbackView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *detailLabel;
@property(nonatomic,strong)UIButton *audioButton;
@property(nonatomic,strong)UIButton *webButton;
@property (nonatomic, strong)PYPhotosView *photosView;

@property(nonatomic,strong)NoticeViewModel *noticeViewModel;

@property(nonatomic,assign)id<NoticeMediaDelegate> mediaDelegate;

@end

NS_ASSUME_NONNULL_END
