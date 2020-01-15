//
//  PostMomentVC.h
//  utree
//
//  Created by 科研部 on 2019/10/14.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSecondVC.h"
NS_ASSUME_NONNULL_BEGIN


typedef void(^ResultPath)(NSString *filePath, NSString *fileName);

@protocol PostMomentCallback <NSObject>

-(void)onPostSuccess;

@end

@interface PostMomentVC : BaseSecondVC

@property(nonatomic,assign)id<PostMomentCallback> callback;

@end

NS_ASSUME_NONNULL_END
