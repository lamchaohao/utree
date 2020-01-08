//
//  UTDateConvertTool.h
//  utree
//
//  Created by 科研部 on 2019/12/25.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UTDateConvertTool : NSObject

+(NSInteger)getNowTimestamp;

+(NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format;

+(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format;

+ (NSString *)currentTimeStr;

+ (NSDate *)dateFromString:(NSString *)dateString ;

@end

NS_ASSUME_NONNULL_END
