//
//  UTWebViewController.m
//  utree
//
//  Created by 科研部 on 2020/1/17.
//  Copyright © 2020 科研部. All rights reserved.
//

#import "UTWebViewController.h"

#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

#define boundsWidth self.view.bounds.size.width
#define boundsHeight self.view.bounds.size.height
@interface UTWebViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic)NJKWebViewProgressView* progressView;
@property (nonatomic)WKWebViewConfiguration *config;
@property(nonatomic)UILabel *navTitle;

@end

@implementation UTWebViewController

#pragma mark - init
-(instancetype)initWithUrl:(NSURL *)url{
    self = [super init];
    if (self) {
        self.url = url;
        _progressViewColor = [UIColor myColorWithHexString:PrimaryColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNaviBar];
    [self.navigationController.navigationBar addSubview:self.progressView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    // Do any additional setup after loading the view.
}

-(void)createNaviBar
{
    if (!self.navigationController) {
        MyRelativeLayout *navBarLayout = [MyRelativeLayout new];
        navBarLayout.frame = CGRectMake(0, 0, ScreenWidth, 56);
        navBarLayout.backgroundColor = [UIColor whiteColor];
        navBarLayout.myTop=iPhone_StatuBarHeight;
        navBarLayout.myLeft=0;
        
        self.navTitle = [[UILabel alloc]init];
        self.navTitle.myCenterX=0;
        self.navTitle.myCenterY=0;
        self.navTitle.textColor = [UIColor blackColor];
        self.navTitle.font = [UIFont boldSystemFontOfSize:20];
        self.navTitle.text=@"";
        [self.navTitle sizeToFit];
        
        UIButton *closeButton = [[UIButton alloc]init];
        [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        [closeButton sizeToFit];
        [closeButton addTarget:self action:@selector(finishVC:) forControlEvents:UIControlEventTouchUpInside];
        closeButton.myTop=0;
        closeButton.myLeft=18;
        closeButton.myCenterY=0;
        
        [navBarLayout addSubview:closeButton];
        [navBarLayout addSubview:self.navTitle];
        
        [self.view addSubview:navBarLayout];
    }
}

-(void)finishVC:(id)send
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    //添加监测网页加载进度的观察者
     [self.webView addObserver:self
                    forKeyPath:@"estimatedProgress"
                       options:0
                       context:nil];
    //添加监测网页标题title的观察者
     [self.webView addObserver:self
                    forKeyPath:@"title"
                       options:NSKeyValueObservingOptionNew
                       context:nil];
}

- (void)reloadWebView
{
    [self.webView reload];
}

- (WKWebView *)webView
{
    if (!_webView) {

        //初始化
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, iPhone_Top_NavH, ScreenWidth, ScreenHeight-iPhone_Top_NavH) configuration:self.config];
        // UI代理
        _webView.UIDelegate = self;
        // 导航代理
        _webView.navigationDelegate = self;
        // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
        _webView.allowsBackForwardNavigationGestures = YES;
        
        [self.view addSubview:_webView];
    }
   
    return _webView;

}

- (WKWebViewConfiguration *)config
{
    if (!_config) {
        //创建网页配置对象
        _config = [[WKWebViewConfiguration alloc] init];
        
        // 创建设置对象
        WKPreferences *preference = [[WKPreferences alloc]init];
        //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
        preference.minimumFontSize = 0;
        //设置是否支持javaScript 默认是支持的
        preference.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = YES;
        _config.preferences = preference;
        
        // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
        _config.allowsInlineMediaPlayback = YES;
        //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
        _config.mediaTypesRequiringUserActionForPlayback = YES;
        //设置是否允许画中画技术 在特定设备上有效
        _config.allowsPictureInPictureMediaPlayback = YES;
        //设置请求的User-Agent信息中应用程序名称 iOS9后可用
        _config.applicationNameForUserAgent = @"ZBUtree";
         //自定义的WKScriptMessageHandler 是为了解决内存不释放的问题
//        WeakWebViewScriptMessageDelegate *weakScriptMessageDelegate = [[WeakWebViewScriptMessageDelegate alloc] initWithDelegate:self];
//        //这个类主要用来做native与JavaScript的交互管理
//        WKUserContentController * wkUController = [[WKUserContentController alloc] init];
//        //注册一个name为jsToOcNoPrams的js方法
//        [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"jsToOcNoPrams"];
//        [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"jsToOcWithPrams"];
//        config.userContentController = wkUController;
    }
    return _config;
     
}



    // 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
}
    // 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self.progressView setProgress:0.0f animated:NO];
}
    // 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
}
    // 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    [self getCookie];
}
    //提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.progressView setProgress:0.0f animated:NO];
}
   // 接收到服务器跳转请求即服务重定向时之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
}
    // 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString * urlStr = navigationAction.request.URL.absoluteString;
    NSLog(@"发送跳转请求：%@",urlStr);
    //自己定义的协议头
//    NSString *htmlHeadString = @"github://";
//    if([urlStr hasPrefix:htmlHeadString]){
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"通过截取URL调用OC" message:@"你想前往我的Github主页?" preferredStyle:UIAlertControllerStyleAlert];
//        [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        }])];
//        [alertController addAction:([UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSURL * url = [NSURL URLWithString:[urlStr stringByReplacingOccurrencesOfString:@"github://callName_?" withString:@""]];
//            [[UIApplication sharedApplication] openURL:url];
//        }])];
//        [self presentViewController:alertController animated:YES completion:nil];
//        decisionHandler(WKNavigationActionPolicyCancel);
//    }else{
//        decisionHandler(WKNavigationActionPolicyAllow);
//    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}
    
    // 根据客户端受到的服务器响应头以及response相关信息来决定是否可以跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSString * urlStr = navigationResponse.response.URL.absoluteString;
    NSLog(@"当前跳转地址：%@",urlStr);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
    //需要响应身份验证时调用 同样在block中需要传入用户身份凭证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    //用户身份信息
    NSURLCredential * newCred = [[NSURLCredential alloc] initWithUser:@"user123" password:@"123" persistence:NSURLCredentialPersistenceNone];
    //为 challenge 的发送方提供 credential
    [challenge.sender useCredential:newCred forAuthenticationChallenge:challenge];
    completionHandler(NSURLSessionAuthChallengeUseCredential,newCred);
}
    //进程被终止时调用
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
}


/**
 *  web界面中有弹出警告框时调用
 *
 *  @param webView           实现该代理的webview
 *  @param message           警告框中的内容
 *  @param completionHandler 警告框消失调用
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"HTML的弹出框" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
    // 确认框
    //JavaScript调用confirm方法后回调的方法 confirm是js中的确定框，需要在block中把用户选择的情况传递进去
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
// 输入框
//JavaScript调用prompt方法后回调的方法 prompt是js中的输入框 需要在block中把用户输入的信息传入
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
// 页面是弹出窗口 _blank 处理
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}



//kvo 监听进度 必须实现此方法
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
        && object == _webView) {
       NSLog(@"网页加载进度 = %f",_webView.estimatedProgress);
        self.progressView.progress = _webView.estimatedProgress;
        if (_webView.estimatedProgress >= 1.0f) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.progress = 0;
            });
        }
    }else if([keyPath isEqualToString:@"title"]
             && object == _webView){
        self.navigationItem.title = _webView.title;
        if (self.navTitle) {
            self.navTitle.text=_webView.title;
        }
    }else{
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
    //移除观察者
   [_webView removeObserver:self
                 forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
   [_webView removeObserver:self
                     forKeyPath:NSStringFromSelector(@selector(title))];
}

-(NJKWebViewProgressView*)progressView{
    if (!_progressView) {
        CGFloat progressBarHeight = 3.0f;
        CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
//        CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight-0.5, navigaitonBarBounds.size.width, progressBarHeight);
        CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height, navigaitonBarBounds.size.width, progressBarHeight);
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        _progressView.progressColor = self.progressViewColor;
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    return _progressView;
}

@end
