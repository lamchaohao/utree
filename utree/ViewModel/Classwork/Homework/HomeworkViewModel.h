//
//  HomeworkViewModel.h
//  utree
//
//  Created by 科研部 on 2019/11/26.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeworkModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeworkViewModel : NSObject

@property(nonatomic,strong) HomeworkModel *taskModel;

/**
 *  主体Frame
 */
@property (nonatomic ,assign) CGRect taskBodyFrame;

//昵称Frame头像Frame时间Frame
@property (nonatomic ,assign) CGRect headDataFrame;

//正文Frame
@property (nonatomic ,assign) CGRect detailTextFrame;
//录音Frame
@property (nonatomic ,assign) CGRect bodyAudioFrame;
//图片Frame
@property (nonatomic ,assign) CGRect bodyPhotoFrame;

@property (nonatomic, assign) CGRect bodyWeblinkFrame;

@property (nonatomic, assign) CGRect bodyVideoFrame;
//点赞Frame
@property (nonatomic ,assign) CGRect toolLikeFrame;
//评论Frame
@property (nonatomic ,assign) CGRect toolCommentFrame;

@property (nonatomic ,assign) BOOL isNeedSummaryCount;

@property (nonatomic ,strong)NSString *userId;

- (void)setTaskModelToCaculate:(HomeworkModel *)task;
/**
 *  cell高度
 */
@property (nonatomic ,assign) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
