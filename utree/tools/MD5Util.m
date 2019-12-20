//
//  MD5Util.m
//  utree
//
//  Created by 科研部 on 2019/10/25.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "MD5Util.h"
#import <CommonCrypto/CommonDigest.h>

extern unsigned char *CC_MD5(const void *data, uint32_t len, unsigned char *md)
__OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_2_0);

@implementation MD5Util

+(NSString *)md5DigestWithString:(NSString*)input{
    const char* str = [input UTF8String];
    unsigned char result[16];
    CC_MD5(str, (uint32_t)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:16 * 2];
    for(int i = 0; i<16; i++) {
        [ret appendFormat:@"%02x",(unsigned int)(result[i])];
    }
    return ret;
}


+(NSString *)md5DigestWithData:(NSData*)input{
//    const char* str = [input bytes];
//    unsigned char result[16];
//    CC_MD5(str, (uint32_t)strlen(str), result);
//    NSMutableString *ret = [NSMutableString stringWithCapacity:16 * 2];
//    for(int i = 0; i<16; i++) {
//        [ret appendFormat:@"%02x",(unsigned int)(result[i])];
//    }
//    return ret;
    
    //1: 创建一个MD5对象
    CC_MD5_CTX md5;
    //2: 初始化MD5
    CC_MD5_Init(&md5);
    //3: 准备MD5加密
    CC_MD5_Update(&md5, (__bridge const void *)(input), input.length);
    //4: 准备一个字符串数组, 存储MD5加密之后的数据
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    //5: 结束MD5加密
    CC_MD5_Final(result, &md5);
    NSMutableString *resultString = [NSMutableString string];
    //6:从result数组中获取最终结果
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [resultString appendFormat:@"%02X", result[i]];
    }
    return resultString;
    
}

@end
