//
//  UUInputToolsView.h
//  utree
//
//  Created by 科研部 on 2019/12/16.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UUInputToolsView;

@protocol UUInputToolsViewDelegate <NSObject>

// text
- (void)UUInputToolsView:(UUInputToolsView *)funcView sendMessage:(NSString *)message;

// image
- (void)UUInputToolsView:(UUInputToolsView *)funcView sendPicture:(NSArray *)photos assets:(NSArray *)picAssets;

// audio
- (void)UUInputToolsView:(UUInputToolsView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second;

-(void)showFunctionView;

-(void)startRecordAudio;
-(void)cancleRecordAudio;
-(void)endRecordVoice;
-(void)remindRecordDragExit;
-(void)remindRecordDragEnter;

@end

@interface UUInputToolsView : UIView <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, retain) UIButton *btnSendMessage;
@property (nonatomic, retain) UIButton *btnChangeVoiceState;
@property (nonatomic, retain) UIButton *btnVoiceRecord;
@property (nonatomic, retain) UITextView *textViewInput;

@property (nonatomic, assign) BOOL isAbleToSendTextMessage;

@property (nonatomic, assign) id<UUInputToolsViewDelegate>delegate;

- (void)changeSendBtnWithPhoto:(BOOL)isPhoto;

-(void)onFunctionActionClick:(int)position;

@end

NS_ASSUME_NONNULL_END
