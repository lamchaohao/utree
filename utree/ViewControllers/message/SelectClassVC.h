//
//  SelectClassVC.h
//  utree
//
//  Created by 科研部 on 2019/10/22.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSecondVC.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^OnselectedClass)(NSString *classId,NSString *className);

@interface SelectClassVC : BaseSecondVC

@property(nonatomic,copy)OnselectedClass selectedBlock;


@end

NS_ASSUME_NONNULL_END
