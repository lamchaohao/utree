//
//  AchievementModel.h
//  utree
//
//  Created by 科研部 on 2019/12/9.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScoreModel.h"
#import "TeacherModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AchievementModel : NSObject

@property(nonatomic,strong)NSString *uploadTime;
@property(nonatomic,strong)NSArray<ScoreModel *> *scoreList;
@property(nonatomic,strong)NSString *examId;
@property(nonatomic,strong)NSString *examType;
@property(nonatomic,strong)NSString *subjectName;

@property(nonatomic,assign)NSNumber *examAverage;
@property(nonatomic,assign)NSNumber *examMax;
@property(nonatomic,assign)NSNumber *examUnread;

@property(nonatomic,strong)TeacherModel *teacherDo;
@end

NS_ASSUME_NONNULL_END
