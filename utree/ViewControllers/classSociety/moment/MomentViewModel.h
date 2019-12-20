//
//  MomentViewModel.h
//  utree
//
//  Created by 科研部 on 2019/9/4.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MomentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MomentViewModel : NSObject


@property(nonatomic,strong) MomentModel *momentModel;

/**
 *  主体Frame
 */
@property (nonatomic ,assign) CGRect momentsBodyFrame;

//时间Frame
@property (nonatomic ,assign) CGRect topFrame;
//正文Frame
@property (nonatomic ,assign) CGRect bodyTextFrame;
//图片Frame
@property (nonatomic ,assign) CGRect bodyPhotoFrame;
//视频Frame
@property (nonatomic ,assign) CGRect bodyVideoFrame;

/**
 *  工具条Frame
 */
@property (nonatomic, assign) CGRect momentsToolBarFrame;


/**
 *  cell高度
 */
@property (nonatomic ,assign) CGFloat cellHeight;


@end

NS_ASSUME_NONNULL_END
