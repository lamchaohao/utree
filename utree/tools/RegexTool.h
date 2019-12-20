//
//  RegexTool.h
//  utree
//
//  Created by 科研部 on 2019/10/25.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegexTool : NSObject

+ (BOOL)isMobileNumberClassification:(NSString *)phone;

+(BOOL)checkURL:(NSString *)urlStr;

@end

NS_ASSUME_NONNULL_END
