//
//  RefreshTokenApi.h
//  utree
//
//  Created by 科研部 on 2019/10/24.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKBaseRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface RefreshTokenApi : YTKBaseRequest
-(id)initWithToken:(NSString *)token;
@end

NS_ASSUME_NONNULL_END
