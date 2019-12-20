//
//  SmsLoginApi.m
//  utree
//
//  Created by 科研部 on 2019/10/24.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "SmsLoginApi.h"
#import "SystemInfoTool.h"
@implementation SmsLoginApi
{
    NSString *_phoneNum;
    NSString *_code;
}
-(instancetype)initWithPhoneNum:(NSString *)phone andCode:(NSString *)code
{
    self = [super init];
    if (self) {
        _phoneNum = phone;
        _code = code;
    }
    return self;
}

-(NSString *)requestUrl
{
    return @"tmobile/base/verificationLogin";
}

-(id)requestArgument
{
    NSString *strSysName = [[UIDevice currentDevice] systemName];
       NSLog(@"系统名称：%@", strSysName);// e.g. @"iOS"
         
    NSString *strSysVersion = [[UIDevice currentDevice] systemVersion];
       NSLog(@"系统版本号号：%@", strSysVersion);// e.g. @"4.0"
       
       return @{
           @"account": _phoneNum,
           @"verification": _code,
           @"phoneBrand":@"Apple",
           @"phoneModel":[SystemInfoTool deviceModelName],
           @"os":[NSString stringWithFormat:@"%@ %@",strSysName,strSysVersion]
       };
}

@end
