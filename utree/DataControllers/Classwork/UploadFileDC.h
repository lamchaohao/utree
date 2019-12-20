//
//  UploadFileDC.h
//  utree
//
//  Created by 科研部 on 2019/11/18.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "BaseDataController.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@protocol UploadFileListener <NSObject>

- (void)onFileUploadProgress:(CGFloat)progress filePath:(NSString *)filePath fileIndex:(NSInteger)index;

-(void)onFileUploadResult:(BOOL)success filePath:(NSString *)filePath fileIndex:(NSInteger)index md5Value:(NSString *)md5Str;

@end

@interface UploadFileDC : BaseDataController

-(void)uploadFile:(NSString *)filePath mediaType:(NSString *)mType fileIndex:(NSInteger)fileIndex;

-(void)uploadFileData:(NSData *)data fileName:(NSString *)fileName mediaType:(NSString *)mType fileIndex:(NSInteger)fileIndex;


@property(nonatomic,strong)NSString *platform;

@property(nonatomic,assign)id<UploadFileListener> uploadListener;


@end

NS_ASSUME_NONNULL_END
