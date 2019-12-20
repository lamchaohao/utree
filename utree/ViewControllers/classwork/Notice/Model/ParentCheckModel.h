//
//  ParentCheckModel.h
//  utree
//
//  Created by 科研部 on 2019/12/2.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UTParent.h"
NS_ASSUME_NONNULL_BEGIN

@interface ParentCheckModel : NSObject

@property(nonatomic,strong)NSNumber *remindTime;
@property(nonatomic,strong)NSString *studentPic;
@property(nonatomic,strong)NSString *studentId;
@property(nonatomic,strong)NSString *studentName;

@property(nonatomic,strong)NSArray<UTParent *> *parentList;

@end

NS_ASSUME_NONNULL_END
