//
//  RecordView.m
//
//  Created by zhiwen jiang on 16/4/25.
//  Copyright (c) 2016年 FRITT. All rights reserved.
//

#import "RecordView.h"
#import "masonry.h"
#import <AVFoundation/AVFoundation.h>
#import "XHVoiceRecordHelper.h"
#import "XHAudioPlayerHelper.h"

@interface RecordView ()
{
    NSTimer *_timer;
    float timeCounter;
}

@property(nonatomic,strong)XHVoiceRecordHelper *recordHelper;
@property(nonatomic,strong)NSString *recordFilePath;

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UIImageView *recordImageView;
@property (strong, nonatomic) UIImageView *yinjieImageView;
@property (strong, nonatomic) UIView *maskView;
@property (nonatomic, strong) UILabel *titleLabel;
@property(nonatomic,strong)NSArray *yinjieImgArray;
@end

@implementation RecordView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.recordHelper = [[XHVoiceRecordHelper alloc]init];

    [self createYinjieImgArray];
    [self addSubview:self.recordImageView];
    [self addSubview:self.yinjieImageView];
    [self addSubview:self.maskView];
    [self addSubview:self.titleLabel];
    
    [self mas_remakeConstraints:^(MASConstraintMaker *make)
     {
         make.width.mas_equalTo (@(155));
         make.height.mas_equalTo (@(170));
     }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make)
    {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.height.mas_equalTo(@(16));
        make.bottom.equalTo(self.mas_bottom).with.offset(-5);
    }];
    
    [self.recordImageView mas_remakeConstraints:^(MASConstraintMaker *make)
     {
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(-34);
     }];
    
    [self.yinjieImageView mas_remakeConstraints:^(MASConstraintMaker *make)
     {
//         make.left.equalTo(self.recordImageView.mas_right).with.offset(10);
        make.top.equalTo(self.mas_top).with.offset(15);
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
//         make.bottom.equalTo(self.recordImageView.mas_bottom).with.offset(0);
//         make.height.equalTo(self.mas_height).with.offset(-80);
     }];

//    [self.maskView mas_remakeConstraints:^(MASConstraintMaker *make)
//     {
//         make.left.equalTo(self.recordImageView.mas_right).with.offset(10);
//         make.top.equalTo(self.yinjieImageView.mas_top).with.offset(0);
//        // make.height.mas_equalTo(0);
//     }];
    
}

#pragma mark - 私有方法
- (void)changeImage
{
    timeCounter +=0.2;
    [_recordHelper.recorder updateMeters];//更新测量值
    float avg = [_recordHelper.recorder averagePowerForChannel:0];
    float minValue = -70;
    float range = 70;
    float outRange = 100;
    if (avg < minValue)
    {
        avg = minValue;
    }
    float decibels = (avg + range) / range * outRange;
    int decibelsLevel =decibels/10-1;
    decibelsLevel<=0?decibelsLevel=0:decibelsLevel;
    decibelsLevel>=7?decibelsLevel=6:decibelsLevel;
    
    NSLog(@"recordView,decibels=%f,level=%d,imgName=%@,duration=%f",
          decibels,decibelsLevel,_yinjieImgArray[decibelsLevel],timeCounter);
   
    [self.yinjieImageView setImage:[UIImage imageNamed:[_yinjieImgArray objectAtIndex:decibelsLevel]]];

}


#pragma mark - 公有方法

- (void)startRecordVoice
{
    [_recordHelper.recorder deleteRecording];
    [_recordHelper.recorder record];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    self.recordFilePath = [path stringByAppendingPathComponent:@"utree_chat_audio_file.aac"];
    [self.recordHelper prepareRecordingWithPath:self.recordFilePath prepareRecorderCompletion:^BOOL{
        NSLog(@"%s",__func__);
        return YES;
    }];
    
    self.hidden = NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                              target:self
                                            selector:@selector(changeImage)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)cancelRecordVoice
{
    [_timer invalidate];
    _timer = nil;
    self.hidden = YES;
    [self.recordHelper cancelledDeleteWithCompletion:^{
         
    }];
}

- (void)endRecordVoice
{
    [_timer invalidate];
    _timer = nil;
    self.hidden = YES;
    [self.recordHelper stopRecordingWithStopRecorderCompletion:^{
        //StopRecorderCompletion
        [self.delegate recordFinish:self.recordFilePath duration: self.recordHelper.recordDuration];
    }];
}

- (void)updateCancelRecordVoice
{
    _yinjieImageView.hidden = YES;
    _titleLabel.text = @"松开手指，取消发送";
    _titleLabel.backgroundColor = [UIColor clearColor];
    _recordImageView.image = [UIImage imageNamed:@"chexiao"];
    [self.recordImageView mas_remakeConstraints:^(MASConstraintMaker *make)
     {
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(-34);
     }];
}

- (void)updateContinueRecordVoice
{
    _yinjieImageView.hidden = NO;
    _titleLabel.text = @"手指上滑，取消发送";
    _titleLabel.textColor=[UIColor myColorWithHexString:@"#CCCCCC"];
    _recordImageView.image = [UIImage imageNamed:@"yuyin"];
    [self.recordImageView mas_remakeConstraints:^(MASConstraintMaker *make)
     {
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(-34);
     }];
}

#pragma mark - Getters方法
- (UIImageView *)recordImageView
{
    if (!_recordImageView)
    {
        _recordImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _recordImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _recordImageView.image = [UIImage imageNamed:@"yuyin"];
    }
    return _recordImageView;
}

- (UIImageView *)yinjieImageView
{
    if (!_yinjieImageView)
    {
        _yinjieImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _yinjieImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _yinjieImageView.image = [UIImage imageNamed:@"yinjie_7"];
    }
    return _yinjieImageView;
}

- (void)createYinjieImgArray
{
    if (!_yinjieImgArray) {
        _yinjieImgArray = [NSArray arrayWithObjects:@"yinjie_1",@"yinjie_2",@"yinjie_3",@"yinjie_4",@"yinjie_5",@"yinjie_6",@"yinjie_7", nil];
    }
}

- (UIView *)maskView
{
    if (!_maskView)
    {
        _maskView = [[UIView alloc] initWithFrame:CGRectZero];
        _maskView.translatesAutoresizingMaskIntoConstraints = NO;
        _maskView.backgroundColor = [UIColor blueColor];
    }
    return _yinjieImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:10];
        _titleLabel.textColor=[UIColor myColorWithHexString:@"#CCCCCC"];
        _titleLabel.text = @"手指上滑，取消发送";
        _titleLabel.layer.cornerRadius = 5;
        _titleLabel.clipsToBounds = YES;
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

@end
