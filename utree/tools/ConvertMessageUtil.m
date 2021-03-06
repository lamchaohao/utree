//
//  ConvertMessage.m
//  utree
//
//  Created by 科研部 on 2019/12/20.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ConvertMessageUtil.h"
#import "JSONUtil.h"
#import "UTDateConvertTool.h"
@implementation ConvertMessageUtil

+ (UTMessage *)convertMimcMessage:(MIMCMessage *)mimcMessage;
{
    NSString *recvText = [[NSString alloc] initWithData:mimcMessage.getPayload encoding:NSUTF8StringEncoding];
    
    NSDictionary *jsonDict = [JSONUtil dictionaryWithJsonString:recvText];
    NSData *payloadByte = [[NSData alloc] initWithBase64EncodedString:jsonDict[@"content"]
                                                              options:0];
    NSString *payload = [[NSString alloc] initWithData:payloadByte encoding:NSUTF8StringEncoding];
    UTMessage *message = [self makeFromOtherMessage];
    message.messageId = mimcMessage.getPacketId;
    message.accountId = mimcMessage.getFromAccount;
    //    保存的收到的聊天记录中，UTMessage.toAccount = mimcMessage.getFromAccount
    message.toAccount = mimcMessage.getFromAccount;
    message.sendStatus = UTStatusSendCompleted;
    if ([[mimcMessage getBizType] isEqualToString:@"TEXT"]) {
        message.contentStr = payload;
        message.type = UTMessageTypeText;
       
    }else if([[mimcMessage getBizType] isEqualToString:@"AUDIO"]){
        NSString *durationStr = jsonDict[@"duration"];
        message.type=UTMessageTypeVoice;
        message.voiceUrl = payload;
        message.voiceDuration = durationStr;
        
    }else if([[mimcMessage getBizType] isEqualToString:@"PIC"]){
        message.type=UTMessageTypePicture;
        message.picUrl = payload;
    }else{
        message.contentStr = @"[该版本暂不支持消息类型]";
        message.type = UTMessageTypeText;
    }
    
    return message;
}

+(UTMessage *)makeFromOtherMessage
{
    UTMessage *message = [[UTMessage alloc] init];
    message.type = UTMessageTypeText;
    message.from = UTMessageFromOther;
    message.readStatus = 0;//未读消息
    NSString *tempTime = [NSString stringWithFormat:@"%ld", [UTDateConvertTool getNowTimestamp]];//当前毫秒数
    message.timeStamp = tempTime;
    
    return message;
}
@end
