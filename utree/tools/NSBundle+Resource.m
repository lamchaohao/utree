//
//  NSBundle+Resource.m
//  utree
//
//  Created by 科研部 on 2019/10/11.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSBundle+Resource.h"
#import <objc/runtime.h>

@implementation NSBundle (Resource)
#pragma mark 通过bundle的方法加载图片，不需要指定2x，3x
+ (void)load {
    Method originMethod = class_getInstanceMethod(self, @selector(pathForResource:ofType:));
    Method newMethod = class_getInstanceMethod(self, @selector(tempPathForResource:ofType:));
    method_exchangeImplementations(originMethod, newMethod);
}
//不要在头文件添加这个方法，因为load方法已经将此方法引入
- (NSString *)tempPathForResource:(NSString *)name ofType:(NSString *)ext {
    NSString *path = [self tempPathForResource:name ofType:ext];
    if (path) {
        return path;
    }
    CGFloat scale = [UIScreen mainScreen].scale;
    if (ABS(scale-3) <= 0.001) {
        path = [self tempPathForResource_3x:name ofType:ext];
        if (!path) {
            path = [self tempPathForResource_2x:name ofType:ext];
            if (!path) {
                path = [self tempPathForResource_x:name ofType:ext];
            }
        }
        
    }
    else if (ABS(scale-2) <= 0.001){
        path = [self tempPathForResource_2x:name ofType:ext];
        if (!path) {
            path = [self tempPathForResource_3x:name ofType:ext];
            if (!path) {
                path = [self tempPathForResource_x:name ofType:ext];
            }
        }
    }
    else {
        path = [self tempPathForResource_x:name ofType:ext];
        if (!path) {
            path = [self tempPathForResource_2x:name ofType:ext];
            if (!path) {
                path = [self tempPathForResource_3x:name ofType:ext];
            }
        }
    }
    
    return path;
}

- (NSString *)tempPathForResource_x:(NSString *)name ofType:(NSString *)ext {
    NSString *path = nil;
    NSString *teampName = nil;
    
    if ([name hasSuffix:@"@3x"]) {
        teampName = [name stringByReplacingOccurrencesOfString:@"@3x" withString:@""];
    }
    else if ([name hasSuffix:@"@2x"]) {
        teampName = [name stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
    }
    else {
        teampName = name;
    }
    path = [self tempPathForResource:teampName ofType:ext];
    
    return path;
}

- (NSString *)tempPathForResource_2x:(NSString *)name ofType:(NSString *)ext {
    NSString *path = nil;
    NSString *teampName = nil;
    
    if ([name hasSuffix:@"@3x"]) {
        teampName = [name stringByReplacingOccurrencesOfString:@"@3x" withString:@"@2x"];
    }
    else if ([name hasSuffix:@"@2x"]) {
        teampName = name;
    }
    else {
        teampName = [NSString stringWithFormat:@"%@@2x", name];
    }
    path = [self tempPathForResource:teampName ofType:ext];
    
    return path;
}

- (NSString *)tempPathForResource_3x:(NSString *)name ofType:(NSString *)ext {
    NSString *path = nil;
    NSString *teampName = nil;
    
    if ([name hasSuffix:@"@3x"]) {
        teampName = name;
    }
    else if ([name hasSuffix:@"@2x"]) {
        teampName = [name stringByReplacingOccurrencesOfString:@"@2x" withString:@"@3x"];
    }
    else {
        teampName = [NSString stringWithFormat:@"%@@3x", name];
    }
    path = [self tempPathForResource:teampName ofType:ext];
    
    return path;
}

@end
