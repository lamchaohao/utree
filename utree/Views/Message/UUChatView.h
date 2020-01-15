//
//  UUChatView.h
//  utree
//
//  Created by 科研部 on 2019/12/16.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UTMessageFrame.h"
#import "ChatMessageDC.h"
NS_ASSUME_NONNULL_BEGIN

//刷新完成回调
typedef void(^UTChatloadFinishBlock)(NSArray *messageList);

@protocol ChatMessageViewDelegate <NSObject>

-(void)loadMoreMessage;

-(void)recountFrame;

-(void)addMessage:(NSDictionary *)dic;

-(void)showViewController:(UIViewController *)vc;

-(void)viewControllerDidFinish;

@end

@interface UUChatView : UIView

- (instancetype)initWithFrame:(CGRect)frame andDataSource:(ChatMessageDC *)dc;

- (void)VCviewDidAppear:(BOOL)animated;

- (void)VCviewWillDisappear:(BOOL)animated;

@property(nonatomic,assign)id<ChatMessageViewDelegate> dataDelegate;

- (void)notifyLoadMoreMessageFinish:(int64_t)pageNum;

- (void)notifyReceiveNewMessage;

- (void)notifyMessageSendStatusAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
