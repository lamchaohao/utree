//
//  NoticeMessageCell.h
//  utree
//
//  Created by 科研部 on 2019/12/24.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeMessageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeMessageCell : UITableViewCell

@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UIView *unreadDotView;
-(void)setNoticeMsgToView:(NoticeMessageModel *)parent;


@end

NS_ASSUME_NONNULL_END
