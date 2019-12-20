//
//  WrapCommentListModel.h
//  utree
//
//  Created by 科研部 on 2019/11/21.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WrapCommentListModel : NSObject


@property(nonatomic,strong)NSString *schoolCircleId;
@property(nonatomic,strong)NSNumber *isLike;
@property(nonatomic,strong)NSNumber *limit;
@property(nonatomic,strong)NSString *commentId;//上次获取的最后一条数据的id
@property(nonatomic,strong)NSNumber *commentCount;
@property(nonatomic,strong)NSNumber *likeCount;
@property(nonatomic,strong)NSArray<CommentModel *> *list;

@end

NS_ASSUME_NONNULL_END
