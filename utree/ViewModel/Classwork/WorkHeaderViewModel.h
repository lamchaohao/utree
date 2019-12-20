//
//  WorkHeaderViewModel.h
//  utree
//
//  Created by 科研部 on 2019/12/2.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeworkModel.h"
#import "NoticeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WorkHeaderViewModel : NSObject

@property(nonatomic,strong) HomeworkModel *taskModel;
/**
 *  主体Frame
 */
@property (nonatomic ,assign) CGRect contentBodyFrame;

//昵称Frame头像Frame时间Frame
@property (nonatomic ,assign) CGRect headDataFrame;

@property (nonatomic ,assign) CGRect subjectFrame;
@property (nonatomic ,assign) CGRect titleFrame;
//正文Frame
@property (nonatomic ,assign) CGRect detailTextFrame;
//录音Frame
@property (nonatomic ,assign) CGRect bodyAudioFrame;
//图片Frame
@property (nonatomic ,assign) CGRect bodyPhotoFrame;

/**
 *  工具条Frame
 */
@property (nonatomic, assign) CGRect taskToolBarFrame;

@property (nonatomic, assign) CGRect bodyWeblinkFrame;

@property (nonatomic, assign) CGRect bodyVideoFrame;



- (void)setTaskModelToCaculate:(HomeworkModel *)task;

-(void)setNoticeToCaculate:(NoticeModel *)notice;
/**
 *  cell高度
 */
@property (nonatomic ,assign) CGFloat cellHeight;
@end

NS_ASSUME_NONNULL_END
