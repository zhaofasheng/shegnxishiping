//
//  SXWebViewController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/28.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXWebViewController.h"
#import <WebKit/WebKit.h>

@interface SXWebViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (strong, nonatomic) WKWebView *webView;

@end

@implementation SXWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 设置偏好设置
    config.preferences = [[WKPreferences alloc] init];
    // 默认认为YES
    config.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    // web内容处理池
    config.processPool = [[WKProcessPool alloc] init];
    WKUserContentController* userContentController = WKUserContentController.new;
    // 通过JS与webview内容交互
    config.userContentController = userContentController;
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT) configuration:config];
    webView.backgroundColor = [UIColor whiteColor];
    NSURL *url = [NSURL URLWithString:self.url];
    // 根据URL创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // WKWebView加载请求
    [webView loadRequest:request];
    // 将WKWebView添加到视图
    [self.view addSubview:webView];
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self showHUD];
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    //self.title = webView.title;
    [self hideHUD];
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
 
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width-20, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
    //修改字体大小 300%
    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '200%'"completionHandler:nil];
    //修改背景颜色
    [webView evaluateJavaScript:@"document.body.style.backgroundColor=\"#FFFFFF\"" completionHandler:nil];
}

@end
