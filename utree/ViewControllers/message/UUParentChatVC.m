//
//  UUParentChatVC.m
//  utree
//  发送的消息在此保存到数据库
//  Created by 科研部 on 2019/12/16.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UUParentChatVC.h"
#import "UUChatView.h"
#import "UTParent.h"
#import "XMUserManager.h"
#import "UTCache.h"
#import "UTMessage.h"
#import "ParentDataVC.h"
#import "JSONUtil.h"
#import "DBManager.h"

@interface UUParentChatVC ()<returnUserStatusDelegate,ChatMessageViewDelegate,ChatMessageDCDelegate>

@property (strong, nonatomic) UUChatView *chatView;
@property(nonatomic, strong) XMUserManager *userManager;
@property NSString *myAccountName;
@property NSString *myHeadPicUrl;
@property(nonatomic, strong)NSString *packetId;
@property(nonatomic,strong)UTParent *parentModel;
@property(nonatomic,strong)DBManager *dbManager;

@end

@implementation UUParentChatVC

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
    [self onReceiveMimcMessage:msg user:user];
}

-(void)initPersonData
{
    self.dbManager = [DBManager sharedInstance];
    [self.dbManager openContactToChat:self.parentModel];
    
    NSDictionary *personDic=[UTCache readProfile];
    NSString *headPicUrl = [personDic objectForKey:@"filePath"];
    self.userManager = [XMUserManager sharedInstance];
    self.userManager.returnUserStatusDelegate = self;
    _myAccountName = [self getUserId];
    _myHeadPicUrl =headPicUrl;
    
    NSDictionary *personalDic = @{
        Key_Account_Id:[self getUserId],
        Key_Account_Name:@"me",
        Key_Head_Pic:_myHeadPicUrl};
    NSDictionary *parentDic = @{
        Key_Account_Id:self.parentModel.parentId,
        Key_Account_Name:self.parentModel.parentName,
        Key_Head_Pic:self.parentModel.picPath};
    self.dataController = [[ChatMessageDC alloc]initWithAccountDic:personalDic parentDic:parentDic];
    self.dataController.delegate = self;
}

-(void)initNaviBar
{
    self.title = self.parentModel.parentName;//标题
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"data" style:UIBarButtonItemStyleDone target:self action:@selector(gotoParentDataVC:)];

    NSString *imagePath = [[NSBundle mainBundle]pathForResource:@"ic_parent_data" ofType:@"png"];
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    [self.navigationItem.rightBarButtonItem setImage:img];
}

-(void)gotoParentDataVC:(id)send
{
    
    ParentDataVC *parentDataVc = [[ParentDataVC alloc]initWithParent:self.parentModel];
    [self.navigationController pushViewController:parentDataVc animated:YES];
    
}

-(void)initChatView
{
    self.chatView = [[UUChatView alloc]initWithFrame:self.view.frame andDataSource:self.dataController];
    self.chatView.dataDelegate = self;
    [self.view addSubview:self.chatView];
    [self.dataController loadRecentsMessageWithCallback:^(NSInteger count) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.chatView notifyReceiveNewMessage];
        });
    }];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.chatView VCviewDidAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.chatView VCviewWillDisappear:animated];
}

#pragma mark dataDelegate
- (void)recountFrame
{
    [self.dataController recountFrame];
}


- (void)loadMoreMessage
{
    [self.dataController loadMoreHistoryMessageWithCallback:^(NSInteger count) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.chatView notifyLoadMoreMessageFinish:count];
        });
        
    }];
}

#pragma mark ChatMessageDCDelegate
- (void)onMediaMessageSendCompleted:(NSIndexPath *)indexPath message:(UTMessage *)message
{
    if(message.type==UTMessageTypeVoice){
        [self sendVoiceMessage:message];
    }else{
        [self sendPicMimcMessage:message];
    }
    
    [self.chatView notifyMessageSendStatusAtIndexPath:indexPath];
}


- (void)onMessageReceivedCompleted
{
    [self.chatView notifyReceiveNewMessage];
}
#pragma mark ChatMessageDCDelegate
- (void)showViewController:(UIViewController *)vc
{
    [self.chatView VCviewWillDisappear:NO];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void)viewControllerDidFinish
{
    [self.chatView VCviewDidAppear:NO];
}


#pragma mark view deal adding new message
- (void)addMessage:(NSDictionary *)dic
{
    if([[dic objectForKey:Key_Type] isEqual: @(UTMessageTypeText)]){
        //文字消息
        
        NSString *text =[dic objectForKey:Key_Content_Text];
        if([self isBlankString:text]){
            return ;
        }
        UTMessage *msg =[self.dataController sendTextMessage:text];
        [self sendTextMsg:msg];
    }else if([[dic objectForKey:Key_Type] isEqual: @(UTMessageTypeVoice)]){
        //语音消息
        [self.dataController sendVoiceMessage:dic[Key_Voice_URL] duration:dic[Key_Voice_Duration]];
    }else if([[dic objectForKey:Key_Type] isEqual: @(UTMessageTypePicture)]){
        //图片消息
        PHAsset *asset= dic[Key_Pic_Asset];
        [self.dataController sendImageMessage:dic[Key_Pic_Data] andAsset:asset];
        
    }else{
        NSString *text =@"[该版本暂不支持消息类型]";
        UTMessage *msg =[self.dataController sendTextMessage:text];
        [self sendTextMsg:msg];
    }
}



-(void)sendTextMsg:(UTMessage *)utMsg
{
    utMsg.toAccount = self.parentModel.parentId;
    NSString *bizType = @"TEXT";
    NSData *data = [utMsg.contentStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *payload = [data base64EncodedStringWithOptions:0];
    NSDictionary *jsonDict = @{@"version":@0,
                               @"content":payload};
    
    NSString *jsonData= [JSONUtil convertToJsonData:jsonDict];
    [self packageSendMIMCMessage:jsonData bizType:bizType msg:utMsg];
    
}

-(void)sendVoiceMessage:(UTMessage *)utMsg
{
    utMsg.toAccount = self.parentModel.parentId;
    NSString *bizType = @"AUDIO";
    NSData *encodeData = [utMsg.voiceUrl dataUsingEncoding:NSUTF8StringEncoding];
    NSString *payload = [encodeData base64EncodedStringWithOptions:0];
    NSDictionary *jsonDict = @{@"version":@0,
                               @"content":payload,
                               @"duration":utMsg.voiceDuration
                             };
    
    NSString *jsonData= [JSONUtil convertToJsonData:jsonDict];
    [self packageSendMIMCMessage:jsonData bizType:bizType msg:utMsg];
}

-(void)sendPicMimcMessage:(UTMessage *)utMsg
{
    utMsg.toAccount = self.parentModel.parentId;
    NSString *bizType = @"PIC";
    NSData *encodeData = [utMsg.picUrl dataUsingEncoding:NSUTF8StringEncoding];
    NSString *payload = [encodeData base64EncodedStringWithOptions:0];
    NSInteger height = (int)utMsg.picture.size.height;
    NSInteger width = (int)utMsg.picture.size.width;
    NSDictionary *jsonDict = @{@"version":@0,
                               @"content":payload,
                               @"height":@(height),
                               @"width":@(width)
                             };
    
    NSString *jsonData= [JSONUtil convertToJsonData:jsonDict];
    [self packageSendMIMCMessage:jsonData bizType:bizType msg:utMsg];
}

-(void)packageSendMIMCMessage:(NSString *)jsonStr bizType:(NSString *)bizType msg:(UTMessage *)msg
{
    XMUserManager *userManager = [XMUserManager sharedInstance];
    if (![userManager.getUser isOnline]) {
        [userManager.getUser login];
        NSLog(@"packageSendMIMCMessage, %@ is offline", userManager.getUser.getAppAccount);
        return;
    }
    _packetId = [[userManager getUser] sendMessage:self.parentModel.parentId payload:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] bizType:bizType];
    if (_packetId == nil || _packetId.length == 0) {
        NSLog(@"packageSendMIMCMessage, sendMessage_fail, _packetId is nil");
        return;
    }
    msg.readStatus =1;//已读
    msg.messageId = _packetId;
    //在此进行数据保存
    [self.dbManager saveSendMessage:msg];
}

- (void)onReceiveMimcMessage:(MIMCMessage *)packet user:(MCUser *)user {
    if (packet == nil || user == nil) {
        NSLog(@"onReceiveMimcMessage, parameter is nil");
        return;
    }
    if ([packet.getFromAccount isEqualToString:_myAccountName]) {
        NSLog(@"onReceiveMimcMessage, 收到自己的消息");
        return ;
    }
    if ([packet.getFromAccount isEqualToString:_parentModel.parentId]) {
        //是发给自己的消息才刷新界面记录
        [self.dataController receiveMessage:packet];
    }
    
    
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


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
