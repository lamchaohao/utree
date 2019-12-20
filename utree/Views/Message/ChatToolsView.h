//
//  ChatToolsView.h
//  utree
//
//  Created by 科研部 on 2019/12/13.
//  Copyright © 2019 科研部. All rights reserved.
//

#define kMaxHeight          60.0f
#define kMinHeight          45.0f
#define kFunctionViewHeight 210.0f

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ChatToolViewShowType)
{
    ChatToolViewShowNothing,   /**< 不显示functionView */
    ChatToolViewShowFace,      /**< 显示表情View */
    ChatToolViewShowVoice,     /**< 显示录音view */
    ChatToolViewShowMore,      /**< 显示更多view */
    ChatToolViewShowKeyboard,  /**< 显示键盘 */
};

@protocol ChatToolViewDelegate;

@interface ChatToolsView : UIView
@property (assign, nonatomic) CGFloat superViewHeight;

@property (assign, nonatomic) CGFloat superViewWidth;

@property (weak, nonatomic) id<ChatToolViewDelegate> delegate;

-(void)endInputing;

@end


@protocol ChatToolViewDelegate <NSObject>

@optional

/**
 *  开始录音
 */
- (void)startRecordVoice;

/**
 *  取消录音
 */
- (void)cancelRecordVoice;

/**
 *  录音结束
 */
- (void)endRecordVoice;

/**
 *  更新录音显示状态,手指向上滑动后提示松开取消录音
 */
- (void)updateCancelRecordVoice;

/**
 *  更新录音状态,手指重新滑动到范围内,提示向上取消录音
 */
- (void)updateContinueRecordVoice;

/**
 *  chatBarFrame改变回调
 *
 */
- (void)chatBarFrameDidChange:(ChatToolsView *)chatBar frame:(CGRect)frame;


/**
 *  发送图片信息,支持多张图片
 *
 *  @param pictures 需要发送的图片信息
 */
- (void)chatBar:(ChatToolsView *)chatBar sendPictures:(NSArray *)pictures imageType:(BOOL)isGif;

/**
 *  发送视频信息,支持多张图片
 *
 *  @param videos 需要发送的视频信息
 */
- (void)chatBar:(ChatToolsView *)chatBar sendVideos:(NSArray *)videos;


/**
 *  发送普通的文字信息,可能带有表情
 *  @param message 需要发送的文字信息
 */
- (void)chatBar:(ChatToolsView *)chatBar sendMessage:(NSString *)message;

/**
 *  音视频呼叫
 *
 *  @param calltime 呼叫时长，单位为秒
 *  @param isVideo  NO:音频呼叫; YES:视频呼叫
 */
- (void)chatBar:(ChatToolsView *)chatBar sendCall:(NSString *)calltime withVideo:(BOOL)isVideo;

/**
 *  发送语音信息
 *
 *  @param seconds   语音时长
 */
- (void)chatBar:(ChatToolsView *)chatBar sendVoice:(NSString *)voiceFileName seconds:(NSTimeInterval)seconds;

@end
NS_ASSUME_NONNULL_END
