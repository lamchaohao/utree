//
//  ChatMessageDC.m
//  utree
//
//  Created by 科研部 on 2019/12/16.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ChatMessageDC.h"
#import "UTMessage.h"
#import "UTMessageFrame.h"
#import "JSONUtil.h"
#import "DBManager.h"
#import "UTDateConvertTool.h"

@interface ChatMessageDC () <UploadFileListener>
{
    NSInteger _audioFileIndex ;
    NSInteger _photoFileIndex;
}
@property(nonatomic,strong)NSMutableDictionary *uploadObjectDic;
@property(nonatomic,strong)DBManager *dbManager;
@end
@implementation ChatMessageDC
static NSString *previousTime = nil;

/**
 strIcon
 strName
 */
- (instancetype)initWithAccountDic:(NSDictionary *)dic parentDic:(NSDictionary *)parentDic
{
    self = [super init];
    if (self) {
        self.accountDic = dic;
        self.fromAccountDic =parentDic;
        self.dbManager = [DBManager sharedInstance];
        self.dataSource = [[NSMutableArray alloc]init];
        self.platform = @"chat";
        self.uploadListener = self;
        _uploadObjectDic = [[NSMutableDictionary alloc]init];
        _audioFileIndex = 20000;
        _photoFileIndex =1;
    }
    return self;
}

- (void)loadRecentsMessageWithCallback:(ChatMessageDCCompleted)callback
{
    [self.dbManager queryMessageWithAccount:_fromAccountDic[Key_Account_Id] limit:20 offset:0 withResult:^(NSDictionary * _Nonnull resultDic) {
        NSMutableArray *recentMsgs = resultDic[@"result"];
        NSArray* reversedArray = [[recentMsgs reverseObjectEnumerator] allObjects];
        for (UTMessage *message in reversedArray) {
            if (message.from==UTMessageFromMe) {
               message.headPicUrl=self.accountDic[Key_Head_Pic];
            }else{
                message.headPicUrl=self.fromAccountDic[Key_Head_Pic];
            }
            UTMessageFrame *messageFrame = [[UTMessageFrame alloc]init];
            NSString *tempTime = [NSString stringWithFormat:@"%ld", (long)([ [NSDate date] timeIntervalSince1970]*1000)];//当前毫秒数
            [message minuteOffSetStart:previousTime end:tempTime];
            
            [messageFrame setMessage:message];
            messageFrame.showTime = message.showDateLabel;
            [self.dataSource addObject:messageFrame];
           }
        callback(self.dataSource.count);
    }];

}

-(void)loadMoreHistoryMessageWithCallback:(ChatMessageDCCompleted)callback
{
    [self.dbManager queryMessageWithAccount:_fromAccountDic[Key_Account_Id] limit:15 offset:(int)self.dataSource.count withResult:^(NSDictionary * _Nonnull resultDic) {
         NSMutableArray *recentMsgs = resultDic[@"result"];
        NSArray* reversedArray = [[recentMsgs reverseObjectEnumerator] allObjects];
        NSMutableArray *container = [[NSMutableArray alloc]init];
        NSMutableArray *oldData = [[NSMutableArray alloc]init];
        [oldData addObjectsFromArray:self.dataSource];
        for (UTMessage *message in reversedArray) {
            UTMessageFrame *messageFrame = [[UTMessageFrame alloc]init];
            if (message.from==UTMessageFromMe) {
               message.headPicUrl=self.accountDic[Key_Head_Pic];
            }else{
                message.headPicUrl=self.fromAccountDic[Key_Head_Pic];
            }
            NSString *tempTime = [NSString stringWithFormat:@"%ld", (long)([ [NSDate date] timeIntervalSince1970]*1000)];//当前毫秒数
            [message minuteOffSetStart:previousTime end:tempTime];
            [messageFrame setMessage:message];
            messageFrame.showTime = message.showDateLabel;
            [container addObject:messageFrame];
        }
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:container];
        [self.dataSource addObjectsFromArray:oldData];
        if (callback) {
            callback(container.count);
        }
    }];
    
}

- (UTMessage *)sendTextMessage:(NSString *)text
{
    UTMessageFrame *messageFrame = [[UTMessageFrame alloc]init];
    UTMessage *message = [self makeMessage];
    message.contentStr = text;
    message.type = UTMessageTypeText;
    messageFrame.showTime = message.showDateLabel;
    [messageFrame setMessage:message];
    [self.dataSource addObject:messageFrame];
    return message;
}

-(void)sendVoiceMessage:(NSString *)voiceURL duration:(NSString *)durationStr
{
    _audioFileIndex ++;
    
    UTMessageFrame *messageFrame = [[UTMessageFrame alloc]init];
    UTMessage *message = [self makeMessage];
    message.type = UTMessageTypeVoice;
    message.voiceUrl = voiceURL;
    message.sendStatus = UTStatusSending;
    message.voiceDuration = durationStr;
    
    messageFrame.showTime = message.showDateLabel;
    [messageFrame setMessage:message];
    [self.dataSource addObject:messageFrame];
    
    [self uploadFile:voiceURL mediaType:@"audio" fileIndex:_audioFileIndex];
    [_uploadObjectDic setObject:messageFrame forKey:[NSString stringWithFormat:@"%ld",_audioFileIndex]];
}

-(void)updateVoiceMessageStatus:(NSString *)audioPath fileIndex:(NSInteger)fileIndex
{

    UTMessageFrame *messageFrame = [_uploadObjectDic objectForKey:[NSString stringWithFormat:@"%ld",fileIndex]];
    messageFrame.message.voiceUrl = audioPath;
    messageFrame.message.type = UTMessageTypeVoice;
    messageFrame.message.sendStatus = UTStatusSendCompleted;
    for (int index=0; index<self.dataSource.count; index++) {
        if ([messageFrame isEqual:[self.dataSource objectAtIndex:index]]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [self.delegate onMediaMessageSendCompleted:indexPath message:messageFrame.message];
            break;
        }
    }
}

-(void)sendImageMessage:(UIImage *)image andAsset:(PHAsset *)asset
{
    NSString *fileName =@"";
     
    if(!asset){
        fileName = [NSString stringWithFormat:@"%ld.JPEG", [UTDateConvertTool getNowTimestamp]];
    }else{
        fileName = [asset valueForKey:@"filename"];
    }
   
    NSLog(@"chatMsgDC,fileName = %@",fileName);
    
    _photoFileIndex ++;
    UTMessageFrame *messageFrame = [[UTMessageFrame alloc]init];
    UTMessage *message = [self makeMessage];
    message.type = UTMessageTypePicture;
    message.picture = image;
    message.sendStatus = UTStatusSending;
    
    messageFrame.showTime = message.showDateLabel;
    [messageFrame setMessage:message];
    [self.dataSource addObject:messageFrame];
    
     [_uploadObjectDic setObject:messageFrame forKey:[NSString stringWithFormat:@"%ld",_photoFileIndex]];
    
    [self uploadFileData:[image sd_imageData] fileName:fileName mediaType:@"pic" fileIndex:_photoFileIndex];
   
}


-(void)updateImageMessageStatus:(NSString *)imagePath fileIndex:(NSInteger)fileIndex
{
    UTMessageFrame *messageFrame = [_uploadObjectDic objectForKey:[NSString stringWithFormat:@"%ld",fileIndex]];
    messageFrame.message.picUrl = imagePath;
    messageFrame.message.type = UTMessageTypePicture;
    messageFrame.message.sendStatus = UTStatusSendCompleted;
    for (int index=0; index<self.dataSource.count; index++) {
        if ([messageFrame isEqual:[self.dataSource objectAtIndex:index]]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [self.delegate onMediaMessageSendCompleted:indexPath message:messageFrame.message];
            break;
        }
    }
    
}

-(UTMessage *)makeMessage
{
    UTMessage *message = [[UTMessage alloc] init];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:self.accountDic];
    [message setWithDict:dataDic];
    message.type = UTMessageTypeText;
    message.from = UTMessageFromMe;
    NSString *tempTime = [NSString stringWithFormat:@"%ld", [UTDateConvertTool getNowTimestamp]];//当前毫秒数
    message.timeStamp = tempTime;
    [message minuteOffSetStart:previousTime end:tempTime];
    message.headPicUrl=self.accountDic[Key_Head_Pic];
    if (message.showDateLabel) {
        previousTime = tempTime;
    }
    return message;
}

-(UTMessage *)makeFromOtherMessage
{
    UTMessage *message = [[UTMessage alloc] init];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:self.fromAccountDic];
    [message setWithDict:dataDic];
    message.type = UTMessageTypeText;
    message.from = UTMessageFromOther;
    
    NSString *tempTime = [NSString stringWithFormat:@"%ld", [UTDateConvertTool getNowTimestamp]];//当前毫秒数
    message.timeStamp = tempTime;
    [message minuteOffSetStart:previousTime end:tempTime];
    message.headPicUrl=self.fromAccountDic[Key_Head_Pic];
    if (message.showDateLabel) {
        previousTime = tempTime;
    }
    return message;
}

#pragma mark 收到即时云消息
- (void)receiveMessage:(MIMCMessage *)mimcMessage
{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:mimcMessage.getTimestamp / 1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MMM-dd hh:mm:ss";
    NSString *dateStr = [formatter stringFromDate:date];
    NSString *recvText = [[NSString alloc] initWithData:mimcMessage.getPayload encoding:NSUTF8StringEncoding];
    NSLog(@"msg timeStamp=%@ ,payload=%@",dateStr, recvText);
    
    NSDictionary *jsonDict = [JSONUtil dictionaryWithJsonString:recvText];
    NSData *payloadByte = [[NSData alloc] initWithBase64EncodedString:jsonDict[@"content"]
                                                              options:0];
    NSString *payload = [[NSString alloc] initWithData:payloadByte encoding:NSUTF8StringEncoding];
    
    if ([[mimcMessage getBizType] isEqualToString:@"TEXT"]) {
        //文本消息
        dispatch_async(dispatch_get_main_queue(), ^{
            UTMessage *msg = [self receiveTextMessage:payload packetId:mimcMessage.getPacketId];
            msg.accountId = mimcMessage.getFromAccount;
        });
    }else if([[mimcMessage getBizType] isEqualToString:@"AUDIO"]){
        NSString *durationStr = jsonDict[@"duration"];
        dispatch_async(dispatch_get_main_queue(), ^{
            UTMessage *msg = [self receiveVoiceMessage:payload duration:durationStr packetId:mimcMessage.getPacketId];
            msg.accountId = mimcMessage.getFromAccount;
            
        });
    }else if([[mimcMessage getBizType] isEqualToString:@"PIC"]){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UTMessage *msg =[self receivePicMessage:payload packetId:mimcMessage.getPacketId];
            msg.accountId = mimcMessage.getFromAccount;
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            UTMessage *msg =[self receiveTextMessage:@"[该版本暂不支持消息类型]" packetId:mimcMessage.getPacketId];
            msg.accountId = mimcMessage.getFromAccount;
        });
    }
       
}

#pragma mark 收到文本消息
- (UTMessage *)receiveTextMessage:(NSString *)text packetId:(NSString *)msgId
{
    UTMessageFrame *messageFrame = [[UTMessageFrame alloc]init];
    UTMessage *message = [self makeFromOtherMessage];
    message.messageId = msgId;
    message.contentStr = text;
    message.sendStatus = UTStatusSendCompleted;
    message.type = UTMessageTypeText;
    messageFrame.showTime = message.showDateLabel;
    [messageFrame setMessage:message];
    [self.dataSource addObject:messageFrame];
    [self.delegate onMessageReceivedCompleted];
    return message;
}
#pragma mark 收到语音消息
-(UTMessage *)receiveVoiceMessage:(NSString *)voiceUrl duration:(NSString *)dura packetId:(NSString *)msgId;
{
    UTMessageFrame *messageFrame = [[UTMessageFrame alloc]init];
    UTMessage *message = [self makeFromOtherMessage];
    message.type=UTMessageTypeVoice;
    message.sendStatus = UTStatusSendCompleted;
    message.voiceUrl = voiceUrl;
    message.voiceDuration = dura;
    messageFrame.message = message;
    [self.dataSource addObject:messageFrame];
    [self.delegate onMessageReceivedCompleted];
     return message;
}

#pragma mark 收到图片消息
-(UTMessage *)receivePicMessage:(NSString *)picUrl packetId:(NSString *)msgId
{
    UTMessageFrame *messageFrame = [[UTMessageFrame alloc]init];
    UTMessage *message = [self makeFromOtherMessage];
    message.type=UTMessageTypePicture;
    message.sendStatus = UTStatusSendCompleted;
    message.picUrl = picUrl;
    messageFrame.message = message;
    [self.dataSource addObject:messageFrame];
    [self.delegate onMessageReceivedCompleted];
    return message;
}

- (void)recountFrame
{
    [self.dataSource enumerateObjectsUsingBlock:^(UTMessageFrame * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.message = obj.message;
    }];
}


- (void)onFileUploadResult:(BOOL)success filePath:(NSString *)filePath fileIndex:(NSInteger)index md5Value:(NSString *)md5Str
{
    if (success) {
        if (index>20000) {//audioIndex >20000;
            [self updateVoiceMessageStatus:[NSString stringWithFormat:@"%@%@",OSS_PATH_PREFIX,filePath] fileIndex:index];
        }else{//photoindex>1<20000
            [self updateImageMessageStatus:[NSString stringWithFormat:@"%@%@",OSS_PATH_PREFIX,filePath] fileIndex:index];
        }
    }
    
}

- (void)onFileUploadProgress:(CGFloat)progress filePath:(NSString *)filePath fileIndex:(NSInteger)index
{
    
}


@end
