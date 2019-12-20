//
//  PersonalDC.h
//  utree
//
//  Created by 科研部 on 2019/11/18.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "BaseDataController.h"
#import "UploadFileDC.h"
#import "FileObject.h"
NS_ASSUME_NONNULL_BEGIN

@interface PersonalDC : UploadFileDC

-(void)requestUpdateAvatarWithFile:(FileObject *)file WithSuccess:(UTRequestCompletionBlock)success failure:(UTRequestCompletionBlock)failure;

@end

NS_ASSUME_NONNULL_END
