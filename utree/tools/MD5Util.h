//
//  MD5Util.h
//  utree
//
//  Created by 科研部 on 2019/10/25.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MD5Util : NSObject

+(NSString *)md5DigestWithString:(NSString*)input;

+(NSString *)md5DigestWithData:(NSData*)input;
@end

NS_ASSUME_NONNULL_END
