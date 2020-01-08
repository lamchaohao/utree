//
//  PostNoticeDC.h
//  utree
//
//  Created by 科研部 on 2019/11/13.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDataController.h"
#import "UploadFileDC.h"
NS_ASSUME_NONNULL_BEGIN


@interface PostNoticeDC : UploadFileDC

-(void)publishNoticeToServerWithTopic:(NSString *)topic content:(NSString *)cont enclosureDic:(NSDictionary *)dic WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)requestClassListWithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;


@end

NS_ASSUME_NONNULL_END
