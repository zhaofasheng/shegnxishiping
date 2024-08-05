//
//  AppDelegate.m
//  NoticeXi
//
//  Created by li lei on 2018/10/18.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "AppDelegate.h"

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
#import "CMUUIDManager.h"
#import "JPUSHService.h"
#import "NoticeLoginViewController.h"
#import "SXHasUpdateKcModel.h"
#import "SXBandKcToastView.h"
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
    
   
    [NoticeTools changeThemeWith:@"whiteColor"];
    
    if(@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    }else{
        // Fallback on earlier versions
    }
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [NoticeSaveModel setUUIDIFNO];
    [self regreiteShare];

    [Bugly startWithAppId:@"7342677883"];

    //更新用户信息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserInfo) name:@"REFRESHUSERINFORNOTICATION" object:nil];
    //用户登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRootVC) name:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
    //用户退出登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(outLogin) name:@"outLoginClearDataNOTICATION" object:nil];
 
    self.payManager = [STRIAPManager shareSIAPManager];
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
    
    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
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
        //[SXTools removeLocalToken];
        [self.noVoicePlayer stopPlaying];
        [self jpushSetAlias];
        [self regsigerTencent];

        NoticeSocketManger *socketManger = [[NoticeSocketManger alloc] init];
        self.socketManager = socketManger;
        [self.socketManager reConnect];
        
        [self.audioChatTools regTencent];
        [self getIfHasDeviceKc];
        [self getOrder];
        
        if (self.shopid && self.userid) {
            [self pushToShop:self.shopid userId:self.userid];
        }else if (self.pushSeriseId){
            [self pushToKc:self.pushSeriseId];
        }else if (self.videoId){
            [self pushVideoDetail:self.videoId];
        }
        
        
    }
}

    
//获取设备是否存在购买课程
- (void)getIfHasDeviceKc{
    //获得UUID存入keyChain中
    NSUUID *UUID=[UIDevice currentDevice].identifierForVendor;
    NSString *uuid = [CMUUIDManager readUUID];
    
    if (uuid==nil) {
        [CMUUIDManager deleteUUID];
        [CMUUIDManager saveUUID:UUID.UUIDString];
        uuid = UUID.UUIDString;
    }
    if (uuid) {
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setObject:uuid forKey:@"uuid"];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"users/uuid/series" Accept:@"application/vnd.shengxi.v5.8.5+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                SXHasUpdateKcModel *model = [SXHasUpdateKcModel mj_objectWithKeyValues:dict[@"data"]];
                if (model.can_bind_list.count) {
                    SXBandKcToastView *bindView = [[SXBandKcToastView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
                    bindView.canString = [model.canArr componentsJoinedByString:@" "];
                    if (model.noCanArr.count) {
                        bindView.noCanString = [model.noCanArr componentsJoinedByString:@" "];
                    }
                    [bindView showInfoView];
                }
            }
        } fail:^(NSError * _Nullable error) {
        }];
    }

}

- (LGAudioPlayer *)audioPlayer
{
    if (!_audioPlayer) {
        _audioPlayer = [[LGAudioPlayer alloc] init];
        __weak typeof(self) weakSelf = self;
        _audioPlayer.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
            if (status == AVPlayerItemStatusReadyToPlay) {
                if (weakSelf.audioPlayer.isLocalFile){
                    //录音
                }
            }else {
                if (status == AVPlayerItemStatusFailed){
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

// app进入后台后保持运行
- (void)beginTask {
    _backIden = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        //如果在系统规定时间3分钟内任务还没有完成，在时间到之前会调用到这个方法
        [self endBack];
    }];
}
 
// 结束后台运行，让app挂起
- (void)endBack {
    //切记endBackgroundTask要和beginBackgroundTaskWithExpirationHandler成对出现
    [[UIApplication sharedApplication] endBackgroundTask:_backIden];
    _backIden = UIBackgroundTaskInvalid;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SXAPPHASINTOBACKGROUNDNOTICE" object:nil];
    
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
    
    //来电推送相关
    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
  
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
    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
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
    }
    return _noVoicePlayer;
}

// 应用处于后台，所有下载任务完成调用
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler
{
    _backgroundSessionCompletionHandler = completionHandler;
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

- (SXDanLiPlayKcTools *)playKcTools{
    if (!_playKcTools) {
        _playKcTools = [[SXDanLiPlayKcTools  alloc] initWithFrame:CGRectZero];

    }
    return _playKcTools;
}
@end
