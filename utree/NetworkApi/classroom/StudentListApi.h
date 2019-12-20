//
//  StudentListApi.h
//  utree
//
//  Created by 科研部 on 2019/10/25.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UTBaseRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface StudentListApi : UTBaseRequest

-(instancetype)initWithClassId:(NSString *)classId;

@end

NS_ASSUME_NONNULL_END
