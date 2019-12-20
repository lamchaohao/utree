//
//  MomentDC.h
//  utree
//
//  Created by 科研部 on 2019/11/20.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadFileDC.h"
#import "FileObject.h"
NS_ASSUME_NONNULL_BEGIN

@interface MomentDC : UploadFileDC

-(void)requestFirstTimeList:(BOOL)mySelfData limitItems:(NSNumber *)limit WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)requestMoreMoments:(BOOL)mySelfData limitItems:(NSNumber *)limit lastId:(NSString *)lastId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)requestLikeMoment:(NSString *)momentId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)postMomentWith:(NSString *)textContent video:(FileObject *)videoFile WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)postMomentWith:(NSString *)textContent pictures:(NSArray *)pictures WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)postMomentWithText:(NSString *)textContent WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)deleteMomentById:(NSString *)momentId WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

@end

NS_ASSUME_NONNULL_END
