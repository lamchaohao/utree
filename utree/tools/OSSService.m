//
//  OSSService.m
//  utree
//
//  Created by 科研部 on 2019/11/13.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "OSSService.h"

@interface OSSService()
@property(nonatomic,strong)OSSFederationToken *token;

@end
 
@implementation OSSService

{
    OSSClient * client;
    
}


-(instancetype)initWithToken:(OSSFederationToken *)token
{
    self = [super init];
    if (self) {
       self.token = token;
        [self ossInit];
    }
    return self;
}


- (void)ossInit {
    id<OSSCredentialProvider> credential = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
        return self.token;
    }];
    client = [[OSSClient alloc] initWithEndpoint:OSS_ENDPOINT credentialProvider:credential];
}

-(void)uploadFile:(NSData *)fileData fileKey:(NSString *)fileKey fileIndex:(NSInteger)index
{
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = OSS_BUCKETNAME;
    put.objectKey = fileKey;
//    put.uploadingFileURL = [NSURL fileURLWithPath:filePath];//filePath
    put.uploadingData = fileData; // 直接上传NSData
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        [self.listener onUploadProgress:totalByteSent/totalBytesExpectedToSend fileName:fileKey fileIndex:index];
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    OSSTask * putTask = [client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"upload object success!");
            [self.listener onUploadResult:YES fileName:fileKey fileIndex:index];
        } else {
            [self.listener onUploadResult:NO fileName:fileKey fileIndex:index];
            NSLog(@"upload object failed, error: %@" , task.error);
        }
        return nil;
    }];
    // 可以等待任务完成
    // [putTask waitUntilFinished];
}

-(void)uploadFileWithPath:(NSString *)filePath fileKey:(NSString *)fileKey fileIndex:(NSInteger)index
{
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = OSS_BUCKETNAME;
    put.objectKey = fileKey;
    put.uploadingFileURL = [NSURL fileURLWithPath:filePath];//filePath
//    put.uploadingData = fileData; // 直接上传NSData
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        if ([self.listener respondsToSelector:@selector(onUploadProgress:fileName:fileIndex:)]) {
            CGFloat prog= totalByteSent*100/totalBytesExpectedToSend;
            prog/=100;
            NSLog(@"in ossservice progress %f",prog);
            [self.listener onUploadProgress:prog fileName:fileKey fileIndex:index];
        }
        
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    OSSTask * putTask = [client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"upload object success!");
            if ([self.listener respondsToSelector:@selector(onUploadResult:fileName:fileIndex:)]) {
                [self.listener onUploadResult:YES fileName:fileKey fileIndex:index];
            }
            
        } else {
            if ([self.listener respondsToSelector:@selector(onUploadResult:fileName:fileIndex:)]){
                 [self.listener onUploadResult:NO fileName:fileKey fileIndex:index];
            }
            
            NSLog(@"upload object failed, error: %@" , task.error);
        }
        return nil;
    }];
    // 可以等待任务完成
    // [putTask waitUntilFinished];
}


@end
