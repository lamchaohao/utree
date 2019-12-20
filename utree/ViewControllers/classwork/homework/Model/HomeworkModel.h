//
//  HomeworkModel.h
//  utree
//
//  Created by 科研部 on 2019/11/20.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileObject.h"
#import "TeacherModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeworkModel : NSObject
@property(nonatomic,strong)NSString *workId;
@property(nonatomic,strong)NSString *topic;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSNumber *readType;
@property(nonatomic,strong)NSNumber *uploadOnline;
@property(nonatomic,strong)NSString *picPath;
@property(nonatomic,strong)TeacherModel *teacherDo;
@property(nonatomic,strong)FileObject *audio;
@property(nonatomic,strong)FileObject *video;
@property(nonatomic,strong)NSString *link;
@property(nonatomic,strong)NSString *subjectName;
@property(nonatomic,strong)NSString *createTime;
@property(nonatomic,strong)NSString *deadline;
@property(nonatomic,strong)NSNumber *submit;
@property(nonatomic,strong)NSNumber *unCheck;
@property(nonatomic,assign)NSNumber *unread;
@property(nonatomic,strong)NSArray *picList;
@property(nonatomic,strong)NSNumber *allCheckNum;
@end

NS_ASSUME_NONNULL_END
