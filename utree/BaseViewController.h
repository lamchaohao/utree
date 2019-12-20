//
//  BaseViewController.h
//  utree
//
//  Created by 科研部 on 2019/10/14.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController
- (void)showAlertMessage:(NSString *)message title:(NSString *)title;
-(void)showToastView:(NSString *)message;
- (BOOL)isBlankString:(NSString *)str;
-(NSString *)getUserId;


@end

NS_ASSUME_NONNULL_END
