//
//  FetchOSSTokenApi.m
//  utree
//
//  Created by 科研部 on 2019/11/13.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "FetchOSSTokenApi.h"

@implementation FetchOSSTokenApi


- (NSString *)requestUrl
{
    return @"tmobile/oss/getSTSToken";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (YTKResponseSerializerType)responseSerializerType
{
    return YTKResponseSerializerTypeHTTP;
}



@end
