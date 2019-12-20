//
//  ChatView.m
//  utree
//
//  Created by 科研部 on 2019/12/12.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ChatView.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "UITableView+CellRegister.h"
#import "ChatMessageCell+CellIdentifier.h"
#import "Masonry.h"
#import "Chat.h"
#import "FaceManager.h"

@interface ChatView()<ChatMessageCellDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray  *messageArray;
@property (strong, nonatomic) UITableView     *tableView;
 /**< 语音聊天录音指示view */
@property (strong, nonatomic) UIImageView     *backgroundImageView;

@property (assign, nonatomic) MessageChat messageChatType;

@end

@implementation ChatView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView ];
    }
    return self;
}

-(void)setupView
{
    self.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:234/255.0f blue:234/255.f alpha:1.0f];
    self.recordView.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.tableView addGestureRecognizer:tap];
    _messageArray = [NSMutableArray array];
    
    [self addSubview:self.tableView];
    [self addSubview:self.chatBar];
    [self addSubview:self.recordView];
    [self updateConstraintsIfNeeded];
}


- (void)updateConstraints
{
    [super updateConstraints];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make)
    {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top).with.offset(60);
        make.right.equalTo(self.mas_right);
        NSLog(@"frame.height=%f",self.frame.size.height);
        make.height.equalTo(@(self.frame.size.height-105));
        make.bottom.equalTo(self.chatBar.mas_top).with.offset(4);
    }];
    
    [self.chatBar mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.tableView.mas_bottom).with.offset(4);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(kMinHeight);
    }];
    
    [self.recordView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.width.mas_equalTo (@(155));
        make.height.mas_equalTo (@(170));
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
        make.centerY.equalTo(self.mas_centerY).with.offset(0);
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *message = self.messageArray[indexPath.row];
    NSString *strIdentifier = [ChatMessageCell cellIdentifierForMessageConfiguration:
                               @{kMessageConfigurationGroupKey:message[kMessageConfigurationGroupKey],
                                 kMessageConfigurationOwnerKey:message[kMessageConfigurationOwnerKey],
                                 kMessageConfigurationTypeKey:message[kMessageConfigurationTypeKey]}];
    
    ChatMessageCell *messageCell = [tableView dequeueReusableCellWithIdentifier:strIdentifier];
    [messageCell configureCellWithData:message];
    messageCell.messageReadState = [[MessageStateManager shareManager] messageReadStateForIndex:indexPath.row];
    messageCell.messageSendState = [[MessageStateManager shareManager] messageSendStateForIndex:indexPath.row];
    messageCell.delegate = self;
    return messageCell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *message = self.messageArray[indexPath.row];
    NSString *identifier = [ChatMessageCell cellIdentifierForMessageConfiguration:
                            @{kMessageConfigurationGroupKey:message[kMessageConfigurationGroupKey],
                              kMessageConfigurationOwnerKey:message[kMessageConfigurationOwnerKey],
                              kMessageConfigurationTypeKey:message[kMessageConfigurationTypeKey]}];
    
    return [tableView fd_heightForCellWithIdentifier:identifier cacheByIndexPath:indexPath configuration:^(ChatMessageCell *cell)
            {
                [cell configureCellWithData:message];
            }];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *message = self.messageArray[indexPath.row];
    if ([message[kMessageConfigurationTypeKey] integerValue] == MessageTypeVoice)
    {
        if (indexPath.row == [[XMAVAudioPlayer sharePlayer] index])
        {
            [(ChatVoiceMessageCell *)cell setVoiceMessageState:[[XMAVAudioPlayer sharePlayer] audioPlayerState]];
        }
    }
}


#pragma mark 工具栏的变化
- (void)chatBarFrameDidChange:(ChatToolsView *)chatBar frame:(CGRect)frame
{

    if (frame.origin.y == self.tableView.frame.size.height)
    {
        return;
    }
    [UIView animateWithDuration:0.3f animations:^{

        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make)
        {
            make.height.equalTo(@(frame.origin.y-56));//56

        }];
    } completion:nil];
    
}

- (void)messageCellTappedHead:(ChatMessageCell *)messageCell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:messageCell];
    NSLog(@"tapHead :%@",indexPath);
}

- (void)messageCellTappedBlank:(ChatMessageCell *)messageCell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:messageCell];
    NSLog(@"tapBlank :%@",indexPath);
    [self.chatBar endInputing];
}

- (void)messageCellTappedHeadImage:(ChatMessageCell *)messageCell
{

}

- (void)messageCellTappedMessage:(ChatMessageCell *)messageCell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:messageCell];
    switch (messageCell.messageType)
    {
        case MessageTypeVoice:
        {
            NSString *voiceFileName = self.messageArray[indexPath.row][kMessageConfigurationVoiceKey];
            [[XMAVAudioPlayer sharePlayer] playAudioWithURLString:voiceFileName atIndex:indexPath.row];
            break;
        }
        case MessageTypeImage:
        case MessageTypeGifImage:
        {
            break;
        }

        case MessageTypeVideo:
        {
            break;
        }
            
        case MessageTypeLocation:
        {
            
            break;
        }
        case MessageTypeVoiceCall:
        case MessageTypeVideoCall:
        {
           
            break;
        }
        default:
            break;
    }
}

- (void)messageCell:(ChatMessageCell *)messageCell withActionType:(ChatMessageCellMenuActionType)actionType
{
    NSString *action = actionType == ChatMessageCellMenuActionTypeRelay ? @"转发" : @"复制";
    NSLog(@"messageCell :%@ willDoAction :%@",messageCell,action);
}


- (void)messageCellResend:(ChatMessageCell *)messageCell
{
    
}

- (void)messageCellCancel:(ChatMessageCell *)messageCell
{
    
}


#pragma mark - 私有方法
- (void)messageReadStateChanged:(MessageReadState)readState withProgress:(CGFloat)progress forIndex:(NSUInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    ChatMessageCell *messageCell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (![self.tableView.visibleCells containsObject:messageCell])
    {
        return;
    }
    messageCell.messageReadState = readState;
}

- (void)messageSendStateChanged:(MessageSendState)sendState withProgress:(CGFloat)progress forIndex:(NSUInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    ChatMessageCell *messageCell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (![self.tableView.visibleCells containsObject:messageCell])
    {
        return;
    }
    
    if ((MessageTypeImage == messageCell.messageType) ||
        (MessageTypeGifImage == messageCell.messageType))
    {
        [(ChatImageMessageCell *)messageCell setUploadProgress:progress];
    }
    else if (MessageTypeVideo == messageCell.messageType)
    {
        [(ChatVideoMessageCell *)messageCell setUploadProgress:progress];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
        messageCell.messageSendState = sendState;
    });
}

- (void)reloadAfterReceiveMessage:(NSDictionary *)message
{
    [self.tableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messageArray.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:.3f animations:^
     {
         [self.tableView mas_updateConstraints:^(MASConstraintMaker *make)
          {
//              make.height.equalTo(@(self.view.frame.size.height-105));
              [self.chatBar endInputing];
          }];
         
     } completion:nil];
}

#pragma mark - Getters方法

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - kMinHeight) style:UITableViewStylePlain];
        
        [_tableView registerChatMessageCellClass];
        _tableView.delegate           = self;
        _tableView.dataSource         = self;
        _tableView.backgroundColor    = self.backgroundColor;
        _tableView.estimatedRowHeight = 66;
        _tableView.contentInset       = UIEdgeInsetsMake(8, 0, 0, 0);
        _tableView.separatorStyle     = UITableViewCellSeparatorStyleNone;
        
        //加此imageview解决UITabelViewCell第一条记录显示起始高度问题
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 200)];
        _backgroundImageView.backgroundColor  = self.backgroundColor;
        [self addSubview:_backgroundImageView ] ;
    }
    return _tableView;
}

- (ChatToolsView *)chatBar
{
    if (!_chatBar)
    {
        _chatBar = [[ChatToolsView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kMinHeight)];
        
        [_chatBar setSuperViewHeight:ScreenHeight -iPhone_Safe_BottomNavH];
        [_chatBar setSuperViewWidth:[UIScreen mainScreen].bounds.size.width];
        
    }
    return _chatBar;
}

- (RecordView *)recordView
{
    if (!_recordView)
    {
        _recordView = [[RecordView alloc] init];
        _recordView.layer.cornerRadius = 10;
        _recordView.backgroundColor    = [UIColor blueColor];
        _recordView.clipsToBounds      = YES;
        _recordView.backgroundColor    = [UIColor colorWithWhite:0.3 alpha:1];
    }
    return _recordView;
}

- (void)addMessage:(NSDictionary *)message
{
    [self.messageArray addObject:message];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messageArray.count - 1 inSection:0];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
}


@end
