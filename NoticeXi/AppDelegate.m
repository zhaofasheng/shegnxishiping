//
//  AppDelegate.m
//  NoticeXi
//
//  Created by li lei on 2018/10/18.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "AppDelegate.h"
#import <AFServiceSDK/AFServiceSDK.h>
#import "SXStudyBaseController.h"
#import "WXApi.h"
#import <Bugly/Bugly.h>
#import "NoticeTabbarController.h"
#import "BaseNavigationController.h"
#import "AppDelegate+Share.h"
#import "AppDelegate+Tencent.h"
#import "AppDelegate+Notification.h"
#import "AFHTTPSessionManager.h"
#import "NoticeStaySys.h"
#import "NoticeOTOModel.h"
#import "UNNotificationsManager.h"
#import "ZFSDateFormatUtil.h"
#import "AFNetworking.h"
#import "NoticeDevoiceM.h"
#import "JPUSHService.h"
#import "NoticdShopDetailForUserController.h"
#import "NoticeMyJieYouShopController.h"
#import "NoticeLoginViewController.h"
NSString* const yunAppKey = @"dd8114c96a13f86d8bf0f7de477d9cd9";

//  在APPDelegate.m中声明一个通知事件的key
NSString *const AppDelegateReceiveRemoteEventsNotification = @"AppDelegateReceiveRemoteEventsNotification";

@interface AppDelegate ()<WXApiDelegate>

@property (nonatomic, assign) NSInteger outTime;
@property (nonatomic, strong) UILabel *dismissLabel;
@property (nonatomic, strong,nullable) LGAudioPlayer *noVoicePlayer;

@end

@implementation AppDelegate

{
    UIBackgroundTaskIdentifier _backIden;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //新版本3月12
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    

    // 启动图片延时: 1秒
    [NSThread sleepForTimeInterval:1];
    [NoticeTools changeThemeWith:@"whiteColor"];
    
    if(@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    }else{
        // Fallback on earlier versions
    }
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [NoticeSaveModel setUUIDIFNO];
    

    [Bugly startWithAppId:@"7342677883"];

    //更新用户信息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserInfo) name:@"REFRESHUSERINFORNOTICATION" object:nil];
    //用户登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRootVC) name:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
    //用户退出登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(outLogin) name:@"outLoginClearDataNOTICATION" object:nil];
 

    NoticeTabbarController *tabbarVC = [[NoticeTabbarController alloc] init];
    self.window.rootViewController = tabbarVC;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        [self mustExit];
    });
    
    [self projectOnceCode];
    
    /** 极光推送 */
    [self configurationJPushWithLaunchOptions:launchOptions];
    
    [SDImageCache sharedImageCache].config.maxMemoryCost = 130*1000*1000;
    
    [self changeRootVC];
    [self regreiteShare];
    
    return YES;
}


// 一次性代码
- (void)projectOnceCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *onceKey = @"HWProjectOnceKey";
    if (![defaults boolForKey:onceKey]) {
        // 初始化下载最大并发数为1，默认允许蜂窝网络下载1
        [defaults setInteger:1 forKey:HWDownloadMaxConcurrentCountKey];
        [defaults setBool:YES forKey:HWDownloadAllowsCellularAccessKey];
        [defaults setBool:YES forKey:onceKey];
    }
    
    // 初始化下载单例，若之前程序杀死时有正在下的任务，会自动恢复下载
    [HWDownloadManager shareManager];
    // 开启网络监听
    [[HWNetworkReachabilityManager shareManager] monitorNetworkStatus];
}

- (void)getRootVC{

}

//退出登录相关
- (void)outLogin{
    [(AppDelegate *)[UIApplication sharedApplication].delegate deleteAlias];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel.socketManager.timer invalidate];
    [appdel.socketManager.webSocket close];
    appdel.socketManager = nil;
}

- (void)socketReConnect{
    NoticeSocketManger *socketManger = [[NoticeSocketManger alloc] init];
    [socketManger reConnect];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.socketManager = socketManger;
}

//刷新数据
- (void)refreshUserInfo{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success) {
        if (success) {
            NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
            if (userIn.token) {
                [NoticeSaveModel saveToken:userIn.token];
            }
            [NoticeSaveModel saveUserInfo:userIn];
        }
    } fail:^(NSError *error) {
    }];
}

//登录成功后注册极光和登录腾讯
- (void)changeRootVC{
    
    if ([NoticeSaveModel getUserInfo]) {//已经登录
        [self.noVoicePlayer stopPlaying];
        [self jpushSetAlias];
        [self regsigerTencent];

        NoticeSocketManger *socketManger = [[NoticeSocketManger alloc] init];
        self.socketManager = socketManger;
        [self.socketManager reConnect];
        
        self.payManager = [STRIAPManager shareSIAPManager];
        [self.audioChatTools regTencent];
        
        [self getOrder];
        
        if (self.shopid && self.userid) {
            if ([self.userid isEqualToString:[NoticeTools getuserId]]) {//自己的店铺
                NoticeMyJieYouShopController *ctl = [[NoticeMyJieYouShopController alloc] init];
                [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
            }else{
                NoticdShopDetailForUserController *ctl = [[NoticdShopDetailForUserController alloc] init];
                NoticeMyShopModel *model = [[NoticeMyShopModel alloc] init];
                model.shopId = self.shopid;
                ctl.shopModel = model;
                [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
            }
            self.shopid = nil;
            self.userid = nil;
        }
    }
}

- (LGAudioPlayer *)audioPlayer
{
    if (!_audioPlayer) {
        _audioPlayer = [[LGAudioPlayer alloc] init];
        __weak typeof(self) weakSelf = self;
        _audioPlayer.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
            if (status == AVPlayerItemStatusReadyToPlay) {
                if (weakSelf.audioPlayer.isLocalFile) {
                    //录音
                }
            } else {
                if (status == AVPlayerItemStatusFailed) {
                    [YZC_AlertView showViewWithTitleMessage:@"播放失败，请重试"];
                }
            }
        };
    }
    return _audioPlayer;
}

- (NoticeAudioChatTools *)audioChatTools{
    if(!_audioChatTools){
        _audioChatTools = [[NoticeAudioChatTools alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    }
    return _audioChatTools;
}


- (void)mustExit{
    [self hsUpdateApp];
}

- (void)hsUpdateApp{
    NSString *url = @"http://itunes.apple.com/cn/lookup?id=1358222995";
    [[AFHTTPSessionManager manager] POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        NSArray *results = responseObject[@"results"];

        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"apps/2/5.3.2" Accept:@"application/vnd.shengxi.v5.3.6+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                NoticeDevoiceM *deviceM = [NoticeDevoiceM mj_objectWithKeyValues:dict[@"data"]];
                if (deviceM.forced_update.boolValue) {//需要强制更新的时候判断版本号
                    NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];// 软件的当前版本
                    if ([deviceM.app_version compare:currentVersion] == NSOrderedDescending) {//如果当前版本号小于强制更新版本号
                        NSDictionary *response = results.firstObject;
                        // 给出提示是否前往 AppStore 更新
                         XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"强制更新" message:deviceM.app_content sureBtn:@"退出" cancleBtn:@"更新" right:YES];
                        alerView.resultIndex = ^(NSInteger index) {
                            if (index == 2) {
                                NSString *trackViewUrl = response[@"trackViewUrl"];// AppStore 上软件的地址
                                if (trackViewUrl) {
                                    NSURL *appStoreURL = [NSURL URLWithString:trackViewUrl];
                                    if ([[UIApplication sharedApplication] canOpenURL:appStoreURL]) {
                                        [[UIApplication sharedApplication] openURL:appStoreURL options:@{} completionHandler:nil];
                                    }
                                }
                            }else if (index == 1){
                                exit(0);
                            }
                        };
                        [alerView showXLAlertView];
                    }else{
                        [self autoToNewest:results];
                    }
                }else{
                    [self autoToNewest:results];
                }
            }else{
                [self autoToNewest:results];
            }
        } fail:^(NSError * _Nullable error) {
            [self autoToNewest:results];
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

- (void)autoToNewest:(NSArray *)results{
    if (results && results.count > 0) {
        NSDictionary *response = results.firstObject;
        NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];// 软件的当前版本
        NSString *lastestVersion = response[@"version"];// AppStore 上软件的最新版本
        NSString *newMessage = response[@"releaseNotes"];
        if ([lastestVersion compare:currentVersion] == NSOrderedDescending) {
            // 给出提示是否前往 AppStore 更新
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"版本有更新" message:newMessage preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSString *trackViewUrl = response[@"trackViewUrl"];// AppStore 上软件的地址
                if (trackViewUrl) {
                    NSURL *appStoreURL = [NSURL URLWithString:trackViewUrl];
                    if ([[UIApplication sharedApplication] canOpenURL:appStoreURL]) {
                        [[UIApplication sharedApplication] openURL:appStoreURL options:@{} completionHandler:nil];
                    }
                }
            }]];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
            
        }
    }
}

/// app进入后台后保持运行
- (void)beginTask {
    _backIden = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        //如果在系统规定时间3分钟内任务还没有完成，在时间到之前会调用到这个方法
        [self endBack];
    }];
}
 
/// 结束后台运行，让app挂起
- (void)endBack {
    //切记endBackgroundTask要和beginBackgroundTaskWithExpirationHandler成对出现
    [[UIApplication sharedApplication] endBackgroundTask:_backIden];
    _backIden = UIBackgroundTaskInvalid;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    //进入后台播放无声音频，保持app活跃
    [self.noVoicePlayer startPlayWithUrlandRecoding:[[NSBundle mainBundle] pathForResource:@"novoice" ofType:@"mp3"] isLocalFile:YES];
    
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^(){}];
    self.needStop = YES;
    [NoticeTools setneedConnect:NO];

    if (@available(iOS 16.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] setBadgeCount:0 withCompletionHandler:nil];
    }else {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
    
    [JPUSHService setBadge:0];
    
    if ([NoticeTools getuserId]) {
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopUserInApp/2" Accept:@"application/vnd.shengxi.v5.8.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        } fail:^(NSError * _Nullable error) {
        }];
    }
    
    [self beginTask];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

    [_noVoicePlayer stopPlaying];
    // 进前台 设置不接受远程控制
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    if (![NoticeSaveModel getUserInfo]) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICENOREADNUMMESSAGE" object:nil];
    //进前台，检查socket
    [NoticeTools setneedConnect:YES];
    [self.socketManager reConnect];

    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"apps/2/%@",[NoticeSaveModel getVersion]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
    } fail:^(NSError * _Nullable error) {
    }];
    
    if ([NoticeTools getuserId]) {
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopUserInApp/1" Accept:@"application/vnd.shengxi.v5.8.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        } fail:^(NSError * _Nullable error) {
        }];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    self.hasShowCallView = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"APPWASKILLED" object:nil];//程序杀死，挂断电话
    NSException *exception = [NSException exceptionWithName:[NSString stringWithFormat:@"用户id%@-%@",[NoticeTools getuserId],[NoticeTools getNowTime]] reason:[NSString stringWithFormat:@"%@杀死app%@",[NoticeTools getuserId],[SXTools getCurrentTime]] userInfo:nil];//数据上报
    [Bugly reportExceptionWithCategory:3 name:exception.name reason:exception.reason callStack:@[[NoticeTools getNowTimeStamp]] extraInfo:@{@"d":@"1"} terminateApp:NO];
}


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    
    [[SDWebImageManager sharedManager] cancelAll];
    // 清空缓存（内存）
    [[SDImageCache sharedImageCache] clearMemory];
    // 清空磁盘图片
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
}


//这个是用来保持app活跃在后台
- (LGAudioPlayer *)noVoicePlayer
{
    if (!_noVoicePlayer) {
        _noVoicePlayer = [[LGAudioPlayer alloc] init];
        _noVoicePlayer.playingBlock = ^(CGFloat currentTime) {
       
        };
        _noVoicePlayer.playComplete = ^{
            DRLog(@"无声音频播放停止");
        };
    }
    return _noVoicePlayer;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler{

    NSURLComponents *components = [[NSURLComponents alloc] initWithString:userActivity.webpageURL.absoluteString];
    DRLog(@"%@===%@",userActivity.webpageURL,userActivity.referrerURL);
    
    if (components.queryItems.count) {
        NSURLQueryItem *item1 = components.queryItems[0];
        if ([item1.name isEqualToString:@"seriesId"]) {
            [self pushToKc:item1];
        }
    }
    
    if (components.queryItems.count >= 2) {
        NSURLQueryItem *item1 = components.queryItems[0];
        NSURLQueryItem *item2 = components.queryItems[1];
        [self pushToShop:item1 item2:item2];
    }
    return YES;
}

- (void)pushToShop:(NSURLQueryItem *)item1 item2:(NSURLQueryItem *)item2{
    if ([item1.name isEqualToString:@"shopid"]) {
        if ([NoticeTools getuserId]) {
            if ([item2.value isEqualToString:[NoticeTools getuserId]]) {//自己的店铺
                NoticeMyJieYouShopController *ctl = [[NoticeMyJieYouShopController alloc] init];
                [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
            }else{
                NoticdShopDetailForUserController *ctl = [[NoticdShopDetailForUserController alloc] init];
                NoticeMyShopModel *model = [[NoticeMyShopModel alloc] init];
                model.shopId = item1.value;
                ctl.shopModel = model;
                [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
            }
        }else{
            self.shopid = item1.value;
            self.userid = item2.value;
            NoticeLoginViewController *ctl = [[NoticeLoginViewController alloc] init];
            [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
        }
    }
}

- (void)pushToKc:(NSURLQueryItem *)item1{
    //push_series_id（课程ID）
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"series/get/%@",item1.value] Accept:@"application/vnd.shengxi.v5.8.1+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return;
            }
            SXPayForVideoModel *searismodel = [SXPayForVideoModel mj_objectWithKeyValues:dict[@"data"]];
            if (!searismodel) {
                return;
            }
            SXStudyBaseController *ctl = [[SXStudyBaseController alloc] init];
            ctl.paySearModel = searismodel;
            [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
        }
    } fail:^(NSError *error) {
    }];
}

// 应用处于后台，所有下载任务完成调用
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler
{
    _backgroundSessionCompletionHandler = completionHandler;
}

//微信相关相关
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{

    NSURLComponents *components = [[NSURLComponents alloc] initWithString:url.absoluteString];
    DRLog(@"===%@",url.absoluteString);
    
    if (components.queryItems.count) {
        NSURLQueryItem *item1 = components.queryItems[0];
        if ([item1.name isEqualToString:@"seriesId"]) {
            [self pushToKc:item1];
     
        }
    }
    if (components.queryItems.count == 2) {
        
        NSURLQueryItem *item1 = components.queryItems[0];
        NSURLQueryItem *item2 = components.queryItems[1];
        [self pushToShop:item1 item2:item2];

    }
    if ([url.host isEqualToString:@"apmqpdispatch"]) {
        [AFServiceCenter handleResponseURL:url withCompletion:^(AFAuthServiceResponse *response) {
            DRLog(@"授权结果%@", response.result);
            if (AFAuthResSuccess == response.responseCode) {
                DRLog(@"授权结果%@", response.result);
            }
        }];
    }
    // 打印查询参数
    DRLog(@"Query parameters: %@", components.queryItems);
    


    //这里判断是否发起的请求为微信相关，如果是的话，用WXApi的方法调起微信客户端的支付页面（://pay 之前的那串字符串就是你的APPID，）
    return  [WXApi handleOpenURL:url delegate:self];
}


//获取进行中订单
- (void)getOrder{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopGoodsOrder/select?type=2" Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            DRLog(@"订单%@",dict);
            NoticeByOfOrderModel *orderModel = [NoticeByOfOrderModel mj_objectWithKeyValues:dict[@"data"]];
            if (orderModel.orderId) {
                [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shopGoodsOrder/cache/%@",orderModel.orderId] Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict1, BOOL success1) {
                    if (success1) {
                        DRLog(@"不显示订单");
                    }
                } fail:^(NSError * _Nullable error) {
                }];
            }
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

@end
