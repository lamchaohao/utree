//
//  CommentCellViewModel.h
//  utree
//
//  Created by 科研部 on 2019/11/21.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentCellViewModel : NSObject
@property(nonatomic,strong)CommentModel *commentModel;
@property (nonatomic ,assign) CGRect headViewFrame;
@property (nonatomic ,assign) CGRect writerLabelFrame;
@property (nonatomic ,assign) CGRect timeLabelFrame;
@property (nonatomic ,assign) CGRect commentDetailFrame;

@property (nonatomic ,assign) CGRect commentBodyFrame;

@property (nonatomic ,assign) CGFloat cellHeight;

-(void)caculateFrameWith:(CommentModel *)comment;

@end

NS_ASSUME_NONNULL_END
