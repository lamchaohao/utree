//
//  ChatVC.h
//  utree
//
//  Created by 科研部 on 2019/12/12.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "BaseSecondVC.h"
#import "UTParent.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatVC : BaseSecondVC

- (instancetype)initWithParent:(UTParent *)parent;

@property(nonatomic) UTParent *parentModel;


@end

NS_ASSUME_NONNULL_END
