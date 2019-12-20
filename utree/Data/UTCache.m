//
//  UTCache.m
//  utree
//
//  Created by 科研部 on 2019/10/24.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTCache.h"

@implementation UTCache

static NSString *TokenCache = @"token_plist";
static NSString *ClassCache = @"class_plist";
static NSString *ProfileCache = @"profile_plist";
static NSString *GroupPlanCache = @"group_plist";
static NSString *CommentCache = @"comment_plist";

+(NSString *)appendFileName:(NSString *)fileName
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];

    //3.2 得到完整的文件名
    NSString *fullPath=[path stringByAppendingPathComponent:fileName];
    return fullPath;
}

+(void)saveToken:(NSString *) token
{
    NSString *fileName = [self appendFileName:TokenCache];
    //3.3 需要保存的数据 value token.access_token  key access_token
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:token,@"access_token",nil];

    //3.4 写入数据
    [dic writeToFile:fileName atomically:YES];
    NSLog(@"savaToken:%@",token);
}

+ (NSString *)readToken
{
    NSString *filename = [self appendFileName:TokenCache];
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filename];
    NSLog(@"readToken:%@",[dic objectForKey:@"access_token"]);

    //3 返回数据
    return [dic objectForKey:@"access_token"];
}

+(void)savePersonalProfile:(NSDictionary *)dic
{
    NSString *filename = [self appendFileName:ProfileCache];
    //3.4 写入数据
    
    NSMutableDictionary *prunedDictionary = [NSMutableDictionary dictionary];
    for (NSString * key in [dic allKeys])
    {
        if (![[dic objectForKey:key] isKindOfClass:[NSNull class]])
            [prunedDictionary setObject:[dic objectForKey:key] forKey:key];
    }
    
    NSLog(@"savePersonalProfile,%@",filename);
    [prunedDictionary writeToFile:filename atomically:YES];
}

+(NSDictionary *)readProfile
{
    NSString *filename = [self appendFileName:ProfileCache];
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filename];
    //3 返回数据
    return dic;
}

+(void)saveClassId:(NSString *)classID className:(nonnull NSString *)name
{
    NSString *filename = [self appendFileName:ClassCache];
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:classID,@"classID",name,@"className",nil];
    //3.4 写入数据
    [dic writeToFile:filename atomically:YES];
    NSLog(@"saveClassId:%@",classID);
}

+(NSString *)readClassId
{
    NSString *filename = [self appendFileName:ClassCache];
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filename];
    NSLog(@"readClassId:%@",[dic objectForKey:@"classID"]);
    //3 返回数据
    return [dic objectForKey:@"classID"];
}

+(NSString *)readClassName
{
    NSString *filename = [self appendFileName:ClassCache];
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filename];
    //3 返回数据
    return [dic objectForKey:@"className"];
}

+(void)saveGroupPlanId:(NSString *)groupPlanId planName:(NSString *)planName
{
    NSString *filename = [self appendFileName:GroupPlanCache];
    NSArray *keyArr = [NSArray arrayWithObjects:@"groupPlanId",@"groupPlanName", nil];
    NSArray *storeObject = [NSArray arrayWithObjects:groupPlanId,planName, nil];
    NSDictionary* dic = [NSDictionary dictionaryWithObjects:storeObject forKeys:keyArr];
    [dic writeToFile:filename atomically:YES];
}

+(NSDictionary *)readGroupPlanCache
{
    NSString *filename = [self appendFileName:GroupPlanCache];
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filename];
    NSLog(@"readGroupPlanCache:name=%@,id=%@",[dic objectForKey:@"groupPlanName"],[dic objectForKey:@"groupPlanId"]);
    //3 返回数据
    return dic;
}

+(void)saveComments:(NSArray *)comments
{
    NSString *filename = [self appendFileName:CommentCache];
    if(comments)
    {
        [comments writeToFile:filename atomically:YES];
    }
    
}

+(NSArray *)readComments
{
    NSString *filename = [self appendFileName:CommentCache];
    NSArray *commentList = [NSArray arrayWithContentsOfFile:filename];
    return commentList;
}


@end
