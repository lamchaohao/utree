//
//  WorkHeaderView.h
//  utree
//
//  Created by 科研部 on 2019/12/2.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "FileObject.h"
#import "HomeworkViewModel.h"
#import "UTVideoButton.h"
#import "NoticeModel.h"
#import "WorkHeaderViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol WorkMediaDelegate <NSObject>

-(void)playAudioClick:(FileObject *)audioFile;

-(void)openWebView:(NSString *)webUrl;

-(void)playVideoClick:(FileObject *)audioFile;

@end

@interface WorkHeaderView : UIView
@property(nonatomic,strong)UIImageView *bgView;
@property(nonatomic,strong)UIImageView *headView;
@property(nonatomic,strong)UILabel *posterLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UIButton *classListBtn;

@property(nonatomic,strong)UIImageView *feedbackView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *subjectLabel;
@property(nonatomic,strong)UILabel *detailLabel;
@property(nonatomic,strong)UIButton *audioButton;
@property(nonatomic,strong)UIButton *webButton;
@property(nonatomic,strong)UTVideoButton *videoButton;
@property (nonatomic, strong)PYPhotosView *photosView;

@property(nonatomic,strong)WorkHeaderViewModel *viewModel;

-(void)setTaskModel:(HomeworkModel *)taskModel;

- (instancetype)initWithFrame:(CGRect)frame viewModel:(WorkHeaderViewModel *)vm;

@property(nonatomic,assign)id<WorkMediaDelegate> mediaDelegate;

-(void)setClassLabelStr:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
