//
//  ChatMessageDC.h
//  utree
//
//  Created by 科研部 on 2019/12/16.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "BaseDataController.h"
#import "UploadFileDC.h"
#import "MIMCMessage.h"
#import "UTMessage.h"
#import <Photos/PHAsset.h>
NS_ASSUME_NONNULL_BEGIN

@class UTMessageFrame;
@class UTMessage;

typedef void(^ChatMessageDCCompleted)(NSInteger count);


@protocol ChatMessageDCDelegate <NSObject>

-(void)onMediaMessageSendCompleted:(NSIndexPath *)indexPath message:(UTMessage *)message;


-(void)onMessageReceivedCompleted;

@end

@interface ChatMessageDC : UploadFileDC

@property(nonatomic,strong)NSDictionary *accountDic;
@property(nonatomic,strong)NSDictionary *fromAccountDic;

@property (nonatomic, strong) NSMutableArray<UTMessageFrame *> *dataSource;

- (instancetype)initWithAccountDic:(NSDictionary *)dic parentDic:(NSDictionary *)parentDic;

- (UTMessage *)sendTextMessage:(NSString *)text;

- (void)sendVoiceMessage:(NSString *)voiceData duration:(NSString *)durationStr;

- (void)sendImageMessage:(UIImage *)image andAsset:(PHAsset *)asset;
 
- (void)receiveMessage:(MIMCMessage *)mimcMessage;

- (void)recountFrame;

- (void)loadRecentsMessageWithCallback:(ChatMessageDCCompleted)callback;

-(void)loadMoreHistoryMessageWithCallback:(ChatMessageDCCompleted)callback;

@property(nonatomic,weak)id<ChatMessageDCDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
