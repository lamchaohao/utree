//
//  JSONUtil.h
//  utree
//
//  Created by 科研部 on 2019/12/19.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSONUtil : NSObject

+ (NSString *)convertToJsonData:(NSDictionary *)dict;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString ;

+(NSString *)convertToJsonDataNoDeal:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
