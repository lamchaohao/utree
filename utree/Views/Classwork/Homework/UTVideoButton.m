//
//  UTVideoButton.m
//  utree
//
//  Created by 科研部 on 2019/11/27.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTVideoButton.h"

@implementation UTVideoButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect{

    CGFloat imageW = 48;
    CGFloat imageH = 48;
    CGFloat imageX = 10;
    CGFloat imageY = 4;
    return CGRectMake(imageX, imageY, imageW, imageH);

}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(10+48+5, contentRect.origin.y, contentRect.size.width, contentRect.size.height);
}


@end
