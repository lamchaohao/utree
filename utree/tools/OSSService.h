//
//  OSSService.h
//  utree
//
//  Created by 科研部 on 2019/11/13.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AliyunOSSiOS/OSSService.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OSSUploadListener <NSObject>

-(void)onUploadProgress:(CGFloat)progress fileName:(NSString *)fileName fileIndex:(NSInteger)index;

-(void)onUploadResult:(BOOL)success fileName:(NSString *)fileName fileIndex:(NSInteger)index;

@end

@interface OSSService : NSObject

-(instancetype)initWithToken:(OSSFederationToken *)token;

-(void)uploadFile:(NSData *)fileData fileKey:(NSString *)fileKey fileIndex:(NSInteger)index;

-(void)uploadFileWithPath:(NSString *)filePath fileKey:(NSString *)fileKey fileIndex:(NSInteger)index;

@property(nonatomic,assign)id<OSSUploadListener> listener;

@end

NS_ASSUME_NONNULL_END
