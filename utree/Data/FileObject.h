//
//  FileObject.h
//  utree
//
//  Created by 科研部 on 2019/10/25.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileObject : NSObject
/**
"fileId":"0565077114057998",
"size":null,
"fileName":null,
"path":"static/Files/2/pic/50e6e6a82d2463b728addcec3e4eeee4.jpeg",
"pid":null,
"fileType":"jpeg",
"fileMD5":"50e6e6a82d2463b728addcec3e4eeee4",
"uploadTime":"2019-08-06T07:38:57.000+0000",
"fileKind":null,
"fileClass":null,
"minPath":null
*/
@property(nonatomic,strong) NSString *fileId;
@property(nonatomic,strong) NSNumber *size;
@property(nonatomic,strong) NSString *fileName;
@property(nonatomic,strong) NSString *path;
@property(nonatomic,strong) NSString *pid;
@property(nonatomic,strong) NSString *fileType;
@property(nonatomic,strong) NSString *fileMD5;
@property(nonatomic,strong) NSString *uploadTime;
@property(nonatomic,strong) NSNumber *fileKind;
@property(nonatomic,strong) NSString *fileClass;
@property(nonatomic,strong) NSString *minPath;
@property(nonatomic,assign) CGFloat videoHeight;
@property(nonatomic,assign) CGFloat videoWidth;

@end

NS_ASSUME_NONNULL_END
