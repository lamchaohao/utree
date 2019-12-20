//
//  PostNoticeApi.m
//  utree
//
//  Created by 科研部 on 2019/11/15.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "PostNoticeApi.h"
#import "FileObject.h"
#import "UTCache.h"
@implementation PostNoticeApi


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
    return @"tmobile/task/saveNotice";
    
}



- (id)requestArgument
{
   NSMutableDictionary *requedtDic = [[NSMutableDictionary alloc]initWithDictionary:@{
        @"topic":_topic,
        @"content":_content,
        @"readType":_readType,
        @"classIds":_classIds,
        @"token":[UTCache readToken],
        @"needReceipt":@(_needReceipt)
    }];
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
    
    NSMutableDictionary *prunedDictionary = [NSMutableDictionary dictionary];
    for (NSString * key in [requedtDic allKeys])
    {
        if (![[requedtDic objectForKey:key] isKindOfClass:[NSNull class]])
            [prunedDictionary setObject:[requedtDic objectForKey:key] forKey:key];
    }
    
    NSLog(@"notice %@",[NSString stringWithFormat:@"%@",prunedDictionary.mj_JSONString]);
    return @{@"param":[NSString stringWithFormat:@"%@",prunedDictionary.mj_JSONString]};
}



@end
