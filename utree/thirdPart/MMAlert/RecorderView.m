//
//  RecorderView.m
//  utree
//
//  Created by 科研部 on 2019/9/30.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "RecorderView.h"
#import <Masonry/Masonry.h>
#import "XHVoiceRecordHelper.h"
#import "XHAudioPlayerHelper.h"
#import "DACircularProgressView.h"
@interface RecorderView ()<LVRecordToolDelegate,XHAudioPlayerHelperDelegate>
@property(nonatomic,strong)XHVoiceRecordHelper *recordHelper;
@property(nonatomic,strong)DACircularProgressView *progressView;
@end
@implementation RecorderView

- (instancetype) init
{
    self = [super init];
    if ( self ){
         [self createView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
     if ( self ){
          [self createView];
     }
    
     return self;
}


- (void)showAlert {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAlert)]];
    //遮罩
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.5;
    }];
    [window addSubview:_contentView];
    
    self.contentView.transform = CGAffineTransformMakeTranslation(0.01, ScreenWidth);
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(0.01, 0.01);
    }];
}
 
- (void)dismissAlert {
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(0.01, ScreenWidth);
        self.contentView.alpha = 0.2;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.contentView removeFromSuperview];
    }];
}

// contentView 是通过懒加载实现的
- (UIView *)createContentView{
    if (!_contentView) {
        _contentView =[MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.frame = CGRectMake((ScreenWidth-340)/2, ScreenHeight-287, 340, 287);
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.opaque = YES;
        _contentView.layer.cornerRadius = 11;
        _contentView.clipsToBounds = YES;
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.borderWidth = MM_SPLIT_WIDTH;
        _contentView.layer.borderColor = [UIColor myColorWithHexString:PrimaryColor].CGColor;
        [self addSubview:_contentView];
    }
    return _contentView;
}

- (DACircularProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[DACircularProgressView alloc]initWithFrame:CGRectMake(0, 0, 92, 92)];
        _progressView.progressTintColor = [UIColor myColorWithHexString:PrimaryColor];
        _progressView.innerTintColor = [UIColor whiteColor];
        _progressView.trackTintColor=[UIColor myColorWithHexString:@"#E7E5E3"];
        _progressView.backgroundColor =[UIColor whiteColor];
//        _progressView.myTop=39;
//        _progressView.myBottom=29;
        _progressView.hidden = YES;
        _progressView.myCenterX=_progressView.myCenterY=0;
    }
    return _progressView;
}



-(void)createView
{
    [self createContentView];
     __block RecorderView *strongBlock = self;
    self.recordHelper = [[XHVoiceRecordHelper alloc]init];
    [self.recordHelper setRecordProgress:^(float progress) {
        [strongBlock.progressView setProgress:progress];
        int maxSecond = (int)(120*progress);
        int minute = maxSecond/60;
        int second = (maxSecond-60)>0?(maxSecond-60):maxSecond;
        int digitalSecond = second/10;
        int unitsSecond =maxSecond%10;
        
        [strongBlock.topLabel setText:[NSString stringWithFormat:@"0%d:%d%d",minute,digitalSecond,unitsSecond]];
        [strongBlock.topLabel sizeToFit];
    }];
    
    [self.recordHelper setMaxTimeStopRecorderCompletion:^{
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePath = [path stringByAppendingPathComponent:@"utree_record.aac"];
        [strongBlock.delegate recordOver:filePath duration:strongBlock.recordHelper.recordDuration];
        [strongBlock dismissAlert];
    }];
    
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.2;
    MyFrameLayout *recordLayout = [MyFrameLayout new];
    recordLayout.frame = CGRectMake(0, 0, 92, 92);
    recordLayout.myCenterY=recordLayout.myCenterX=0;
    recordLayout.myTop=39;
    recordLayout.myBottom=29;
    
    _topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    _topLabel.textColor = [UIColor myColorWithHexString:SecondTextColor];
    _recordBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 90)];
    [_recordBtn setImage:[UIImage imageNamed:@"btn_record_prepared"] forState:UIControlStateNormal];
    [_recordBtn addTarget:self action:@selector(startRecordingAudio:) forControlEvents:UIControlEventTouchUpInside];
    _bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    _bottomLabel.textColor = [UIColor myColorWithHexString:SecondTextColor];
    
    _topLabel.myCenterX=_topLabel.myCenterY=0;
    _recordBtn.myCenterX=_recordBtn.myCenterY=0;
    _bottomLabel.myCenterX=_bottomLabel.myCenterY=0;
    _topLabel.myTop=40;
//    _recordBtn.myTop=39;
//    _recordBtn.myBottom=29;
    _bottomLabel.myBottom=53;
    
    [_topLabel setText:@"时长不超过2分钟"];
    [_topLabel sizeToFit];
    [_bottomLabel setText:@"点击开始录音"];
    [_bottomLabel sizeToFit];
    
    [recordLayout addSubview:self.progressView];
    [recordLayout addSubview:_recordBtn];
    
    [_contentView addSubview:_topLabel];
    [_contentView addSubview:recordLayout];
    [_contentView addSubview:_bottomLabel];
    

    
}

-(void)startRecordingAudio:(id)sender
{
     
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [path stringByAppendingPathComponent:@"utree_record.aac"];
    [self.recordHelper prepareRecordingWithPath:filePath prepareRecorderCompletion:^BOOL{
        NSLog(@"%s",__func__);
        [self startRecordReal];
        return YES;
    }];

}


-(void)startRecordReal
{
    [self.recordHelper startRecordingWithStartRecorderCompletion:^{
           NSLog(@"%s",__func__);
        self.progressView.hidden = NO;
           [self.recordBtn setImage:[UIImage imageNamed:@"btn_recorder_stop"] forState:UIControlStateNormal];
           [self.recordBtn addTarget:self action:@selector(stopRecording:) forControlEvents:UIControlEventTouchUpInside];
           [self.bottomLabel setText:@"点击结束录音"];
       }];
}

-(void)stopRecording:(id)sender
{
    [self.recordHelper stopRecordingWithStopRecorderCompletion:^{
        NSLog(@"录音完成！get");
//        self.recordHelper.recordDuration
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePath = [path stringByAppendingPathComponent:@"utree_record.aac"];
        [self.delegate recordOver:filePath duration:self.recordHelper.recordDuration];
        [self dismissAlert];
    }];
    
}


@end
