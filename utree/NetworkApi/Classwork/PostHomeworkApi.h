//
//  PostHomeworkApi.h
//  utree
//
//  Created by 科研部 on 2019/11/27.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostHomeworkApi : UTBaseRequest

- (instancetype)initWithTopic:(NSString *)topic content:(NSString *)content;

@property(nonatomic,assign)NSDictionary *audioFileObject;
@property(nonatomic,assign)NSDictionary *videoFileObject;
@property(nonatomic,assign)NSArray *picList;
@property(nonatomic,assign)NSString *link;
@property(nonatomic,assign)NSArray *classIds;
@property(nonatomic,assign)NSString *subjectId;
@property(nonatomic,assign)NSString *deadLine;
@property(nonatomic,assign)BOOL onlineSubmit;
@end

NS_ASSUME_NONNULL_END
