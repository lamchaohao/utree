//
//  MMPopupWindow.h
//  utree
//
//  Created by 科研部 on 2019/9/19.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMPopupWindow : UIWindow

@property (nonatomic, assign) BOOL touchWildToHide; // default is NO. When YES, popup views will be hidden when user touch the translucent background.
@property (nonatomic, readonly) UIView* attachView;

+ (MMPopupWindow *)sharedWindow;

/**
 *  cache the window to prevent the lag of the first showing.
 */
- (void) cacheWindow;
@end

NS_ASSUME_NONNULL_END
