//
//  RecentContact.h
//  utree
//
//  Created by 科研部 on 2019/12/19.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UTMessage.h"
#import "UTParent.h"
NS_ASSUME_NONNULL_BEGIN

@interface RecentContact : NSObject

@property(nonatomic,strong)UTParent *parent;
@property(nonatomic,strong)UTMessage *lastMessage;
@property(nonatomic,assign)int unreadCount;
@end

NS_ASSUME_NONNULL_END
