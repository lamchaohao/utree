//
//  UUParentChatVC.h
//  utree
//
//  Created by 科研部 on 2019/12/16.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "BaseSecondVC.h"
#import "ChatMessageDC.h"
#import "UTParent.h"
NS_ASSUME_NONNULL_BEGIN

@interface UUParentChatVC : BaseSecondVC

- (instancetype)initWithParent:(UTParent *)parent;

@property (strong, nonatomic) ChatMessageDC *dataController;

@end

NS_ASSUME_NONNULL_END
