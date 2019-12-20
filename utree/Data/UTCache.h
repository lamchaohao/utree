//
//  UTCache.h
//  utree
//
//  Created by 科研部 on 2019/10/24.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UTCache : NSObject

+(void)saveToken:(NSString *) token;

+(NSString *)readToken;

+(void)savePersonalProfile:(NSDictionary *)dic;

+(NSDictionary *)readProfile;

+(NSString *)readClassId;

+(NSString *)readClassName;

+(void)saveClassId:(NSString *)classID className:(NSString *)name;

+(NSDictionary *)readGroupPlanCache;

+(void)saveGroupPlanId:(NSString *)groupPlanId planName:(NSString *)planName;

+(void)saveComments:(NSArray *)comments;

+(NSArray *)readComments;

@end

NS_ASSUME_NONNULL_END
