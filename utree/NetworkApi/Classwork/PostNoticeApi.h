//
//  PostNoticeApi.h
//  utree
//
//  Created by 科研部 on 2019/11/15.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostNoticeApi : UTBaseRequest

- (instancetype)initWithTopic:(NSString *)topic content:(NSString *)content;

@property(nonatomic,assign)NSDictionary *audioFileObject;
@property(nonatomic,assign)NSArray *picList;
@property(nonatomic,assign)NSString *link;
@property(nonatomic,assign)NSArray *classIds;
@property(nonatomic,assign)NSNumber *readType;
@property(nonatomic,assign)BOOL needReceipt;

@end

NS_ASSUME_NONNULL_END
