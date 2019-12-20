//
//  AwardResultView.h
//  utree
//
//  Created by 科研部 on 2019/11/11.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AwardResultView : MyRelativeLayout

- (void)showView;
- (void)dismissView :(id)sender;

- (instancetype)initWithFrame:(CGRect)frame stuNum:(NSString *)number;
- (instancetype)initWithFrame:(CGRect)frame stuName:(NSString *)stuName score:(NSString *)score;
@end

NS_ASSUME_NONNULL_END
