//
//  PostNoticeDC.h
//  utree
//
//  Created by 科研部 on 2019/11/13.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDataController.h"
NS_ASSUME_NONNULL_BEGIN

@protocol PostNoticeFileListener <NSObject>

- (void)onFileUploadProgress:(CGFloat)progress filePath:(NSString *)filePath fileIndex:(NSInteger)index;

-(void)onFileUploadResult:(BOOL)success filePath:(NSString *)filePath fileIndex:(NSInteger)index md5Value:(NSString *)md5Str;

@end

@interface PostNoticeDC : BaseDataController

@property(nonatomic,assign)id<PostNoticeFileListener> uploadListener;

-(void)uploadFile:(NSString *)filePath mediaType:(NSString *)mType fileIndex:(NSInteger)fileIndex;

-(void)uploadFileData:(NSData *)data fileName:(NSString *)fileName mediaType:(NSString *)mType fileIndex:(NSInteger)fileIndex;

-(void)publishNoticeToServerWithTopic:(NSString *)topic content:(NSString *)cont enclosureDic:(NSDictionary *)dic WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

-(void)requestClassListWithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;


@end

NS_ASSUME_NONNULL_END
