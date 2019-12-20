//
//  PlayVideoView.h
//  utree
//
//  Created by 科研部 on 2019/11/27.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileObject.h"
NS_ASSUME_NONNULL_BEGIN

@interface PlayVideoView : UIView
@property (nonatomic, strong) UIButton *backView;
@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) UIButton *likeBtn;

@property (nonatomic, strong) UIButton *commentBtn;

@property (nonatomic, strong) UIButton *shareBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) UIView *effectView;

- (void)setVideoData:(FileObject *)data;

@end

NS_ASSUME_NONNULL_END
