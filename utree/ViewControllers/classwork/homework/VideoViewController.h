//
//  VideoViewController.h
//  utree
//
//  Created by 科研部 on 2019/11/27.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "BaseSecondVC.h"
#import "FileObject.h"
NS_ASSUME_NONNULL_BEGIN

@interface VideoViewController : BaseSecondVC

- (instancetype)initWithVideo:(FileObject *)video;

@end

NS_ASSUME_NONNULL_END
