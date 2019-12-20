//
//  HomeworkCell.h
//  utree
//
//  Created by 科研部 on 2019/11/26.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileObject.h"
#import "HomeworkViewModel.h"
#import "UTVideoButton.h"
NS_ASSUME_NONNULL_BEGIN

@protocol HomeworkMediaDelegate <NSObject>

-(void)playAudioClick:(FileObject *)audioFile;

-(void)openWebView:(NSString *)webUrl;

-(void)playVideoClick:(FileObject *)audioFile;

@end


@interface HomeworkCell : UITableViewCell


@property(nonatomic,strong)UIImageView *headView;
@property(nonatomic,strong)UILabel *posterLabel;
@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UIImageView *feedbackView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *subjectLabel;
@property(nonatomic,strong)UILabel *detailLabel;
@property(nonatomic,strong)UIButton *audioButton;
@property(nonatomic,strong)UIButton *webButton;
@property(nonatomic,strong)UTVideoButton *videoButton;
@property (nonatomic, strong)PYPhotosView *photosView;

@property(nonatomic,strong)HomeworkViewModel *taskViewModel;

@property(nonatomic,assign)id<HomeworkMediaDelegate> mediaDelegate;

@end

NS_ASSUME_NONNULL_END
