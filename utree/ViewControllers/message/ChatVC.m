//
//  ChatVC.m
//  utree
//
//  Created by 科研部 on 2019/12/12.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ChatVC.h"
#import "UTParent.h"
#import "ChatView.h"
#import "Chat.h"
#import "XMUserManager.h"
#import "UTCache.h"
#import "ParentDataVC.h"

@interface ChatVC ()<KeyboardViewDelegate,XMAVAudioPlayerDelegate, returnUserStatusDelegate>
@property(nonatomic,strong)ChatView *chatView;
@property(nonatomic, strong) XMUserManager *userManager;
@property (assign, nonatomic) MessageChat messageChatType;
@property NSString *myAccountName;
@property NSString *myHeadPicUrl;
@property(nonatomic, strong)NSString *packetId;
@end

@implementation ChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initPersonData];
    [self initNaviBar];
    [self initChatView];
}

- (instancetype)initWithParent:(UTParent *)parent
{
    self = [super init];
    if (self) {
        [self registerNotification];
        self.parentModel = parent;
        _messageChatType= MessageChatSingle;
    }
    return self;
}

-(void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveMsgNotification:) name:MIMC_ReceiveMsgNotifyName object:nil];
}

- (void)onReceiveMsgNotification:(NSNotification *) notification {
    //处理消息
    NSDictionary *dic =notification.object;
    MIMCMessage *msg =[dic objectForKey:@"msg"];
    MCUser *user =[dic objectForKey:@"user"];
    [self showRecvMsg:msg user:user];
}

-(void)initPersonData
{
    NSDictionary *personDic=[UTCache readProfile];
    NSString *headPicUrl = [personDic objectForKey:@"filePath"];
    self.userManager = [XMUserManager sharedInstance];
    self.userManager.returnUserStatusDelegate = self;
    _myAccountName = [self getUserId];
    _myHeadPicUrl =headPicUrl;
}

-(void)initNaviBar
{
    self.title = self.parentModel.parentName;//标题
    CGRect rootFrame = self.view.frame;
    rootFrame.size.height=self.view.frame.size.height-iPhone_Safe_BottomNavH;
    NSLog(@"rootFrame.size.height=%f",rootFrame.size.height);
    self.view.frame=rootFrame;
    [XMAVAudioPlayer sharePlayer].delegate = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"data"
                                                                              style:UIBarButtonItemStyleDone target:self action:@selector(gotoParentDataVC:)];

    NSString *imagePath = [[NSBundle mainBundle]pathForResource:@"ic_parent_data" ofType:@"png"];
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    [self.navigationItem.rightBarButtonItem setImage:img];
}

-(void)gotoParentDataVC:(id)send
{
    
    ParentDataVC *parentDataVc = [[ParentDataVC alloc]init];
    [self.navigationController pushViewController:parentDataVc animated:YES];
    
}

-(void)initChatView
{
    self.chatView = [[ChatView alloc]initWithFrame:self.view.frame];
    
    _chatView.chatBar.delegate = self;
    
    [self.view addSubview:_chatView];
    
}

#pragma mark - KeyboardViewDelegate方法

- (void)chatBar:(KeyboardView *)chatBar sendMessage:(NSString *)message
{
    NSMutableDictionary *textMessageDict = [NSMutableDictionary dictionary];
    textMessageDict[kMessageConfigurationTypeKey]     = @(MessageTypeText);
    textMessageDict[kMessageConfigurationOwnerKey]    = @(MessageOwnerSelf);
    textMessageDict[kMessageConfigurationGroupKey]    = @(self.messageChatType);
    textMessageDict[kMessageConfigurationTextKey]     = message;
    textMessageDict[kMessageConfigurationNicknameKey] = _myAccountName;
    textMessageDict[kMessageConfigurationAvatarKey]   = _myHeadPicUrl;
    [self addMessage:textMessageDict];
}

- (void)chatBar:(KeyboardView *)chatBar sendCall:(NSString *)callTime withVideo:(BOOL)isVideo
{
    NSMutableDictionary *textMessageDict = [NSMutableDictionary dictionary];
    textMessageDict[kMessageConfigurationTypeKey]     = @(isVideo ? MessageTypeVideoCall:MessageTypeVoiceCall);
    textMessageDict[kMessageConfigurationOwnerKey]    = @(MessageOwnerSelf);
    textMessageDict[kMessageConfigurationGroupKey]    = @(self.messageChatType);
    textMessageDict[kMessageConfigurationTextKey]     = callTime;
    textMessageDict[kMessageConfigurationNicknameKey] = _myAccountName;
    textMessageDict[kMessageConfigurationAvatarKey]   = _myHeadPicUrl;
    [self addMessage:textMessageDict];
}

- (void)chatBar:(KeyboardView *)chatBar sendVoice:(NSString *)voiceFileName seconds:(NSTimeInterval)seconds
{
    NSMutableDictionary *voiceMessageDict = [NSMutableDictionary dictionary];
    voiceMessageDict[kMessageConfigurationTypeKey]         = @(MessageTypeVoice);
    voiceMessageDict[kMessageConfigurationOwnerKey]        = @(MessageOwnerSelf);
    voiceMessageDict[kMessageConfigurationGroupKey]        = @(self.messageChatType);
    voiceMessageDict[kMessageConfigurationNicknameKey]     = _myAccountName;
    voiceMessageDict[kMessageConfigurationAvatarKey]       = _myHeadPicUrl;
    voiceMessageDict[kMessageConfigurationVoiceKey]        = voiceFileName;
    voiceMessageDict[kMessageConfigurationVoiceSecondsKey] = @(seconds);
    [self addMessage:voiceMessageDict];
}

- (void)chatBar:(KeyboardView *)chatBar sendPictures:(NSArray *)pictures imageType:(BOOL)isGif
{
    NSMutableDictionary *imageMessageDict = [NSMutableDictionary dictionary];
    imageMessageDict[kMessageConfigurationTypeKey]     = @(isGif? MessageTypeGifImage : MessageTypeImage);
    imageMessageDict[kMessageConfigurationOwnerKey]    = @(MessageOwnerSelf);
    imageMessageDict[kMessageConfigurationGroupKey]    = @(self.messageChatType);
    imageMessageDict[kMessageConfigurationImageKey]    = [pictures firstObject];
    imageMessageDict[kMessageConfigurationNicknameKey] = _myAccountName;
    imageMessageDict[kMessageConfigurationAvatarKey]   = _myHeadPicUrl;
    [self addMessage:imageMessageDict];
}

- (void)chatBar:(KeyboardView *)chatBar sendVideos:(NSArray *)pictures
{
    NSMutableDictionary *imageMessageDict = [NSMutableDictionary dictionary];
    imageMessageDict[kMessageConfigurationTypeKey]     = @(MessageTypeVideo);
    imageMessageDict[kMessageConfigurationOwnerKey]    = @(MessageOwnerSelf);
    imageMessageDict[kMessageConfigurationGroupKey]    = @(self.messageChatType);
    imageMessageDict[kMessageConfigurationVideoKey]    = [pictures firstObject];
    imageMessageDict[kMessageConfigurationNicknameKey] = _myAccountName;
    imageMessageDict[kMessageConfigurationAvatarKey]   = _myHeadPicUrl;
    [self addMessage:imageMessageDict];
}

- (void)chatBar:(KeyboardView *)chatBar sendLocation:(CLLocationCoordinate2D)locationCoordinate locationText:(NSString *)locationText
{
    NSMutableDictionary *locationMessageDict = [NSMutableDictionary dictionary];
    locationMessageDict[kMessageConfigurationTypeKey]     = @(MessageTypeLocation);
    locationMessageDict[kMessageConfigurationOwnerKey]    = @(MessageOwnerSelf);
    locationMessageDict[kMessageConfigurationGroupKey]    = @(self.messageChatType);
    locationMessageDict[kMessageConfigurationNicknameKey] = _myAccountName;
    locationMessageDict[kMessageConfigurationAvatarKey]   = _myHeadPicUrl;
    locationMessageDict[kMessageConfigurationTextKey]     = locationText;
    locationMessageDict[kMessageConfigurationLocationKey] = [NSString stringWithFormat:@"%.6f,%.6f", locationCoordinate.latitude, locationCoordinate.longitude];
    [self addMessage:locationMessageDict];
}

- (void)chatBarFrameDidChange:(KeyboardView *)chatBar frame:(CGRect)frame
{

    [self.chatView chatBarFrameDidChange:chatBar frame:frame];
    
}

- (void)addMessage:(NSDictionary *)message
{
    [self sendTextMsg:message];
    
    [self.chatView addMessage:message];
}

-(void)sendTextMsg:(NSDictionary *)messageDic
{
    XMUserManager *userManager = [XMUserManager sharedInstance];
    if (![userManager.getUser isOnline]) {
        NSLog(@"sendTextMsg, %@ is offline", userManager.getUser.getAppAccount);
        return;
    }
    
    NSString *bizType = @"TEXT";
    NSData *data = [messageDic[kMessageConfigurationTextKey] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *payload = [data base64EncodedStringWithOptions:0];
    
    NSDictionary *jsonDict = @{@"version":@0,
                               @"content":payload};
    
    NSString *jsonData= [self convertToJsonData:jsonDict];
    
    _packetId = [[userManager getUser] sendMessage:self.parentModel.parentId payload:[jsonData dataUsingEncoding:NSUTF8StringEncoding] bizType:bizType];
    if (_packetId == nil || _packetId.length == 0) {
        NSLog(@"sendTextMsg, sendMessage_fail, _packetId is nil");
        return;
    }
    
    // 获取当前时间
//    NSDate *date = [NSDate date];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy-MMM-dd hh:mm:ss";
//    NSString *dateStr = [formatter stringFromDate:date];
    
}

//获取当前时间戳
- (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

- (void)showRecvMsg:(MIMCMessage *)packet user:(MCUser *)user {
    if (packet == nil || user == nil) {
        NSLog(@"showRecvMsg, parameter is nil");
        return;
    }
    if ([packet.getFromAccount isEqualToString:_myAccountName]) {
        NSLog(@"showRecvMsg, 收到自己的消息");
        return ;
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:packet.getTimestamp / 1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MMM-dd hh:mm:ss";
    NSString *dateStr = [formatter stringFromDate:date];
    NSString *recvText = [[NSString alloc] initWithData:packet.getPayload encoding:NSUTF8StringEncoding];
    NSLog(@"msg timeStamp=%@ ,payload=%@",dateStr, recvText);
    //文本消息
    if ([[packet getBizType] isEqualToString:@"TEXT"]) {
        NSDictionary *jsonDict = [self dictionaryWithJsonString:recvText];
        NSData *payloadByte = [[NSData alloc] initWithBase64EncodedString:jsonDict[@"content"] options:0];
        NSString *payload = [[NSString alloc] initWithData:payloadByte encoding:NSUTF8StringEncoding];
           
        [self receiveMsgToView:payload];
    }
       
  
}

-(void)receiveMsgToView:(NSString *)msgText
{
    
    NSMutableDictionary *messageDict = [NSMutableDictionary dictionary];
    messageDict[kMessageConfigurationTextKey] = msgText;
    messageDict[kMessageConfigurationAvatarKey] = self.parentModel.picPath;
     messageDict[kMessageConfigurationNicknameKey] = self.parentModel.parentId;
    messageDict[kMessageConfigurationTypeKey] = @(MessageTypeText);
    messageDict[kMessageConfigurationOwnerKey] = @(MessageOwnerOther);
    messageDict[kMessageConfigurationGroupKey] = @(MessageChatSingle);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.chatView addMessage:messageDict];
    });
}

#pragma mark 返回用户登录状态
- (void)returnUserStatus:(MCUser *)user status:(int)status {
    if (user != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            (status == Online) ? [_switchButton setOn:YES]:[_switchButton setOn:NO];
        });
    }
    return;
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (NSString *)convertToJsonData:(NSDictionary *)dict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    
    if (!jsonData) {
        NSLog(@"%@",error);
    } else {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];

    //去掉字符串中的反斜杠
    NSRange range3 = {0,mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:range3];
    
    return mutStr;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
