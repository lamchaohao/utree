//
//  ParentDataVC.h
//  utree
//
//  Created by 科研部 on 2019/10/22.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSecondVC.h"
#import "UTParent.h"
NS_ASSUME_NONNULL_BEGIN

@interface ParentDataVC : BaseSecondVC

- (instancetype)initWithParent:(UTParent *)parent;

@end

NS_ASSUME_NONNULL_END
