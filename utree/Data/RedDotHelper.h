//
//  RedDotHelper.h
//  utree
//
//  Created by 科研部 on 2020/1/14.
//  Copyright © 2020 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RedDotHelper : NSObject

@property(nonatomic,assign)int noticeUnread;

@property(nonatomic,assign)int studentTaskUnread;
@property(nonatomic,assign)int examUnread;
@property(nonatomic,assign)int circleUnread;
@property(nonatomic,assign)int systemUnread;
@property(nonatomic,assign)int chatUnread;
@property(nonatomic,assign)int schoolMsgUnread;

+(instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END
