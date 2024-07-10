//
//  AppDelegate+Notification.m
//  XGFamilyTerminal
//
//  Created by HandsomeC on 2018/5/5.
//  Copyright © 2018年 xiao_5. All rights reserved.
//

#import "AppDelegate+Notification.h"
// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "NoticeJpush.h"
#import "SXVideoCommentMeassageController.h"
#import "SXVideoCommentLikeController.h"
#import "NoticeSysViewController.h"
#import "SXStudyBaseController.h"
#import "NoticeTabbarController.h"
#import "BaseNavigationController.h"
#import "NoticePushModel.h"
#import <NIMSDK/NIMSDK.h>
#import "SXShopLyListController.h"
#import "NoticeSCViewController.h"
#import "SXKcHasGetLikeController.h"
#import "SXHasGetComController.h"
#import "AFHTTPSessionManager.h"
#import "NoticeDevoiceM.h"
@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate (Notification)

- (void)configurationJPushWithLaunchOptions:(NSDictionary *)launchOptions {
    
    //【注册通知】通知回调代理（可选）
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert | JPAuthorizationOptionBadge | JPAuthorizationOptionSound | JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        // Fallback on earlier versions
    }
    
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    
    [JPUSHService setupWithOption:launchOptions appKey:@"73a728a890f7850c1c9a33b6"
                          channel:@"AppStore"
                 apsForProduction:YES
            advertisingIdentifier:nil];
    
    // [UNNotificationsManager registerLocalNotification];
    [self registNotification];
    
}


- (void)registNotification
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:
                [UIUserNotificationSettings settingsForTypes:
                (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
                (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
}

- (void)jpushSetAlias{
    if (![[NoticeSaveModel getUserInfo] socket_id] || [[NoticeSaveModel getUserInfo] socket_id].length < 5) {
        return;
    }
    
    if ([[NoticeSaveModel getUserInfo] socket_id]) {
        [JPUSHService setAlias:[[NoticeSaveModel getUserInfo] socket_id]?[[NoticeSaveModel getUserInfo] socket_id]:@"0" completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            if (![[NoticeSaveModel getUserInfo] socket_id] || [[NoticeSaveModel getUserInfo] socket_id].length < 5) {
                return;
            }
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:[[NoticeSaveModel getUserInfo] socket_id]?[[NoticeSaveModel getUserInfo] socket_id]:@"0" forKey:@"jpushId"];
            [parm setObject:@"2" forKey:@"platformId"];
            [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                if (success) {
                    DRLog(@"极光id更新成功");
                }
            } fail:^(NSError *error) {
            }];
            DRLog(@"rescode: %ld, \nalias: %@\n", (long)iResCode, iAlias);
        } seq:0];
    }
}

- (void)deleteAlias {
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        DRLog(@"deleteJpush : rescode: %ld, \nalias: %@\n", (long)iResCode, iAlias);
    } seq:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [JPUSHService setBadge:0];
    //清除角标
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.badge = @(0);
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"clearBadge" content:content trigger:nil];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [JPUSHService setBadge:0];
    //清除角标
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.badge = @(0);
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"clearBadge" content:content trigger:nil];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {}];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    DRLog(@"鼎折覆餗");
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}


/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [JPUSHService registerDeviceToken:deviceToken];
    self.deviceToken = deviceToken;
    // 上传devicetoken至云信服务端。
    [[NIMSDK sharedSDK] updateApnsToken:deviceToken];
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    DRLog(@"推送2\n%@",userInfo);
    NoticeJpush *pushM = [NoticeJpush mj_objectWithKeyValues:userInfo];
    if ([pushM.type isEqualToString:@"12"]) {
        return;
    }
    
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    }
    
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)//程序q在前台时不收极光推送
    {
        return;
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
	NSDictionary * userInfo = response.notification.request.content.userInfo;
    NoticePushModel *model = [NoticePushModel mj_objectWithKeyValues:userInfo];

    BaseNavigationController *nav = nil;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"moveIn"
                                                                    withSubType:kCATransitionFromTop
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionDefault
                                                                           view:nav.topViewController.navigationController.view];
    [nav.topViewController.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    //
    if (model.push_type.intValue == 10) {//私聊
        NoticeSCViewController *vc = [[NoticeSCViewController alloc] init];
        vc.toUser = [NSString stringWithFormat:@"%@%@",socketADD,model.push_user_id];
        vc.toUserId = model.push_user_id;
        vc.navigationItem.title = model.push_user_nick_name;
        [nav.topViewController.navigationController pushViewController:vc animated:NO];
    }else if (model.push_type.intValue == 1){//系统消息
        NoticeSysViewController *ctl = [[NoticeSysViewController alloc] init];
        [nav.topViewController.navigationController pushViewController:ctl animated:NO];
    }else if (model.push_type.intValue == 2025){//店铺留言消息
        SXShopLyListController *ctl = [[SXShopLyListController alloc] init];
        [nav.topViewController.navigationController pushViewController:ctl animated:NO];
    }
    else if (model.push_type.intValue == 20001 || model.push_type.intValue == 20002){//视频评论回复消息
        SXVideoCommentMeassageController *ctl = [[SXVideoCommentMeassageController alloc] init];
        [nav.topViewController.navigationController pushViewController:ctl animated:NO];
    }else if (model.push_type.intValue == 20003){//视频评论回复的点赞消息
        SXVideoCommentLikeController *ctl = [[SXVideoCommentLikeController alloc] init];
        [nav.topViewController.navigationController pushViewController:ctl animated:NO];
    }else if (model.push_type.intValue == 2024){//课程更新
        //push_series_id（课程ID）
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"series/get/%@",model.push_series_id] Accept:@"application/vnd.shengxi.v5.8.1+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
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
    } else if (model.push_type.intValue == 20004 || model.push_type.intValue == 20005){//课程评论回复消息
        SXHasGetComController *ctl = [[SXHasGetComController alloc] init];
        [nav.topViewController.navigationController pushViewController:ctl animated:NO];
    }else if (model.push_type.intValue == 20006){//课程点赞消息
        SXKcHasGetLikeController *ctl = [[SXKcHasGetLikeController alloc] init];
        [nav.topViewController.navigationController pushViewController:ctl animated:NO];
    }
    
    if (@available(iOS 10.0, *)) {
		if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
			[JPUSHService handleRemoteNotification:userInfo];
		}
	}
	completionHandler();// 系统要求执行这个方法
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


@end
