//
//  BaseDataController.h
//  utree
//
//  Created by 科研部 on 2019/10/29.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UTResult.h"
#import "UTCache.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^UTRequestCompletionBlock)(UTResult *result);

@interface BaseDataController : NSObject
-(NSString *)getCurrentPlanId;
-(NSString *)getCurrentPlanName;
-(NSString *)getCurrentClassId;
- (BOOL)isBlankString:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
