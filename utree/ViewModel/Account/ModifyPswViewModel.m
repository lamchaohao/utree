//
//  ModifyPswViewModel.m
//  utree
//
//  Created by 科研部 on 2019/10/29.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ModifyPswViewModel.h"

@implementation ModifyPswViewModel

- (void)hidekeyBoard
{
    [self.viewDelegate hideKeyboard];
}

-(void)showCountDownViewFrom:(int)begin
{
    [self.viewDelegate showCountDownViewFrom:begin];
}

@end
