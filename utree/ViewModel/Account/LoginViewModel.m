//
//  LoginViewModel.m
//  utree
//
//  Created by 科研部 on 2019/10/28.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel

-(instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)hideKeyboard
{
    [self.delegate hideKeyboard];
}

- (void)showCountDownViewFrom:(int)begin
{
    [self.delegate showCountDownViewFrom:begin];
}





@end
