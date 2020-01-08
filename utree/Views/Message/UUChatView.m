//
//  UUChatView.m
//  utree
//
//  Created by 科研部 on 2019/12/16.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UUChatView.h"
#import "Masonry.h"
//#import "UUInputFunctionView.h"
#import "UTMessageCell.h"
#import "ChatModel.h"
#import "UTMessageFrame.h"
#import "UTMessage.h"
#import "UUChatCategory.h"
#import "ChatMessageDC.h"
#import "UUInputToolsView.h"
#import "RecordView.h"
#import "AVAudioPlayer.h"
#import "UUChatFunctionView.h"

@interface UUChatView ()<UUInputToolsViewDelegate, UTMessageCellDelegate, UITableViewDataSource, UITableViewDelegate,RecordViewDelegate,XMAVAudioPlayerDelegate,UUChatFunctioViewDataSource,UUChatFunctioViewDelegate>
{
    CGFloat _keyboardHeight;
    BOOL _isShowFunctionView;
}

@property (strong, nonatomic) UITableView *chatTableView;

@property (strong, nonatomic) RecordView *recordView; /**< 语音聊天录音指示view */

@property (strong, nonatomic) UUInputToolsView *inputFuncView;

@property (strong, nonatomic)ChatMessageDC *dataController;

@property (assign, nonatomic)UTMessageCell *focusCell;

@property (strong, nonatomic)UUChatFunctionView *moreView;

@end

@implementation UUChatView

- (instancetype)initWithFrame:(CGRect)frame andDataSource:(ChatMessageDC *)dc
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataController = dc;
        [XMAVAudioPlayer sharePlayer].delegate = self;
        [self setupUI];
    }
    return self;
}


-(void)setupUI
{
    [self initBasicViews];
    _chatTableView.frame = CGRectMake(0, 0, self.uu_width, self.uu_height-40-iPhone_Safe_BottomNavH);
    _inputFuncView.frame = CGRectMake(0, _chatTableView.uu_bottom, self.uu_width, 40);
    
    self.recordView.hidden = YES;
    self.recordView.center = self.center;
    self.recordView.delegate = self;
    [self addSubview:self.recordView];
}

- (void)updateConstraints
{
    [super updateConstraints];
    [self.recordView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.width.mas_equalTo (@(155));
        make.height.mas_equalTo (@(170));
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
        make.centerY.equalTo(self.mas_centerY).with.offset(0);
    }];
}

- (void)VCviewDidAppear:(BOOL)animated
{
    
    //add notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustCollectionViewLayout) name:UIDeviceOrientationDidChangeNotification object:nil];
//    [self tableViewScrollToBottom];
}

- (void)VCviewWillDisappear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)notifyLoadMoreMessageFinish:(int64_t)pageNum
{
    if (pageNum==0) {
        [self.chatTableView.mj_header endRefreshing];
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:pageNum-1 inSection:0];
    [self.chatTableView reloadData];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self.chatTableView.mj_header endRefreshing];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_inputFuncView.textViewInput.isFirstResponder) {
        _chatTableView.frame = CGRectMake(0, 0, self.uu_width, self.uu_height-40-_keyboardHeight);
        _inputFuncView.frame = CGRectMake(0, _chatTableView.uu_bottom, self.uu_width, 40);
    } else {
        if(_isShowFunctionView){
            _chatTableView.frame = CGRectMake(0, 0, self.uu_width, self.uu_height-40-iPhone_Safe_BottomNavH-210);
            _inputFuncView.frame = CGRectMake(0, _chatTableView.uu_bottom, self.uu_width, 40);
            _moreView.frame=CGRectMake(0, _inputFuncView.uu_bottom, self.uu_width, 210);
        }else{
            _chatTableView.frame = CGRectMake(0, 0, self.uu_width, self.uu_height-40-iPhone_Safe_BottomNavH);
            _inputFuncView.frame = CGRectMake(0, _chatTableView.uu_bottom, self.uu_width, 40);
        }
        
    }
}

- (void)initBasicViews
{
    _chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.uu_width, self.uu_height-40-iPhone_Safe_BottomNavH) style:UITableViewStylePlain];
    _chatTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _chatTableView.backgroundColor = [UIColor myColorWithHexString:@"#F7F7F7"];
    _chatTableView.delegate = self;
    _chatTableView.dataSource = self;
    [self addSubview:_chatTableView];
    
    [_chatTableView registerClass:[UTMessageCell class] forCellReuseIdentifier:NSStringFromClass([UTMessageCell class])];
    
    _inputFuncView = [[UUInputToolsView alloc] initWithFrame:CGRectMake(0, _chatTableView.uu_bottom, self.uu_width, 40)];
    _inputFuncView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    _inputFuncView.delegate = self;
    [self addSubview:_inputFuncView];
    self.chatTableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRefreshData)];
    
}


#pragma mark load more messages
-(void)loadRefreshData
{
    [self.dataDelegate loadMoreMessage];
}



#pragma mark - notification event

//tableView Scroll to bottom
- (void)tableViewScrollToBottom
{
    if (self.dataController.dataSource.count==0) { return; }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataController.dataSource.count-1 inSection:0];
    
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    _keyboardHeight = keyboardEndFrame.size.height;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    _isShowFunctionView=NO;
    self.chatTableView.uu_height = self.uu_height - _inputFuncView.uu_height;
    self.chatTableView.uu_height -= notification.name == UIKeyboardWillShowNotification ? _keyboardHeight:iPhone_Safe_BottomNavH;
    self.chatTableView.contentOffset = CGPointMake(0, self.chatTableView.contentSize.height-self.chatTableView.uu_height);

    self.inputFuncView.uu_top = self.chatTableView.uu_bottom;
    [self.moreView removeFromSuperview];
    
    [UIView commitAnimations];
    
}

- (void)adjustCollectionViewLayout
{
    [self.dataDelegate recountFrame];
    [self.chatTableView reloadData];
}

#pragma mark - InputFunctionViewDelegate

- (void)UUInputToolsView:(UUInputToolsView *)funcView sendMessage:(NSString *)message
{
    NSDictionary *dic = @{Key_Content_Text: message,
                          Key_Type: @(UTMessageTypeText)};
    funcView.textViewInput.text = @"";
    [funcView changeSendBtnWithPhoto:YES];
    [self dealTheFunctionData:dic];
}

- (void)UUInputToolsView:(UUInputToolsView *)funcView sendPicture:(NSArray *)photos assets:(NSArray *)picAssets
{
    for (int index=0; index<picAssets.count; index++) {
        
        NSDictionary *dic = @{Key_Pic_Data: photos[index],
                              Key_Pic_Asset: picAssets[index],
                              Key_Type: @(UTMessageTypePicture)};
        [self dealTheFunctionData:dic];
    }
    
}

- (void)UUInputToolsView:(UUInputToolsView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second
{
    //交由 (void)recordFinish:(NSData *)data duration:(float)duration
}

- (void)showFunctionView
{
    _isShowFunctionView = !_isShowFunctionView;
    if(_isShowFunctionView){
        
        self.chatTableView.uu_height = self.uu_height-210;
        [self addSubview:self.moreView];
        [self tableViewScrollToBottom];
        
    }else{
        [UIView animateWithDuration:.3 animations:^
        {
            self.chatTableView.uu_height = self.uu_height-self.inputFuncView.uu_height;
            [self.moreView removeFromSuperview];
        }];
        [self tableViewScrollToBottom];
    }
    self.inputFuncView.uu_top = self.chatTableView.uu_bottom;
    self.moreView.uu_top=self.inputFuncView.uu_bottom;
}

- (void)startRecordAudio
{
    [self.recordView setHidden:NO];
    [self.recordView startRecordVoice];
}

#pragma mark XMAVAudioHelperDelegate
- (void)audioPlayerStateDidChanged:(VoiceMessageState)audioPlayerState forIndex:(NSUInteger)index
{
    switch (audioPlayerState) {
        case VoiceMessageStateNormal:
        {
            NSLog(@"未播放状态");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.focusCell.btnContent stopPlay];
            });
        }
            break;
        case VoiceMessageStateDownloading:
        {
            NSLog(@"正在下载中");//正在下载中
           dispatch_async(dispatch_get_main_queue(), ^{
               [self.focusCell.btnContent benginLoadVoice];
           });
        }
           
            break;
        case VoiceMessageStatePlaying://正在播放
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.focusCell.btnContent didLoadVoice];
            });
                       
            NSLog(@"正在播放");
            
        }
            break;
        case VoiceMessageStateCancel:
        {
            NSLog(@"播放被取消");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.focusCell.btnContent stopPlay];
            });
        }
            
            break;
        default:
            break;
    }
}


#pragma mark RecordViewDelegate recordFinish callback
- (void)recordFinish:(NSString *)url duration:(NSString *)duration
{
    if(duration.floatValue<1.0){
        return;
    }
    NSDictionary *dic = @{Key_Voice_URL: url,
                          Key_Voice_Duration: duration,
                          Key_Type: @(UTMessageTypeVoice)};
    [self dealTheFunctionData:dic];
}


- (void)cancleRecordAudio
{
    [self.recordView cancelRecordVoice];
}

- (void)endRecordVoice
{
    [self.recordView endRecordVoice];
    self.recordView.hidden = YES;
}

- (void)remindRecordDragEnter
{
    [self.recordView updateContinueRecordVoice];
}

- (void)remindRecordDragExit
{
    [self.recordView updateCancelRecordVoice];
}

- (void)dealTheFunctionData:(NSDictionary *)dic
{
    [self.dataDelegate addMessage:dic];
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
}

- (void)notifyReceiveNewMessage
{
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
}

- (void)notifyMessageSendStatusAtIndexPath:(NSIndexPath *)indexPath
{
    [self.chatTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - tableView delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataController.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UTMessageCell class])];
    cell.delegate = self;
    cell.messageFrame = self.dataController.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataController.dataSource[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endEditing:YES];
}

#pragma mark - UUMessageCellDelegate

- (void)chatCell:(UTMessageCell *)cell headImageDidClick:(NSString *)userId
{
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:cell.messageFrame.message.accountName message:@"headImage clicked" delegate:nil cancelButtonTitle:@"sure" otherButtonTitles:nil];
//    [alert show];
}

- (void)onCellMediaClick:(UTMessageCell *)cell
{
    if (self.focusCell) {
        //如果之前有在播放，先停止
        [self.focusCell.btnContent stopPlay];
    }
    self.focusCell = cell;
    if(cell.messageFrame.message.type==UTMessageTypeVoice){
    [[XMAVAudioPlayer sharePlayer] playAudioWithURLString:cell.messageFrame.message.voiceUrl atIndex:1 ];

    }
}

#pragma mark - ChatMoreViewDelegate & ChatMoreViewDataSource
- (void)moreView:(UUChatFunctionView *)moreView selectIndex:(ChatFunctionItemType)itemType
{
    switch (itemType) {
        case FunctionTakePic:
            [self.inputFuncView onFunctionActionClick:0];
            break;
        case FunctionSelectPic:
            [self.inputFuncView onFunctionActionClick:1];
            break;
        case FunctionPhrasebook:
            [self.inputFuncView onFunctionActionClick:2];
            break;
        default:
            break;
    }
    
    
}


- (NSArray *)titlesOfMoreView:(UUChatFunctionView *)moreView
{
    return @[@"拍照",
             @"照片",
             @"常用语"];
}

- (NSArray *)imageNamesOfMoreView:(UUChatFunctionView *)moreView
{
    return @[@"ic_chat_take_photo",
             @"ic_chat_select_photo",
             @"ic_chat_phrasebook"];
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

- (UUChatFunctionView *)moreView
{
    if (!_moreView)
    {
        _moreView = [[UUChatFunctionView alloc] initWithFrame:CGRectMake(0,_chatTableView.uu_bottom+40, self.uu_width, 210)];
        _moreView.delegate = self;
        _moreView.dataSource = self;
        _moreView.backgroundColor = self.backgroundColor;
    }
    return _moreView;
}

@end
