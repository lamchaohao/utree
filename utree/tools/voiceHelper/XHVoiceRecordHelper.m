//
//  XHVoiceRecordHelper.m
//  utree
//
//  Created by 科研部 on 2019/9/30.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "XHVoiceRecordHelper.h"
#import "XHMacro.h"

@interface XHVoiceRecordHelper () <AVAudioRecorderDelegate> {
    NSTimer *_timer;
    
    BOOL _isPause;
    
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
    UIBackgroundTaskIdentifier _backgroundIdentifier;
#endif
}

@property (nonatomic, copy, readwrite) NSString *recordPath;
@property (nonatomic, readwrite) NSTimeInterval currentTimeInterval;

@end

@implementation XHVoiceRecordHelper

- (id)init {
    self = [super init];
    if (self) {
        self.maxRecordTime = kVoiceRecorderTotalTime;
        self.recordDuration = @"0";
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
        _backgroundIdentifier = UIBackgroundTaskInvalid;
#endif
    }
    return self;
}

- (void)dealloc {
    [self stopRecord];
    self.recordPath = nil;
    [self stopBackgroundTask];
}

- (void)startBackgroundTask {
    [self stopBackgroundTask];
    
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
    _backgroundIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self stopBackgroundTask];
    }];
#endif
}

- (void)stopBackgroundTask {
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
    if (_backgroundIdentifier != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:_backgroundIdentifier];
        _backgroundIdentifier = UIBackgroundTaskInvalid;
    }
#endif
}

- (void)resetTimer {
    if (!_timer)
        return;
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
}

- (void)cancelRecording {
    if (!_recorder)
        return;
    
    if (self.recorder.isRecording) {
        [self.recorder stop];
    }
    
    self.recorder = nil;
}

- (void)stopRecord {
    [self cancelRecording];
    [self resetTimer];
}

- (void)prepareRecordingWithPath:(NSString *)path prepareRecorderCompletion:(XHPrepareRecorderCompletion)prepareRecorderCompletion {
    
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self->_isPause = NO;
        
        NSError *error = nil;
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&error];
        if(error) {
            DLog(@"audioSession: %@ %ld %@", [error domain], (long)[error code], [[error userInfo] description]);
            return;
        }
        
        error = nil;
        [audioSession setActive:YES error:&error];
        if(error) {
            DLog(@"audioSession: %@ %ld %@", [error domain], (long)[error code], [[error userInfo] description]);
            return;
        }
        
        NSMutableDictionary * recordSetting = [NSMutableDictionary dictionary];
        [recordSetting setValue : [NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
        [recordSetting setValue:[NSNumber numberWithFloat:16000.0] forKey:AVSampleRateKey];
        [recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
//        // 音频格式
//        recordSetting[AVFormatIDKey] = @(kAudioFormatAppleIMA4);
//        // 录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
//        recordSetting[AVSampleRateKey] = @(44100);
//        // 音频通道数 1 或 2
//        recordSetting[AVNumberOfChannelsKey] = @(1);
//        // 线性音频的位深度  8、16、24、32
//        recordSetting[AVLinearPCMBitDepthKey] = @(8);
//        //录音的质量
//        recordSetting[AVEncoderAudioQualityKey] = [NSNumber numberWithInt:AVAudioQualityHigh];
        // 3.设置录音的一些参数
//        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
//        // 音频格式
//        setting[AVFormatIDKey] = @(kAudioFormatAppleIMA4);
//        // 录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
//        setting[AVSampleRateKey] = @(44100);
//        // 音频通道数 1 或 2
//        setting[AVNumberOfChannelsKey] = @(1);
//        // 线性音频的位深度  8、16、24、32
//        setting[AVLinearPCMBitDepthKey] = @(8);
//        //录音的质量
//        setting[AVEncoderAudioQualityKey] = [NSNumber numberWithInt:AVAudioQualityHigh];
        
        if (weakSelf) {
            STRONGSELF
            strongSelf.recordPath = path;
            error = nil;
            
            if (strongSelf.recorder) {
                [strongSelf cancelRecording];
            } else {
                strongSelf.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:strongSelf.recordPath] settings:recordSetting error:&error];
        
                strongSelf.recorder.delegate = strongSelf;
                [strongSelf.recorder prepareToRecord];
                strongSelf.recorder.meteringEnabled = YES;
                [strongSelf.recorder recordForDuration:(NSTimeInterval) 160];
                [strongSelf startBackgroundTask];
            }
            
            if(error) {
                DLog(@"audioSession: %@ %ld %@", [error domain], (long)[error code], [[error userInfo] description]);
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //上層如果傳會來說已經取消了, 那這邊就做原先取消的動作
                if (!prepareRecorderCompletion()) {
                    [strongSelf cancelledDeleteWithCompletion:^{
                    }];
                }
            });
        }
    });
}

- (void)startRecordingWithStartRecorderCompletion:(XHStartRecorderCompletion)startRecorderCompletion {
    if ([_recorder record]) {
        [self resetTimer];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
        if (startRecorderCompletion)
            dispatch_async(dispatch_get_main_queue(), ^{
                startRecorderCompletion();
            });
    }
}

-(void)resumeRecordingWithResumeRecorderCompletion:(XHResumeRecorderCompletion)resumeRecorderCompletion {
    _isPause = NO;
    if (_recorder) {
        if ([_recorder record]) {
            dispatch_async(dispatch_get_main_queue(), resumeRecorderCompletion);
        }
    }
}

- (void)pauseRecordingWithPauseRecorderCompletion:(XHPauseRecorderCompletion)pauseRecorderCompletion {
    _isPause = YES;
    if (_recorder) {
        [_recorder pause];
    }
    if (!_recorder.isRecording)
        dispatch_async(dispatch_get_main_queue(), pauseRecorderCompletion);
}

- (void)stopRecordingWithStopRecorderCompletion:(XHStopRecorderCompletion)stopRecorderCompletion {
    _isPause = NO;
    [self stopBackgroundTask];
    [self stopRecord];
    [self getVoiceDuration:_recordPath];
    dispatch_async(dispatch_get_main_queue(), stopRecorderCompletion);
}

-(void)cancelledDeleteWithCompletion:(XHCancellRecorderDeleteFileCompletion)cancelledDeleteCompletion {
    
    _isPause = NO;
    [self stopBackgroundTask];
    [self stopRecord];
    
    if (self.recordPath) {
        // 删除目录下的文件
        NSFileManager *fileManeger = [NSFileManager defaultManager];
        if ([fileManeger fileExistsAtPath:self.recordPath]) {
            NSError *error = nil;
            [fileManeger removeItemAtPath:self.recordPath error:&error];
            if (error) {
                DLog(@"error :%@", error.description);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                cancelledDeleteCompletion();
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                cancelledDeleteCompletion();
            });
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            cancelledDeleteCompletion();
        });
    }
}

- (void)updateMeters {
    if (!_recorder)
        return;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self->_recorder updateMeters];
        
        self.currentTimeInterval = self.recorder.currentTime;
        
        if (!self->_isPause) {
            float progress = self.currentTimeInterval / self.maxRecordTime * 1.0;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.recordProgress) {
                    self.recordProgress(progress);
                }
            });
        }
        
        float peakPower = [self->_recorder averagePowerForChannel:0];
        double ALPHA = 0.015;
        double peakPowerForChannel = pow(10, (ALPHA * peakPower));
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新扬声器
            if (self.peakPowerForChannel) {
                self.peakPowerForChannel(peakPowerForChannel);
            }
        });
        
        if (self.currentTimeInterval > self.maxRecordTime) {
            self->_isPause = NO;
            [self stopBackgroundTask];
            [self stopRecord];
            [self getVoiceDuration:self.recordPath];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.maxTimeStopRecorderCompletion();
            });
        }
    });
}

- (void)getVoiceDuration:(NSString*)recordPath {
    NSError *error = nil;
    if(!recordPath){
        self.recordDuration = [NSString stringWithFormat:@"%.1f", 0.0];
        return ;
    }
    AVAudioPlayer *play = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:recordPath] error:&error];
    if (error) {
        DLog(@"recordPath：%@ error：%@", recordPath, error);
        self.recordDuration = @"";
    } else {
        DLog(@"时长:%f", play.duration);
        self.recordDuration = [NSString stringWithFormat:@"%d",(int)(play.duration)];
    }
}


-(BOOL)checkPermission{
    
//    AVAudioSessionRecordPermission permission = [[AVAudioSession sharedInstance] recordPermission];
//    return permission == AVAudioSessionRecordPermissionGranted;
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0) {
        AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
         if (videoAuthStatus == AVAuthorizationStatusNotDetermined) {// 未询问用户是否授权
             AVAudioSession *audioSession = [AVAudioSession sharedInstance];
             if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
                 [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                     if (granted) {
                         bCanRecord = YES;
                     } else {
                         bCanRecord = NO;
                     }
                 }];
             }
         } else if(videoAuthStatus == AVAuthorizationStatusRestricted || videoAuthStatus == AVAuthorizationStatusDenied) {
            // 未授权
//            [self showSetAlertView];
             NSLog(@"未授权");
             bCanRecord = NO;

        } else{
            // 已授权
            NSLog(@"已授权");
        }
    }
    return bCanRecord;
}


@end
