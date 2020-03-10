//
//  VideoViewController.m
//  utree
//
//  Created by 科研部 on 2019/11/27.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "VideoViewController.h"
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFIJKPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import "UIImageView+ZFCache.h"
#import "ZFUtilities.h"
#import <ZFPlayer/UIView+ZFFrame.h>
#import "PlayVideoView.h"

@interface VideoViewController ()
@property(nonatomic, strong) ZFPlayerController *player;
@property(nonatomic, strong)PlayVideoView *playVideoView;
@property(nonatomic, strong)FileObject *videoFile;
@property(nonatomic, strong)ZFPlayerControlView *controlView;

@end

@implementation VideoViewController

- (instancetype)initWithVideo:(FileObject *)video
{
    self = [super init];
    if (self) {
        self.videoFile = video;

    }
    return self;
}


- (void)viewDidLoad
{

    [super viewDidLoad];
    self.playVideoView = [[PlayVideoView alloc]initWithFrame:self.view.frame];
    [self.playVideoView.backView addTarget:self action:@selector(quitViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.playVideoView setVideoData:self.videoFile];
    [self.view addSubview:self.playVideoView];
    [self initPlayer];
    [self startPlayVideo];
    
}

-(void)startPlayVideo
{
    [self.player addPlayerViewToContainerView:self.playVideoView.coverImageView];
    [self.player playTheIndex:0];
    [self.controlView showTitle:@"" coverURLString:self.videoFile.minPath fullScreenMode:ZFFullScreenModeAutomatic];
}

-(void)initPlayer
{
    ZFIJKPlayerManager *playerManager = [[ZFIJKPlayerManager alloc] init];
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.playVideoView.coverImageView];
    
    self.player.assetURLs = [NSArray arrayWithObject:[NSURL URLWithString:self.videoFile.path]];
    //禁用手势功能
//    self.player.disableGestureTypes = ZFPlayerDisableGestureTypesDoubleTap | ZFPlayerDisableGestureTypesPan | ZFPlayerDisableGestureTypesPinch;
    self.player.pauseWhenAppResignActive = NO;
    self.player.allowOrentitaionRotation = YES;
    self.player.WWANAutoPlay = YES;
    self.player.controlView = self.controlView;
    /// 1.0是完全消失时候
    self.player.playerDisapperaPercent = 1.0;
    
    @weakify(self)
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self.player.currentPlayerManager replay];
    };
    
    self.player.presentationSizeChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, CGSize size) {
        @strongify(self)
        if (size.width >= size.height) {
            self.player.currentPlayerManager.scalingMode = ZFPlayerScalingModeAspectFit;
        } else {
            self.player.currentPlayerManager.scalingMode = ZFPlayerScalingModeAspectFill;
        }
    };
}

-(void)quitViewController:(id)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.player.viewControllerDisappear = NO;
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
    self.navigationController.navigationBar.hidden = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    /// 如果只是支持iOS9+ 那直接return NO即可，这里为了适配iOS8
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotate {
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.autoHiddenTimeInterval = 5;
        _controlView.autoFadeTimeInterval = 0.5;
        _controlView.prepareShowLoading = YES;
        _controlView.horizontalPanShowControlView = NO;
        _controlView.prepareShowControlView = YES;
    }
    return _controlView;
}

@end
