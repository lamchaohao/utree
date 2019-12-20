//
//  PostHomeworkDC.h
//  utree
//
//  Created by 科研部 on 2019/11/27.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UploadFileDC.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostHomeworkDC : UploadFileDC

-(void)requestClassAndSubjectsWithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)publishTaskToServerWithTopic:(NSString *)topic content:(NSString *)cont enclosureDic:(NSDictionary *)dic WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;


@end

NS_ASSUME_NONNULL_END
