//
//  XMUserManager.m
//  utree
//
//  Created by 科研部 on 2019/12/12.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "XMUserManager.h"
#import "MimcTokenApi.h"
int const TIMEOUT_ON_LAUNCHED = 30;
int const STATE_INIT = 0;
int const STATE_TIMEOUT = 999;
int const STATE_AGREE = 1;
int const STATE_REJECT = 2;
int const CALL_SENDER = 1;
int const CALL_RECEIVER = 2;
int const CALLID_INVALID = -1;
static dispatch_source_t timer;

/**
 * @important!!! appId/appKey/appSecret：
 * 小米开放平台(https://dev.mi.com/cosole/man/)申请
 * 信息敏感，不应存储于APP端，应存储在AppProxyService
 * appAccount:
 * APP帐号系统内唯一ID
 * 此处appId/appKey/appSecret为小米MIMC Demo所有，会在一定时间后失效
 * 请替换为APP方自己的appId/appKey/appSecret
 **/

@interface XMUserManager () {
}
@property(nonatomic) int64_t appId;
@property(nonatomic) NSString *appAccount;
@property(nonatomic, strong) MCUser *user;
@property(nonatomic, assign) NSInteger answer;
@property(nonatomic, strong) UIViewController *loginVC;

@end

static XMUserManager *_sharedInstance = nil;
static NSString * hangUpNotificationStr = @"kMIMCHangupNotification";
static NSString * answerNotificationStr = @"kMIMCanswerNotification";

@implementation XMUserManager
@synthesize appAccount = _appAccount;
@synthesize user = _user;

+ (XMUserManager *)sharedInstance {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _sharedInstance = [[XMUserManager alloc] init];
    });
    return _sharedInstance;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init {

    if (self = [super init]) {
        self.appId = 2882303761518168750;
    }
    return self;
}


- (BOOL)userLogin {
    _user = [[MCUser alloc] initWithAppId:_appId andAppAccount:_appAccount];
    _user.parseTokenDelegate = self;
    _user.onlineStatusDelegate = self;
    _user.handleMessageDelegate = self;
    _user.handleRtsCallDelegate = self;
    
    return [_user login];
}

- (BOOL)userLogout {
    return [_user logout];
}

- (void)GDCTimer {
    __block int timeout = TIMEOUT_ON_LAUNCHED;//倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    typeof(self) __weak wself = self;
    dispatch_source_set_event_handler(timer, ^{
        if (timeout > 0) {
            timeout--;
        }else{
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                wself.answer = STATE_TIMEOUT;
            });
        }
    });
    dispatch_resume(timer);
}

#pragma mark 从服务器获取mimc token
- (void)parseProxyServiceToken:(void(^)(NSString *data))callback {
    NSLog(@"parseProxyServiceToken, comes");
    
    MimcTokenApi *api = [[MimcTokenApi alloc]initWithAccountId:self.appAccount];

    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSString *json = request.responseString;
        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        NSLog(@"response:%@",responseDic);
        if(request.response.statusCode==200){
            NSMutableDictionary *tokenDic = [responseDic objectForKey:@"data"];
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tokenDic options:0 error:0];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            if (callback) {
                callback(jsonString);
            }
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"statusCode=%ld,str=%@",request.responseStatusCode,request.responseString);
    }];

}

- (void)statusChange:(MCUser *)user status:(int)status type:(NSString *)type reason:(NSString *)reason desc:(NSString *)desc {
    if (user == nil) {
        NSLog(@"statusChange, user is nil");
        return;
    }
    [self.returnUserStatusDelegate returnUserStatus:user status:status];
    NSLog(@"statusChange, Called, uuid=%@, user=%@, status=%d, type=%@, reason=%@, desc=%@",user.getUuid, user, status, type, reason, desc);
}

- (void)handleMessage:(NSArray<MIMCMessage*> *)packets user:(MCUser *)user {
    for (MIMCMessage *p in packets) {
        if (p == nil) {
            NSLog(@"handleMessage, ReceiveMessage, P2P is nil");
            continue;
        }
        NSLog(@"handleMessage, ReceiveMessage, P2P, {%@}-->{%@}, packetId=%@, payload=%@, bizType=%@", p.getFromAccount, user.getAppAccount, p.getPacketId, p.getPayload, p.getBizType);
        
        [self.receiveMsgDelegate onReceiveMessage:p user:user];
    }
}

- (void)handleGroupMessage:(NSArray<MIMCGroupMessage*> *)packets {
    NSLog(@"handleGroupMessage, Called");
}

- (void)handleServerAck:(MIMCServerAck *)serverAck {
    NSLog(@"handleServerAck, ReceiveMessageAck, ackPacketId=%@, sequence=%lld, timestamp=%lld, code=%d, desc=%@", serverAck.getPacketId, serverAck.getSequence, serverAck.getTimestamp, serverAck.getCode, serverAck.getDesc);
}

- (void)handleSendMessageTimeout:(MIMCMessage *)message {
    NSLog(@"handleSendMessageTimeout, message.packetId=%@, message.sequence=%lld, message.timestamp=%lld, message.fromAccount=%@, message.toAccount=%@, message.payload=%@, message.bizType=%@", message.getPacketId, message.getSequence, message.getTimestamp, message.getFromAccount, message.getToAccount, message.getPayload, message.getBizType);
}

- (void)handleSendGroupMessageTimeout:(MIMCGroupMessage *)groupMessage {
    NSLog(@"handleSendGroupMessageTimeout, groupMessag.packetId=%@, groupMessag.sequence=%lld, groupMessage.timestamp=%lld, groupMessage.fromAccount=%@, groupMessage.topicId=%lld, groupMessag.payload=%@, groupMessag.bizType=%@", groupMessage.getPacketId, groupMessage.getSequence, groupMessage.getTimestamp, groupMessage.getFromAccount, groupMessage.getTopicId, groupMessage.getPayload, groupMessage.getBizType);
}

- (void)handleUnlimitedGroupMessage:(NSArray<MIMCGroupMessage*> *)packets {
    NSLog(@"handleUnlimitedGroupMessage");
}

- (void)handleSendUnlimitedGroupMessageTimeout:(MIMCGroupMessage *)groupMessage {
    NSLog(@"handleSendUnlimitedGroupMessageTimeout, groupMessage=%@", groupMessage);
}

- (MIMCLaunchedResponse *)onLaunched:(NSString *)fromAccount fromResource:(NSString *)fromResource callId:(int64_t)callId appContent:(NSData *)appContent {
    NSLog(@"onLaunched, fromAccount=%@, fromResource=%@, callId=%lld, appContent=%@", fromAccount, fromResource, callId, appContent);
    
    return nil;
}

- (void)onAnswered:(int64_t)callId accepted:(Boolean)accepted desc:(NSString *)desc {
    [self.OnCallStateDelegate onAnswered:callId accepted:accepted desc:desc];
}

- (void)onClosed:(int64_t)callId desc:(NSString *)desc {
    [self.OnCallStateDelegate onClosed:callId desc:desc];
}

- (void)onData:(int64_t)callId fromAccount:(NSString *)fromAccount resource:(NSString *)resource data:(NSData *)data dataType:(RtsDataType)dataType channelType:(RtsChannelType)channelType {
    [self.OnCallStateDelegate onData:callId fromAccount:fromAccount resource:resource data:data dataType:dataType channelType:channelType];
}

- (void)onSendDataSuccess:(int64_t)callId dataId:(int)dataId context:(id)context {
    NSLog(@"onSendDataSuccess, callId=%lld, dataId=%d", callId, dataId);
}

- (void)onSendDataFailure:(int64_t)callId dataId:(int)dataId context:(id)context {
    NSLog(@"onSendDataFailure, callId=%lld, dataId=%d", callId, dataId);
}

- (NSString *)getAppAccount {
    return self.appAccount;
}

- (void)setAppAccount:(NSString *)appAccount {
    _appAccount = appAccount;
}

- (MCUser *)getUser {
    return self.user;
}

- (void)setUser:(MCUser *)user {
    _user = user;
}



@end
