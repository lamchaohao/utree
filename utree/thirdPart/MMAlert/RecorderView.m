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
@interface RecorderView ()<LVRecordToolDelegate,XHAudioPlayerHelperDelegate>
@property(nonatomic,strong)XHVoiceRecordHelper *recordHelper;
@property(nonatomic,strong)NSURL *recordFileUrl;
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



-(void)createView
{
    [self createContentView];
    self.recordHelper = [[XHVoiceRecordHelper alloc]init];

    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.2;

    _topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    _topLabel.textColor = [UIColor myColorWithHexString:SecondTextColor];
    _recordBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 94, 94)];
    [_recordBtn setImage:[UIImage imageNamed:@"btn_record_prepared"] forState:UIControlStateNormal];
    [_recordBtn addTarget:self action:@selector(startRecordingAudio:) forControlEvents:UIControlEventTouchUpInside];
    _bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    _bottomLabel.textColor = [UIColor myColorWithHexString:SecondTextColor];
    
    _topLabel.myCenterY=0;
    _recordBtn.myCenterY=0;
    _bottomLabel.myCenterY=0;
    _topLabel.myCenterX=0;
    _recordBtn.myCenterX=0;
    _bottomLabel.myCenterX=0;
    _topLabel.myTop=40;
    _recordBtn.myTop=39;
    _recordBtn.myBottom=29;
    _bottomLabel.myBottom=53;
    
    [_topLabel setText:@"时长不超过2分钟"];
    [_topLabel sizeToFit];
    [_bottomLabel setText:@"点击开始录音"];
    [_bottomLabel sizeToFit];

    [_contentView addSubview:_topLabel];
    [_contentView addSubview:_recordBtn];
    [_contentView addSubview:_bottomLabel];
    

    
}

-(void)startRecordingAudio:(id)sender
{
//    if(![self.recordHelper checkPermission]){
//        //跳入当前App设置界面
//              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//    };
//
//    [self.recordHelper prepareRecordingWithPath:filePath prepareRecorderCompletion:^BOOL{
//        NSLog(@"prepareRecordingWithPath");
//        [self startRecordReal];
//        return YES;
//    }];
     
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [path stringByAppendingPathComponent:@"utree_record.aac"];
    self.recordFileUrl = [NSURL fileURLWithPath:filePath];
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
