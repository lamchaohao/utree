//
//  PostNoticeDC.m
//  utree
//
//  Created by 科研部 on 2019/11/13.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "PostNoticeDC.h"
#import "FetchOSSTokenApi.h"
#import <AliyunOSSiOS/OSSService.h>
#import "OSSService.h"
#import "MD5Util.h"
#import "PostNoticeApi.h"
#import "TeachClassApi.h"
#import "UTClassModel.h"
@interface PostNoticeDC()<OSSUploadListener>

@property(nonatomic,strong)OSSFederationToken * token;
@property(nonatomic,strong)NSMutableDictionary *md5Dic;
@end


@implementation PostNoticeDC

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self fetchToken];
        self.md5Dic= [[NSMutableDictionary alloc]init];
    }
    return self;
}

-(void)fetchToken
{
    FetchOSSTokenApi *api = [[FetchOSSTokenApi alloc]init];

    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"success-%ld,%@",request.response.statusCode,request.responseString);
        if (request.response.statusCode==200) {
            NSString *json = request.responseString;
            NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *object = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
            
//            NSDictionary *object = [request responseObject];
            NSLog(@"FetchOSSTokenApi response = %@", object);
            OSSFederationToken * token = [OSSFederationToken new];
            token.tAccessKey = [object objectForKey:@"AccessKeyId"];
            token.tSecretKey = [object objectForKey:@"AccessKeySecret"];
            token.tToken = [object objectForKey:@"SecurityToken"];
            token.expirationTimeInGMTFormat = [object objectForKey:@"Expiration"];
            NSLog(@"AccessKey: %@ \n SecretKey: %@ \n Token:%@ expirationTime: %@ \n",
                  token.tAccessKey, token.tSecretKey, token.tToken, token.expirationTimeInGMTFormat);
             self.token = token;
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"failure-%@,code=%ld,%ld",request.responseString,request.response.statusCode,request.error.code);
    }];
 
    
}

-(void)uploadFile:(NSString *)filePath mediaType:(NSString *)mType fileIndex:(NSInteger)fileIndex
{
    if ([self isBlankString:filePath]) {
        return;
    }
//    utree/archive/<teachId>/{pic}{audio}{video}/fileName
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSString *md5FileName = [MD5Util md5DigestWithData:data];
    
    NSString *fileExtension = [filePath pathExtension];//获取后缀名
    NSString *userId = [[UTCache readProfile] objectForKey:@"teacherId"];
    NSString *fullFileKey = [NSString stringWithFormat:@"utree/phone/%@/%@/%@.%@",userId,mType,md5FileName,fileExtension];
    NSString *temp = [fullFileKey stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self.md5Dic setObject:md5FileName forKey:temp];
    NSLog(@"fullfileKey=%@",temp);
    if (self.token) {
        OSSService *service = [[OSSService alloc]initWithToken:self.token];
        service.listener = self;
        [service uploadFileWithPath:filePath fileKey:temp fileIndex:fileIndex];
    }
    
}

-(void)uploadFileData:(NSData *)data fileName:(NSString *)fileName mediaType:(NSString *)mType fileIndex:(NSInteger)fileIndex
{

//    utree/phone/<teachId>/{pic}{audio}{video}/fileName
    
    NSString *md5FileName = [MD5Util md5DigestWithData:data];
    NSString *fileExtension = [fileName pathExtension];//获取后缀名
    NSString *userId = [[UTCache readProfile] objectForKey:@"teacherId"];
    NSString *fullFileKey = [NSString stringWithFormat:@"utree/phone/%@/%@/%@.%@",userId,mType,md5FileName,fileExtension];
    NSString *temp = [fullFileKey stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self.md5Dic setObject:md5FileName forKey:temp];
    NSLog(@"fullfileKey=%@",temp);
    if (self.token) {
        OSSService *service = [[OSSService alloc]initWithToken:self.token];
        service.listener = self;
        [service uploadFile:data fileKey:temp fileIndex:fileIndex];
    }

}

- (void)onUploadProgress:(CGFloat)progress fileName:(NSString *)fileName fileIndex:(NSInteger)index
{
    if ([self.uploadListener respondsToSelector:@selector(onFileUploadProgress:filePath:fileIndex:)]) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.uploadListener onFileUploadProgress:progress filePath:fileName fileIndex:index];
        }];
      
    }
}

-(void)onUploadResult:(BOOL)success fileName:(NSString *)fileName fileIndex:(NSInteger)index
{
    if ([self.uploadListener respondsToSelector:@selector(onFileUploadResult:filePath:fileIndex:md5Value:)]) {
        NSString *md5=[self.md5Dic objectForKey:fileName];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
           [self.uploadListener onFileUploadResult:success filePath:fileName fileIndex:index md5Value:md5];
        }];
        
    }
}


-(void)publishNoticeToServerWithTopic:(NSString *)topic content:(NSString *)cont enclosureDic:(NSDictionary *)dic WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    PostNoticeApi *api= [[PostNoticeApi alloc]initWithTopic:topic content:cont];
    [api setLink: [dic objectForKey:@"link"]];
    [api setPicList:[dic objectForKey:@"pics"]];
    [api setClassIds:[dic objectForKey:@"classIds"]];
    [api setAudioFileObject:[dic objectForKey:@"audio"]];
    [api setReadType: [dic objectForKey:@"readType"]];
    NSNumber * boolNum = dic[@"needReceipt"];
    [api setNeedReceipt:[boolNum boolValue]];
    
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        if (success) {
            success([[UTResult alloc]initWithSuccess:successMsg.responseData]);
        }
    } onFailure:^(FailureMsg * _Nonnull message) {
        if (failure) {
            failure([[UTResult alloc]initWithFailure:message.message]);
        }
    }];
    
}

-(void)requestClassListWithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    TeachClassApi *api = [[TeachClassApi alloc]init];
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
         NSArray *classArray = [UTClassModel mj_objectArrayWithKeyValuesArray:successMsg.responseData];
        if (success) {
            success([[UTResult alloc]initWithSuccess:classArray]);
        }
    } onFailure:^(FailureMsg * _Nonnull message) {
        if (failure) {
            failure([[UTResult alloc]initWithFailure:message.message]);
        }
    }];
}


@end
