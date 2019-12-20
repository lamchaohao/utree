//
//  PostHomeworkApi.m
//  utree
//
//  Created by 科研部 on 2019/11/27.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "PostHomeworkApi.h"
#import "UTCache.h"
#import "FileObject.h"
@implementation PostHomeworkApi

{

    NSString *_topic;
    NSString *_content;
}

- (instancetype)initWithTopic:(NSString *)topic content:(NSString *)content
{
    self = [super init];
    if (self) {
        _topic = topic;
        _content = content;
        
    }
    return self;
}

- (NSString *)requestUrl
{
    return @"tmobile/task/publishWork";
    
}

- (id)requestArgument
{
   NSMutableDictionary *requedtDic = [[NSMutableDictionary alloc]initWithDictionary:@{
        @"topic":_topic,
        @"content":_content,
        @"classIds":_classIds,
        @"teacherSubjectId":_subjectId,
        @"token":[UTCache readToken],
        @"uploadOnline":@(_onlineSubmit)
    }];
    if(_onlineSubmit){
        [requedtDic setObject:_deadLine forKey:@"deadLine"];
    }
    if (_audioFileObject) {
        NSDictionary *audioDic=_audioFileObject.mj_keyValues;
        [requedtDic setObject:audioDic forKey:@"audio"];
    }
    
    if (_picList) {
        NSMutableArray *fildDicArray = [[NSMutableArray alloc]init];
        for (FileObject *file in _picList) {
            NSDictionary *fileDic= file.mj_keyValues;
            [fildDicArray addObject:fileDic];
        }
        [requedtDic setObject:fildDicArray forKey:@"pics"];
    }
    if (_link) {
        [requedtDic setObject:_link forKey:@"link"];
    }
    if (_videoFileObject) {
       NSDictionary *videoDic=_videoFileObject.mj_keyValues;
        [requedtDic setObject:videoDic forKey:@"video"];
    }
    
    NSMutableDictionary *prunedDictionary = [NSMutableDictionary dictionary];
    for (NSString * key in [requedtDic allKeys])
    {
        if (![[requedtDic objectForKey:key] isKindOfClass:[NSNull class]])
            [prunedDictionary setObject:[requedtDic objectForKey:key] forKey:key];
    }
    
    NSLog(@"homeworkapi %@",[NSString stringWithFormat:@"%@",prunedDictionary.mj_JSONString]);
    return @{@"param":[NSString stringWithFormat:@"%@",prunedDictionary.mj_JSONString]};
}


@end
