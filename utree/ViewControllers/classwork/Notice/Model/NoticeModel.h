//
//  NoticeModel.h
//  utree
//
//  Created by 科研部 on 2019/11/15.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileObject.h"
#import "TeacherModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeModel : NSObject

@property(nonatomic,strong)NSString *noticeId;
@property(nonatomic,strong)NSString *topic;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *link;
@property(nonatomic,strong)NSNumber *readType;//2为仅家长可见
@property(nonatomic,assign)NSNumber *needReceipt;
@property(nonatomic,strong)NSString *picPath;
@property(nonatomic,strong)TeacherModel *teacherDo;
@property(nonatomic,strong)FileObject *audio;
@property(nonatomic,strong)NSString *createTime;
@property(nonatomic,strong)NSNumber *unCheck;
@property(nonatomic,assign)NSNumber *unread;
@property(nonatomic,strong)NSArray *picList;
@property(nonatomic,strong)NSNumber *allCheckNum;
@property(nonatomic,strong)NSMutableArray *thumnails;
@end

NS_ASSUME_NONNULL_END
