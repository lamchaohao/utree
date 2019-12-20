//
//  CommentModel.h
//  utree
//
//  Created by 科研部 on 2019/11/21.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentModel : NSObject

@property(nonatomic,strong)NSString *commentId;
@property(nonatomic,strong)NSString *comment;
@property(nonatomic,strong)NSString *facePath;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *studentName;
@property(nonatomic,strong)NSString *commentator;
@property(nonatomic,strong)NSNumber *parent;//是否家长
@property(nonatomic,strong)NSString *createTime;


@end

NS_ASSUME_NONNULL_END
