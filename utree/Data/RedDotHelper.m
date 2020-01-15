//
//  RedDotHelper.m
//  utree
//
//  Created by 科研部 on 2020/1/14.
//  Copyright © 2020 科研部. All rights reserved.
//

#import "RedDotHelper.h"

@implementation RedDotHelper
static NSString *UnreadFilePath = @"un_read_count.plist";
+(instancetype)shareInstance{
    static RedDotHelper *helper = nil;
    @synchronized (self) {
        if (helper == nil) {
            helper = [[RedDotHelper alloc]init];
        }
    }
    return helper;
}



-(void)setExamUnread:(int)examUnread
{
    _circleUnread =examUnread;
    [self notifyDataUpdate];
}

- (void)setNoticeUnread:(int)noticeUnread
{
    _noticeUnread = noticeUnread;
    [self notifyDataUpdate];
}

- (void)setStudentTaskUnread:(int)studentTaskUnread
{
    _studentTaskUnread=studentTaskUnread;
    [self notifyDataUpdate];
}

- (void)setCircleUnread:(int)circleUnread
{
    _circleUnread=circleUnread;
    [self notifyDataUpdate];
}

- (void)setSystemUnread:(int)systemUnread
{
    _systemUnread = systemUnread;
    [self notifyDataUpdate];
}

- (void)setChatUnread:(int)chatUnread
{
    NSString *fileName = [self appendFileName:UnreadFilePath];
    //3.3 需要保存的数据 value token.access_token  key access_token
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:@(chatUnread),@"chat_unread",nil];
    NSLog(@"setChatUnread:%d",chatUnread);
    //3.4 写入数据
    [dic writeToFile:fileName atomically:YES];
    [self notifyDataUpdate];
}

- (int)chatUnread
{
    NSString *filename = [self appendFileName:UnreadFilePath];
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filename];
    NSNumber *unread= [dic objectForKey:@"chat_unread"];
    NSLog(@"chatUnread:%d",unread.intValue);
    return unread.intValue;
}

- (void)setSchoolMsgUnread:(int)schoolMsgUnread
{
    _schoolMsgUnread=schoolMsgUnread;
    [self notifyDataUpdate];
}

-(NSString *)appendFileName:(NSString *)fileName
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];

    //3.2 得到完整的文件名
    NSString *fullPath=[path stringByAppendingPathComponent:fileName];
    return fullPath;
}

-(void)notifyDataUpdate
{
    [[NSNotificationCenter defaultCenter] postNotificationName:BadgeValueUpdateNotifyName object:nil];
}
@end
