//
//  RegexTool.m
//  utree
//
//  Created by 科研部 on 2019/10/25.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "RegexTool.h"

@implementation RegexTool

+(BOOL)checkURL:(NSString *)urlStr
{
    if (urlStr.length>4 && [[urlStr substringToIndex:4] isEqualToString:@"www."]) {
       urlStr = [NSString stringWithFormat:@"http://%@",self];
    }
    NSString *urlRegex = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSPredicate* urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    return ![urlTest evaluateWithObject:urlStr];

}

/**
 基础方法

 @param regex 正则表达式
 @return 正则验证成功返回YES, 否则返回NO
 */
+ (BOOL)isValidateByRegex:(NSString *)regex phoneNum:(NSString *)phoneNum  {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:phoneNum];
}

/**
 判断运营商
 各个运营商开头号码不同 需要根据运营商更新

 @return  正则验证成功返回YES, 否则返回NO
 */
+ (BOOL)isMobileNumberClassification:(NSString *)phone {
    if(phone.length<11)
    {
        return NO;
    }
    /**
     * 手机号码
     * 移动：134(0-8)、135、136、137、138、139、147、150、151、152、157、158、159、172、178、182、183、184、187、188、198
     *
     * 联通：130、131、132、145、155、156、166、175、176、185、186
     *
     * 电信：133、149、153、173、177、180、181、189、191、199
     *
        虚拟运营商
        电信：1700、1701、1702
        移动：1703、1705、1706
        联通：1704、1707、1708、1709、171
        卫星通信：1349
     */
    /**
                * 中国移动：China Mobile
                * 134(0-8)、135、136、137、138、139、147、150、151、152、157、158、159、172、178、182、183、184、187、188、198
     
     */
    NSString * CM = @"^1(34[0-8]|3[5-9]|47|5[0127-9]|8[23478]|98)\\d{8}$";
    /**
                * 中国联通：China Unicom
                * 130、131、132、145、155、156、166、175、176、185、186
     */
    NSString * CU = @"^1((3[0-2]|45|5[56]|166|7[56]|8[56]))\\d{8}$";
    /**
                * 中国电信：China Telecom
                * 133、149、153、173、177、180、181、189、191、199
     */
    NSString * CT = @"^1((33|49|53|7[37]|8[019]|9[19]))\\d{8}$";
   
    if ([self isValidateByRegex:CM phoneNum:phone]) {
        NSLog(@"手机运营商是====CM---中国移动");
        return YES;
    } else if ([self isValidateByRegex:CU phoneNum:phone]) {
        NSLog(@"手机运营商是====CU---中国联通");
        return YES;
    } else if ([self isValidateByRegex:CT phoneNum:phone]){
        NSLog(@"手机运营商是====CT---中国电信");
        return YES;
    } else {
        return NO;
    }
    
}

@end
