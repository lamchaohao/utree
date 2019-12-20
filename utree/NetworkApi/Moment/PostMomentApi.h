//
//  PostMomentApi.h
//  utree
//
//  Created by 科研部 on 2019/11/22.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTBaseRequest.h"
#import "FileObject.h"
NS_ASSUME_NONNULL_BEGIN

@interface PostMomentApi : UTBaseRequest

- (instancetype)initWithPictures:(NSArray *)pics contents:(NSString *)contents;

- (instancetype)initWithVideo:(FileObject *)video contents:(NSString *)contents;

- (instancetype)initWithText:(NSString *)contents;
@end

NS_ASSUME_NONNULL_END
