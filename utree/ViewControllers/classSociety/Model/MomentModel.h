//
//  MomentModel.h
//  utree
//
//  Created by 科研部 on 2019/11/20.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileObject.h"
#import "TeacherModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MomentModel : NSObject
@property(nonatomic,strong)NSString *schoolCircleId;
@property(nonatomic,strong)NSNumber *hasLike;
@property(nonatomic,strong)NSString *picPath;
@property(nonatomic,strong)TeacherModel *teacherDo;
@property(nonatomic,strong)FileObject *video;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *createTime;
@property(nonatomic,strong)NSNumber *likeCount;
@property(nonatomic,strong)NSNumber *commentCount;
@property(nonatomic,strong)NSArray *picList;
@end

NS_ASSUME_NONNULL_END
