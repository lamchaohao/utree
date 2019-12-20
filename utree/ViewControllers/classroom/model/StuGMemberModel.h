//
//  StudentGroupModel.h
//  utree
//
//  Created by 科研部 on 2019/11/4.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UTStudent.h"
NS_ASSUME_NONNULL_BEGIN

@interface StuGMemberModel : UTStudent

@property(nonatomic,strong)NSString *groupId;
@property(nonatomic,strong)NSString *groupName;

@end

NS_ASSUME_NONNULL_END
