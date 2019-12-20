//
//  GroupModel.h
//  utree
//
//  Created by 科研部 on 2019/9/24.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UTStudent.h"
NS_ASSUME_NONNULL_BEGIN

@interface GroupModel : NSObject
@property(nonatomic,strong)NSString *groupName;
@property(nonatomic,strong)NSMutableArray<UTStudent *> *studentDos;
@property(nonatomic,strong)NSString *groupId;
@property(nonatomic,assign)int groupCount;
@property(nonatomic,assign)NSNumber *dropNum;
@end

NS_ASSUME_NONNULL_END
