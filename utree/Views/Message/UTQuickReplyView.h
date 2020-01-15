//
//  UTQuickReplyView.h
//  utree
//
//  Created by 科研部 on 2020/1/8.
//  Copyright © 2020 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UTQuickReplyDelegate <NSObject>

-(void)onOpenInputDialogToAdd;

-(void)onEditReplySentence:(NSString *)reply index:(int)index;

-(void)onReplyClickToSend:(NSString *)reply;

@end

@interface UTQuickReplyView : MyRelativeLayout


@property(nonatomic,weak)id<UTQuickReplyDelegate> delegate;

-(void)onAddedReply:(NSString *)reply;

-(void)onFinishEdit:(NSString *)reply oldIndex:(int)index;

@end

NS_ASSUME_NONNULL_END
