//
//  ChatContactCell.h
//  utree
//
//  Created by 科研部 on 2019/12/11.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecentContact.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChatContactCell : UITableViewCell

@property(nonatomic,strong)UILabel *timeLabel;

-(void)setDataToView:(RecentContact *)parent;

@end

NS_ASSUME_NONNULL_END
