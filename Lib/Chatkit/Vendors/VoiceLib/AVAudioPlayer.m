//
//  AVAudioPlayer.m
//
//  Created by facc on 15/4/25.
//  Copyright © 2016年. All rights reserved.
//

#import "AVAudioPlayer.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ChatUntiles.h"
#import "NSString+MD5.h"

NSString *const kXMNAudioDataKey;

@interface XMAVAudioPlayer () <AVAudioPlayerDelegate,AVAudioSessionDelegate>
{
    AVAudioPlayer *_audioPlayer;
    NSOperationQueue *_audioDataOperationQueue;
}

/**
 *  语音缓存路径,以URLString的MD5编码为key保存
 */
@property (nonatomic, copy, readonly) NSString *cachePath;


@end

@implementation XMAVAudioPlayer
@synthesize cachePath = _cachePath;

+ (void)initialize
{
    //配置播放器配置
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error: nil];
    [[AVAudioSession sharedInstance] setDelegate:self];
}

+ (instancetype)sharePlayer
{
    static dispatch_once_t onceToken;
    static id shareInstance;
    dispatch_once(&onceToken, ^
    {
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

- (instancetype)init
{
    if ([super init])
    {
        //添加应用进入后台通知
        UIApplication *app = [UIApplication sharedApplication];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:app];
        
        _audioDataOperationQueue = [[NSOperationQueue alloc] init];
        _audioDataOperationQueue.name = @"com.fritt.AVAudipPlayer.loadAudioDataQueue";
        
        _index = NSUIntegerMax;
        
    }
    return self;
}

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIApplicationWillResignActiveNotification];
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
    
}

#pragma mark - 公有方法

- (void)playAudioWithURLString:(NSString *)URLString atIndex:(NSUInteger)index
{
    if (!URLString)
    {
        return;
    }
    
    //如果来自同一个URLString并且index相同,则直接取消
    if ([self.URLString isEqualToString:URLString] && self.index == index) {
        [self stopAudioPlayer];
        [self setAudioPlayerState:VoiceMessageStateCancel];
        return;
    }
    
    //TODO 从URL中读取音频data
    self.URLString = URLString;
    self.index = index;
    
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^
    {
        [self setAudioPlayerState:VoiceMessageStateDownloading];
        NSData *audioData = [self audioDataFromURLString:URLString atIndex:index];
        if (!audioData)
        {
            [self setAudioPlayerState:VoiceMessageStateCancel];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self playAudioWithData:audioData];
        });
    }];
    
    [blockOperation setName:[[NSString stringWithFormat:@"%@_%ld",self.URLString,self.index] MD5String]];
    
    [_audioDataOperationQueue addOperation:blockOperation];
    
}

- (void)cleanAudioCache
{
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:self.cachePath];
    for (NSString *file in files) {
        [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
    }
}

- (void)stopAudioPlayer
{
    if (_audioPlayer)
    {
        _audioPlayer.playing ? [_audioPlayer stop] : nil;
        _audioPlayer.delegate = nil;
        _audioPlayer = nil;
    }
}


#pragma mark - 私有方法

- (NSData *)audioDataFromURLString:(NSString *)URLString atIndex:(NSUInteger)index
{
    NSData *audioData;
    
    //1.检查URLString是本地文件还是网络文件
    if ([URLString hasPrefix:@"http"] || [URLString hasPrefix:@"https"])
    {
        //2.来自网络,先检查本地缓存,缓存key是URLString的MD5编码
        NSString *audioCacheKey = [URLString MD5String];
        
        //3.本地缓存存在->直接读取本地缓存   不存在->从网络获取数据,并且缓存
        if ([[NSFileManager defaultManager] fileExistsAtPath:[self.cachePath stringByAppendingPathComponent:audioCacheKey]])
        {
            audioData = [NSData dataWithContentsOfFile:[self.cachePath stringByAppendingPathComponent:audioCacheKey]];
        }
        else
        {
            audioData = [NSData dataWithContentsOfURL:[NSURL URLWithString:URLString]];
            [audioData writeToFile:[self.cachePath stringByAppendingPathComponent:audioCacheKey] atomically:YES];
        }
    }
    else
    {
        audioData = [NSData dataWithContentsOfFile:URLString];
    }
    
    //4.判断audioData是否读取成功,成功则添加对应的audioDataKey
    if (audioData)
    {
        objc_setAssociatedObject(audioData, &kXMNAudioDataKey, [[NSString stringWithFormat:@"%@_%ld",URLString,index] MD5String], OBJC_ASSOCIATION_COPY);
    }

    return audioData;
}

- (void)playAudioWithData:(NSData *)audioData
{
//    [self.delegate XMAVAudioPlayerBeiginLoadVoice];
    
    NSString *audioURLMD5String = objc_getAssociatedObject(audioData, &kXMNAudioDataKey);
    
    if (![[[NSString stringWithFormat:@"%@_%ld",self.URLString,self.index] MD5String] isEqualToString:audioURLMD5String])
    {
        return;
    }

    NSError *audioPlayerError;
    _audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:&audioPlayerError];
    if (!_audioPlayer || !audioData)
    {
        [self setAudioPlayerState:VoiceMessageStateCancel];
        return;
    }
    
    
    //开启红外感应 !!! 有bug
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityStateChanged:) name:UIDeviceProximityStateDidChangeNotification object:nil];
    
    _audioPlayer.volume = 1.0f;
    _audioPlayer.delegate = self;
    [_audioPlayer prepareToPlay];
//    [self.delegate XMAVAudioPlayerBeiginPlay];
    [self setAudioPlayerState:VoiceMessageStatePlaying];
    [_audioPlayer play];
}

- (void)cancelOperation
{
    for (NSOperation *operation in _audioDataOperationQueue.operations)
    {
        if ([operation.name isEqualToString:[[NSString stringWithFormat:@"%@_%ld",self.URLString,self.index] MD5String]])
        {
            [operation cancel];
            break;
        }
    }
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self setAudioPlayerState:VoiceMessageStateNormal];
//    [self.delegate XMAVAudioPlayerDidFinishPlay];
//    //近距离事件监听
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
    
    //延迟一秒将audioPlayer 释放
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .2f * NSEC_PER_SEC), dispatch_get_main_queue(), ^
    {
        [self stopAudioPlayer];
    });
    
}

#pragma mark - NSNotificationCenter Methods
- (void)applicationWillResignActive:(UIApplication *)application
{
//    [self.delegate XMAVAudioPlayerDidFinishPlay];
    
    [self cancelOperation];
    [self stopAudioPlayer];
    [self setAudioPlayerState:VoiceMessageStateCancel];
}

- (void)proximityStateChanged:(NSNotification *)notification
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else
    {
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}


#pragma mark - Getters方法

- (NSString *)cachePath
{
    if (!_cachePath)
    {
        _cachePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"com.fritt.Chat.audioCache"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:_cachePath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_cachePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return _cachePath;
}

#pragma mark - Setters方法

- (void)setURLString:(NSString *)URLString
{
    if (_URLString)
    {
        //说明当前有正在播放,或者正在加载的视频,取消operation(如果没有在执行任务),停止播放
        [self cancelOperation];
        [self stopAudioPlayer];
        [self setAudioPlayerState:VoiceMessageStateCancel];
    }
    _URLString = [URLString copy];
}

- (void)setAudioPlayerState:(VoiceMessageState)audioPlayerState
{
    _audioPlayerState = audioPlayerState;
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioPlayerStateDidChanged:forIndex:)])
    {
        [self.delegate audioPlayerStateDidChanged:_audioPlayerState forIndex:self.index];
    }else{
        NSLog(@"XMAVAudioPlayer has no delegate");
    }
    
    if (_audioPlayerState == VoiceMessageStateCancel || _audioPlayerState == VoiceMessageStateNormal)
    {
        _URLString = nil;
        _index = NSUIntegerMax;
    }
}

@end
