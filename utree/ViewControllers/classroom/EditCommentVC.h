//
//  EditCommentVCViewController.h
//  utree
//
//  Created by 科研部 on 2019/11/8.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "BaseSecondVC.h"

NS_ASSUME_NONNULL_BEGIN

@protocol EditCommentSender <NSObject>

-(void)onDeleteComment:(NSString *)deleted;

@end

@interface EditCommentVC : BaseSecondVC

@property(nonatomic,assign)id<EditCommentSender> sender;

@end

NS_ASSUME_NONNULL_END
