//
//  UTParent.h
//  utree
//
//  Created by 科研部 on 2019/10/22.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UTStudent.h"
NS_ASSUME_NONNULL_BEGIN

@interface UTParent : NSObject

@property(nonatomic,strong)NSString *parentId;
@property(nonatomic,strong)NSString *picPath;
@property(nonatomic,strong)NSString *phone;
@property(nonatomic,strong)NSString *relation;
@property(nonatomic,strong)NSString *parentName;
@property(nonatomic,strong)NSString *studentName;

@property(nonatomic,strong)NSArray<UTStudent *> *studentList;

@end

NS_ASSUME_NONNULL_END
