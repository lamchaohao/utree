//
//  UTMessageCell.h
//  utree
//
//  Created by 科研部 on 2019/12/17.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUMessageContentButton.h"
#import "UTMessageFrame.h"
NS_ASSUME_NONNULL_BEGIN
@class UTMessageCell;

@protocol UTMessageCellDelegate <NSObject>
@optional
- (void)chatCell:(UTMessageCell *)cell headImageDidClick:(NSString *)userId;
@optional
-(void)onCellMediaClick:(UTMessageCell *)cell;

@end


@interface UTMessageCell : UITableViewCell

@property (nonatomic, strong) UUMessageContentButton *btnContent;

@property (nonatomic, strong) UTMessageFrame *messageFrame;

@property (nonatomic, weak) id<UTMessageCellDelegate> delegate;


@end

NS_ASSUME_NONNULL_END





