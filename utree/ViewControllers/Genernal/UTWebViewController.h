//
//  UTWebViewController.h
//  utree
//
//  Created by 科研部 on 2020/1/17.
//  Copyright © 2020 科研部. All rights reserved.
//

#import "BaseSecondVC.h"
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface UTWebViewController : BaseSecondVC

@property (nonatomic)NSURL* url;

@property (nonatomic)UIColor* progressViewColor;

@property (nonatomic)WKWebView* webView;

-(instancetype)initWithUrl:(NSURL *)url;

-(void)reloadWebView;
@end

NS_ASSUME_NONNULL_END
