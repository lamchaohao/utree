//
//  NoticeViewModel.h
//  utree
//
//  Created by 科研部 on 2019/8/30.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeViewModel : NSObject


@property(nonatomic,strong) NoticeModel *notice;

/**
 *  主体Frame
 */
@property (nonatomic ,assign) CGRect noticeBodyFrame;

//昵称Frame头像Frame时间Frame
@property (nonatomic ,assign) CGRect headDataFrame;

//正文Frame
@property (nonatomic ,assign) CGRect detailTextFrame;
//录音Frame
@property (nonatomic ,assign) CGRect bodyAudioFrame;
//图片Frame
@property (nonatomic ,assign) CGRect bodyPhotoFrame;
@property (nonatomic ,assign) CGRect bodyWeblinkFrame;

@property (nonatomic ,assign) BOOL isNeedSummaryCount;
@property (nonatomic ,strong)NSString *userId;
/**
 *  cell高度
 */
@property (nonatomic ,assign) CGFloat cellHeight;


@end

NS_ASSUME_NONNULL_END
