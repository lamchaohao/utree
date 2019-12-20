//
//  ChatView.h
//  utree
//
//  Created by 科研部 on 2019/12/12.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordView.h"
#import "KeyboardView.h"
#import "ChatToolsView.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChatView : UIView

@property (strong, nonatomic) ChatToolsView    *chatBar;
@property (strong, nonatomic) RecordView      *recordView;

- (void)chatBarFrameDidChange:(ChatToolsView *)chatBar frame:(CGRect)frame;

- (void)addMessage:(NSDictionary *)message;
@end

NS_ASSUME_NONNULL_END
