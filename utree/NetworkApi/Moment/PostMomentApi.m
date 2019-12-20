//
//  PostMomentApi.m
//  utree
//
//  Created by 科研部 on 2019/11/22.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "PostMomentApi.h"
#import "UTCache.h"
@implementation PostMomentApi


{
    int momentType;
    NSString *textContent;
    NSArray *upLoadPics;
    FileObject *videoFile;
}

- (instancetype)initWithPictures:(NSArray *)pics contents:(NSString *)contents
{
    self = [super init];
    if (self) {
        momentType = 1;
        upLoadPics = pics;
        textContent = contents;
    }
    return self;
}

- (instancetype)initWithVideo:(FileObject *)video contents:(NSString *)contents
{
    self = [super init];
    if (self) {
        momentType = 2;
        videoFile = video;
        textContent = contents;
    }
    return self;
}

- (instancetype)initWithText:(NSString *)contents
{
    self = [super init];
    if (self) {
        momentType = 3;
        textContent = contents;
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"tmobile/schoolCircle/pushCircle";
}

- (id)requestArgument
{
    
    if (momentType ==2) {
        NSDictionary *fileDic= videoFile.mj_keyValues;
        NSMutableDictionary *requesdtDic = [[NSMutableDictionary alloc]initWithDictionary:@{
            @"content":textContent,
            @"token":[UTCache readToken],
            @"video":fileDic
        }];
        return @{@"param":[NSString stringWithFormat:@"%@",requesdtDic.mj_JSONString]};
    }else if(momentType==1){
        NSMutableArray *fildDicArray = [[NSMutableArray alloc]init];
        for (FileObject *file in upLoadPics) {
            NSDictionary *fileDic= file.mj_keyValues;
            [fildDicArray addObject:fileDic];
        }
        NSMutableDictionary *requesdtDic = [[NSMutableDictionary alloc]initWithDictionary:@{
            @"content":textContent,
            @"token":[UTCache readToken],
            @"pics":fildDicArray
        }];
        return @{@"param":[NSString stringWithFormat:@"%@",requesdtDic.mj_JSONString]};
    }else{
        NSMutableDictionary *requesdtDic = [[NSMutableDictionary alloc]initWithDictionary:@{
                   @"content":textContent,
                   @"token":[UTCache readToken],
               }];
        return @{@"param":[NSString stringWithFormat:@"%@",requesdtDic.mj_JSONString]};
    }
    
}


@end
