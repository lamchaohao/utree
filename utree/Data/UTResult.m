//
//  UTResult.m
//  utree
//
//  Created by 科研部 on 2019/10/28.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTResult.h"

@implementation UTResult

-(instancetype)initWithSuccess:(id)result
{
    self = [super init];
      if (self) {
          self.successResult=result;
      }
      return self;
}

-(instancetype)initWithFailure:(id)result
{
    self = [super init];
      if (self) {
          self.failureResult = result;
      }
      return self;
    
}


@end
