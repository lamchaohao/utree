//
//  CFTool.h
//  utree
//
//  Created by 科研部 on 2019/9/25.
//  Copyright © 2019 科研部. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//字体颜色工具
@interface CFTool : NSObject

+(UIColor*)color:(NSInteger)idx;

+(UIFont*)font:(CGFloat)size;

+(NSArray *)generateStudentsWithCapacity:(NSInteger)count;


@end

