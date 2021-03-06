//
//  UTMessage.m
//  utree
//
//  Created by 科研部 on 2019/12/17.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTMessage.h"
#import "UTDateConvertTool.h"
@implementation UTMessage


- (void)setWithDict:(NSDictionary *)dict{
    
    self.headPicUrl = dict[Key_Head_Pic];
    self.accountId = dict[Key_Account_Id];
    self.toAccount = dict[Key_toAccount_Id];
    self.accountName = dict[Key_Account_Name];
    self.timeStamp = dict[Key_Time_Stamp];
    self.from = [dict[Key_From] intValue];
    
    switch ([dict[Key_Type] integerValue]) {
        
        case 0:
            self.type = UTMessageTypeText;
            self.contentStr = dict[Key_Content_Text];
            break;
        
        case 1:
            self.type = UTMessageTypePicture;
            self.picture = dict[Key_Pic_Data];
            break;
        
        case 2:
            self.type = UTMessageTypeVoice;
            self.voiceDuration = dict[Key_Voice_Duration];
            self.voiceUrl = dict[Key_Voice_URL];
            break;
            
        default:
            break;
    }
}


- (void)setTimeStamp:(NSString *)timeStamp
{
    _timeStamp = timeStamp;
    _timeForShow = [self changeTheDateString:timeStamp];
}

- (NSString *)changeTheDateString:(NSString *)Str
{
   
    return [UTDateConvertTool timestampSwitchTime:Str.integerValue andFormatter:@"yyyy年MM月dd日 HH:mm"];
    
}

- (void)minuteOffSetStart:(NSString *)start end:(NSString *)end
{
    if (!start) {
        self.showDateLabel = YES;
        return;
    }
    NSString *startDateStr = [UTDateConvertTool timestampSwitchTime:start.integerValue andFormatter:@"yyyy-MM-dd HH:mm"];

    NSString *endDateStr = [UTDateConvertTool timestampSwitchTime:end.integerValue andFormatter:@"yyyy-MM-dd HH:mm"];
    NSDate *startDate = [UTDateConvertTool dateFromString:startDateStr];
    NSDate *endDate = [UTDateConvertTool dateFromString:endDateStr];
    //这个是相隔的秒数
    NSTimeInterval timeInterval = [startDate timeIntervalSinceDate:endDate];
    
    //相距5分钟显示时间Label
    if (fabs (timeInterval) > 5*60) {
        self.showDateLabel = YES;
    }else{
        self.showDateLabel = NO;
    }
    
}

-(NSDate *)getDateWithTimeSecond:(NSString *)timestamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp longLongValue]/1000];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
     return [date dateByAddingTimeInterval:interval];
}

@end
