//
//  UploadFileDC.m
//  utree
//
//  Created by 科研部 on 2019/11/18.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UploadFileDC.h"
#import "FetchOSSTokenApi.h"
#import <AliyunOSSiOS/OSSService.h>
#import "OSSService.h"
#import "MD5Util.h"


@interface UploadFileDC()<OSSUploadListener>
@property(nonatomic,strong)OSSFederationToken *token;
@property(nonatomic,strong)NSMutableDictionary *md5Dic;
@property(nonatomic,strong)NSDate *lastFetchTokenTime;
@end

@implementation UploadFileDC

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self fetchTokenWithSuccess:nil failure:nil];
        self.md5Dic= [[NSMutableDictionary alloc]init];
        self.platform = @"phone";
    }
    return self;
}

-(void)fetchTokenWithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    self.lastFetchTokenTime = [NSDate dateWithTimeIntervalSinceNow:0];
    
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

#pragma mark public method
-(void)uploadFile:(NSString *)filePath mediaType:(NSString *)mType fileIndex:(NSInteger)fileIndex
{
    if ([self isBlankString:filePath]) {
        return;
    }
    NSDate* nowTime = [NSDate dateWithTimeIntervalSinceNow:0];
    double interval = nowTime.timeIntervalSinceNow - self.lastFetchTokenTime.timeIntervalSinceNow;
    
    if(interval>800){
        NSLog(@"距离上次fetchToken 间隔%f秒,重新获取",interval);
        [self fetchTokenWithSuccess:^(UTResult * _Nonnull result) {
            [self actionUploadFile:filePath mediaType:mType fileIndex:fileIndex];
        } failure:^(UTResult * _Nonnull result) {
             
        }];
    }else{
        [self actionUploadFile:filePath mediaType:mType fileIndex:fileIndex];
    }
    
}

#pragma mark public method
-(void)uploadFileData:(NSData *)data fileName:(NSString *)fileName mediaType:(NSString *)mType fileIndex:(NSInteger)fileIndex
{
    NSDate* nowTime = [NSDate dateWithTimeIntervalSinceNow:0];
    double interval = nowTime.timeIntervalSinceNow - self.lastFetchTokenTime.timeIntervalSinceNow;
    
    if(interval>800){
        NSLog(@"距离上次fetchToken 间隔%f秒,重新获取",interval);
        [self fetchTokenWithSuccess:^(UTResult * _Nonnull result) {
            [self actionUploadFileData:data fileName:fileName mediaType:mType fileIndex:fileIndex];
        } failure:^(UTResult * _Nonnull result) {
             
        }];
    }else{
        [self actionUploadFileData:data fileName:fileName mediaType:mType fileIndex:fileIndex];
        
    }


}


-(void)actionUploadFile:(NSString *)filePath mediaType:(NSString *)mType fileIndex:(NSInteger)fileIndex
{
    //    utree/archive/<teachId>/{pic}{audio}{video}/fileName
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSString *md5FileName = [MD5Util md5DigestWithData:data];
    
    NSString *fileExtension = [filePath pathExtension];//获取后缀名
    NSString *userId = [[UTCache readProfile] objectForKey:@"teacherId"];
    NSString *fullFileKey = [NSString stringWithFormat:@"utree/%@/%@/%@/%@.%@",self.platform,userId,mType,md5FileName,fileExtension];
    NSString *temp = [fullFileKey stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self.md5Dic setObject:md5FileName forKey:temp];
    NSLog(@"fullfileKey=%@",temp);
    if (self.token) {
        OSSService *service = [[OSSService alloc]initWithToken:self.token];
        service.listener = self;
        [service uploadFileWithPath:filePath fileKey:temp fileIndex:fileIndex];
    }
}

#pragma mark private method
-(void)actionUploadFileData:(NSData *)data fileName:(NSString *)fileName mediaType:(NSString *)mType fileIndex:(NSInteger)fileIndex
{
    //    utree/phone/<teachId>/{pic}{audio}{video}/fileName
    NSString *md5FileName = [MD5Util md5DigestWithData:data];
    NSString *fileExtension = [fileName pathExtension];//获取后缀名
    NSString *userId = [[UTCache readProfile] objectForKey:@"teacherId"];
    NSString *fullFileKey = [NSString stringWithFormat:@"utree/%@/%@/%@/%@.%@",self.platform,userId,mType,md5FileName,fileExtension];
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

@end
