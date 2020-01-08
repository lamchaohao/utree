//
//  ScanResultVC.h
//  utree
//
//  Created by 科研部 on 2019/12/27.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "BaseSecondVC.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    ScanSuccessJumpComeFromWB,
    ScanSuccessJumpComeFromWC
} ScanSuccessJumpComeFrom;

@interface ScanResultVC : BaseSecondVC
/** 判断从哪个控制器 push 过来 */
@property (nonatomic, assign) ScanSuccessJumpComeFrom comeFromVC;
/** 接收扫描的二维码信息 */
@property (nonatomic, copy) NSString *jump_URL;
/** 接收扫描的条形码信息 */
@property (nonatomic, copy) NSString *jump_bar_code;
@end

NS_ASSUME_NONNULL_END
