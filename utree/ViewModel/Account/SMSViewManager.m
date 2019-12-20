//
//  SMSViewManager.m
//  utree
//
//  Created by 科研部 on 2019/10/29.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "SMSViewManager.h"

@implementation SMSViewManager


- (void)shrinkKeyboard
{
    [self.viewDelegate hideKeyboard];
}

-(void)showCountDownFrom:(int)begin
{
    [self.viewDelegate showCountDownViewFrom:begin];
}

@end
