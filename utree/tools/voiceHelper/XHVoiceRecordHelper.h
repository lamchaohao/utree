//
//  XHVoiceRecordHelper.h
//  utree
//
//  Created by 科研部 on 2019/9/30.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL(^XHPrepareRecorderCompletion)();
typedef void(^XHStartRecorderCompletion)();
typedef void(^XHStopRecorderCompletion)();
typedef void(^XHPauseRecorderCompletion)();
typedef void(^XHResumeRecorderCompletion)();
typedef void(^XHCancellRecorderDeleteFileCompletion)();
typedef void(^XHRecordProgress)(float progress);
typedef void(^XHPeakPowerForChannel)(float peakPowerForChannel);


@interface XHVoiceRecordHelper : NSObject

@property (nonatomic, copy) XHStopRecorderCompletion maxTimeStopRecorderCompletion;
@property (nonatomic, copy) XHRecordProgress recordProgress;
@property (nonatomic, copy) XHPeakPowerForChannel peakPowerForChannel;
@property (nonatomic, copy, readonly) NSString *recordPath;
@property (nonatomic, copy) NSString *recordDuration;
@property (nonatomic) float maxRecordTime; // 默认 60秒为最大
@property (nonatomic, readonly) NSTimeInterval currentTimeInterval;

- (void)prepareRecordingWithPath:(NSString *)path prepareRecorderCompletion:(XHPrepareRecorderCompletion)prepareRecorderCompletion;
- (void)startRecordingWithStartRecorderCompletion:(XHStartRecorderCompletion)startRecorderCompletion;
- (void)pauseRecordingWithPauseRecorderCompletion:(XHPauseRecorderCompletion)pauseRecorderCompletion;
- (void)resumeRecordingWithResumeRecorderCompletion:(XHResumeRecorderCompletion)resumeRecorderCompletion;
- (void)stopRecordingWithStopRecorderCompletion:(XHStopRecorderCompletion)stopRecorderCompletion;
- (void)cancelledDeleteWithCompletion:(XHCancellRecorderDeleteFileCompletion)cancelledDeleteCompletion;

-(BOOL)checkPermission;

@end
