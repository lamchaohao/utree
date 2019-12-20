//
//  UTMessage.h
//  utree
//
//  Created by 科研部 on 2019/12/17.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


static NSString *const Key_Head_Pic = @"head_pic_url";
static NSString *const Key_Account_Id = @"account_id";
static NSString *const Key_toAccount_Id = @"to_account_id";
static NSString *const Key_Account_Name = @"account_id";
static NSString *const Key_Content_Text = @"content_text";
static NSString *const Key_Voice_Duration = @"voice_duration";
static NSString *const Key_Voice_URL = @"voice_url";
static NSString *const Key_Pic_Data = @"picture_data";
static NSString *const Key_Pic_Asset=@"pic_PHAsset";
static NSString *const Key_Time_Stamp= @"timestamp";
static NSString *const Key_From = @"from";
static NSString *const Key_Type =@"type";

@interface UTMessage : NSObject


typedef NS_ENUM(NSInteger, UTMessageType) {
    UTMessageTypeText     = 0 , // 文字
    UTMessageTypePicture  = 1 , // 图片
    UTMessageTypeVoice    = 2   // 语音
};

typedef NS_ENUM(NSInteger, UTMessageFrom) {
    UTMessageFromMe    = 0,   // 自己发的
    UTMessageFromOther = 1    // 别人发得
};

typedef NS_ENUM(NSInteger, UTMessageStatus) {
    UTStatusSending    = 0,   // 发送中
    UTStatusSendCompleted = 1    // 发送完成
    
};


@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, copy) NSString *headPicUrl;
@property (nonatomic, copy) NSString *accountId;
@property (nonatomic, copy) NSString *toAccount;
@property (nonatomic, copy) NSString *timeForShow;
@property (nonatomic, copy) NSString *timeStamp;//当前毫秒数
@property (nonatomic, copy) NSString *accountName;

@property (nonatomic, copy) NSString *contentStr;
@property (nonatomic, copy) UIImage  *picture;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, copy) NSString *voiceUrl;
@property (nonatomic, copy) NSString *voiceDuration;

@property (nonatomic, assign) UTMessageType type;
@property (nonatomic, assign) UTMessageFrom from;
@property (nonatomic, assign) UTMessageStatus sendStatus;
@property (nonatomic, assign) int readStatus;
@property (nonatomic, assign) BOOL showDateLabel;

- (void)setWithDict:(NSDictionary *)dict;

- (void)minuteOffSetStart:(NSString *)start end:(NSString *)end;

@end

NS_ASSUME_NONNULL_END
