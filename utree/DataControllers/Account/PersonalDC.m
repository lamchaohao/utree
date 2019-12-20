//
//  PersonalDC.m
//  utree
//
//  Created by 科研部 on 2019/11/18.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "PersonalDC.h"
#import "UpdateAvatarApi.h"
#import "UploadFileDC.h"

@interface PersonalDC()


@end
@implementation PersonalDC



-(void)requestUpdateAvatarWithFile:(FileObject *)file WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure
{
    NSDictionary *fileDic= file.mj_keyValues;
    
    UpdateAvatarApi *api = [[UpdateAvatarApi alloc]initWithDataDictionary:fileDic];
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        if (success) {
            NSMutableDictionary *personDic = [[NSMutableDictionary alloc]initWithDictionary:[UTCache readProfile]];;
            
            NSMutableString  *prefixPath = [[NSMutableString alloc ] initWithString :OSS_ENDPOINT];
            [prefixPath insertString:@"." atIndex:8];
            [prefixPath insertString:OSS_BUCKETNAME atIndex:8];
            [personDic setObject:[NSString stringWithFormat:@"%@%@",prefixPath,file.path] forKey:@"filePath"];
            NSLog(@"headviewUrl-%@",[NSString stringWithFormat:@"%@%@",prefixPath,file.path]);
            [UTCache savePersonalProfile:personDic];
            success([[UTResult alloc]initWithSuccess:successMsg.responseData]);
        }
    } onFailure:^(FailureMsg * _Nonnull message) {
        if (failure) {
            failure([[UTResult alloc]initWithFailure:message.message]);
        }
    }];
}

@end
