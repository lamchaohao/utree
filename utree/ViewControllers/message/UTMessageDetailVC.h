//
//  UTMessageDetailVC.h
//  utree
//
//  Created by 科研部 on 2020/1/16.
//  Copyright © 2020 科研部. All rights reserved.
//

#import "BaseSecondVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface UTMessageDetailVC : BaseSecondVC

- (instancetype)initWithNoticeId:(NSString *)msgId isSystemMsg:(BOOL)isSysMsg;

@end

NS_ASSUME_NONNULL_END
