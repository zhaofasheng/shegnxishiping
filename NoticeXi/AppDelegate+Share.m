//
//  AppDelegate+Share.m
//  XGFamilyTerminal
//
//  Created by 赵小二 on 2018/7/24.
//  Copyright © 2018年 xiao_5. All rights reserved.
//

#import "AppDelegate+Share.h"
/*分享头文件*/
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
#import "NoticeLoginViewController.h"
#import "NoticdShopDetailForUserController.h"
#import "NoticeMyJieYouShopController.h"
#import "SXPlayFullListController.h"
#import "SXStudyBaseController.h"

#import <AFServiceSDK/AFServiceSDK.h>

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate (Share)

- (void)regreiteShare{
    
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        //QQ
        [platformsRegister setupQQWithAppId:@"101461065" appkey:@"459701b937fc61ac1bbad1a0be2c46ce"];
        //微信
        [platformsRegister setupWeChatWithAppId:@"wx1c7709f7121a6877" appSecret:@"ad861fb8d0c1d534b488b18b1057945d"];//登录用的
    }];
}


//相关相关
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{

    NSURLComponents *components = [[NSURLComponents alloc] initWithString:url.absoluteString];
    DRLog(@"===%@",url.absoluteString);
    
    if (components.queryItems.count) {
        NSURLQueryItem *item1 = components.queryItems[0];
        if ([item1.name isEqualToString:@"seriesId"]) {
            if (![NoticeTools getuserId]) {
                NoticeLoginViewController *ctl = [[NoticeLoginViewController alloc] init];
                [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
                self.pushSeriseId = item1.value;
              
            }else{
                [self pushToKc:item1.value];
            }
            
        }else if ([item1.name isEqualToString:@"videoId"]){
            if (![NoticeTools getuserId]) {
                NoticeLoginViewController *ctl = [[NoticeLoginViewController alloc] init];
                [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
                self.videoId = item1.value;
              
            }else{
                [self pushVideoDetail:item1.value];
            }
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


- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler{

    NSURLComponents *components = [[NSURLComponents alloc] initWithString:userActivity.webpageURL.absoluteString];
    DRLog(@"%@===%@",userActivity.webpageURL,userActivity.referrerURL);
    
    if (components.queryItems.count) {
        NSURLQueryItem *item1 = components.queryItems[0];
        if ([item1.name isEqualToString:@"seriesId"]) {
            if (![NoticeTools getuserId]) {
                NoticeLoginViewController *ctl = [[NoticeLoginViewController alloc] init];
                [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
                self.pushSeriseId = item1.value;
              
            }else{
                [self pushToKc:item1.value];
            }
            
        }else if ([item1.name isEqualToString:@"videoId"]){
            if (![NoticeTools getuserId]) {
                NoticeLoginViewController *ctl = [[NoticeLoginViewController alloc] init];
                [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
                self.videoId = item1.value;
              
            }else{
                [self pushVideoDetail:item1.value];
            }
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
            [self pushToShop:item1.value userId:item2.value];
        }else{
            self.shopid = item1.value;
            self.userid = item2.value;
            NoticeLoginViewController *ctl = [[NoticeLoginViewController alloc] init];
            [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
        }
    }
}

- (void)pushToKc:(NSString *)seriseId{
    //push_series_id（课程ID）
    [[NoticeTools getTopViewController] showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"series/get/%@",seriseId] Accept:@"application/vnd.shengxi.v5.8.1+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [[NoticeTools getTopViewController] hideHUD];
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
        [[NoticeTools getTopViewController] hideHUD];
    }];
    self.pushSeriseId = nil;
}

- (void)pushVideoDetail:(NSString *)videoId{
    [[NoticeTools getTopViewController] showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"video/appletDetail/%@",videoId] Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [[NoticeTools getTopViewController] hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return;
            }
            SXVideosModel *videoM = [SXVideosModel mj_objectWithKeyValues:dict[@"data"]];
            if (!videoM) {
                return;
            }
       
            videoM.textContent = [NSString stringWithFormat:@"%@\n%@",videoM.title,videoM.introduce];
            SXPlayFullListController *ctl = [[SXPlayFullListController alloc] init];
            ctl.modelArray = [NSMutableArray arrayWithArray:@[videoM]];
            ctl.currentPlayIndex = 0;
            ctl.noRequest = YES;
            [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
            
        }
        
    } fail:^(NSError *error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
    self.videoId = nil;
}

- (void)pushToShop:(NSString *)shopId userId:(NSString *)userId{
    if (shopId && userId) {
        if ([userId isEqualToString:[NoticeTools getuserId]]) {//自己的店铺
            NoticeMyJieYouShopController *ctl = [[NoticeMyJieYouShopController alloc] init];
            [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
        }else{
            NoticdShopDetailForUserController *ctl = [[NoticdShopDetailForUserController alloc] init];
            NoticeMyShopModel *model = [[NoticeMyShopModel alloc] init];
            model.shopId = shopId;
            ctl.shopModel = model;
            [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
        }
        self.shopid = nil;
        self.userid = nil;
    }
}

@end
