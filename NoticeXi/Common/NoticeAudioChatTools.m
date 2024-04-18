//
//  NoticeAudioChatTools.m
//  NoticeXi
//
//  Created by li lei on 2023/3/28.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeAudioChatTools.h"
#import "UIWindow+TUICalling.h"
#import "NoticeXi-Swift.h"
#import "TUICore.h"
#import "TUICallKitOfflinePushInfoConfig.h"
#import "TUILogin.h"
#import "TUICallingStatusManager.h"
#import "TUICallingAction.h"
#import "NoticeQiaojjieTools.h"
#import "TUICallingUserModel.h"
#import "TUICallingUserManager.h"

@implementation NoticeAudioChatTools

- (void)callToUserId:(NSString *)userId roomId:(UInt32)roomIdNum getOrderTime:(NSString *)getOrderTime nickName:(NSString *)nickName autoNext:(BOOL)autonext{
    //设置屏幕常亮
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [[TUICallEngine createInstance] setSelfInfo:@"" avatar:@"" succ:^{
        
    } fail:^(int code, NSString * _Nullable errMsg) {
        
    }];
    
    self.roomId = [NSString stringWithFormat:@"%u",(unsigned int)roomIdNum];
    self.toUserId = userId;
    
    TUIOfflinePushInfo *offlinePushInfo = [TUICallKitOfflinePushInfoConfig createOfflinePushInfo];
    TUICallParams *callParams = [TUICallParams new];
    callParams.offlinePushInfo = offlinePushInfo;
    callParams.timeout = getOrderTime.intValue?getOrderTime.intValue:120;

    TUIRoomId *roomId = [[TUIRoomId alloc] init];
    roomId.intRoomId = roomIdNum;
    callParams.roomId = roomId;
    __weak typeof(self) weakSelf = self;
    _callingViewManager = [[TUICallingViewManager alloc] init];
    [[TUICallingStatusManager shareInstance] setDelegate:self.callingViewManager];
    
    [[TUICallEngine createInstance] call:userId callMediaType:TUICallMediaTypeAudio params:callParams succ:^{

        weakSelf.autoCallNexting = NO;
        if (weakSelf.autoCallNext) {
            weakSelf.autoCallNexting = YES;
        }
        [weakSelf.callingViewManager createCallingView:TUICallMediaTypeAudio callRole:TUICallRoleCall callScene:TUICallSceneSingle];
        
        [NoticeQiaojjieTools showWithJieDanTitle:nickName roomId:self.roomId time:getOrderTime?getOrderTime: @"120" creatTime:@"0" autoNext:autonext clickBlcok:^(NSInteger tag) {
            if ([TUICallingStatusManager shareInstance].callStatus != TUICallStatusNone){
                [TUICallingAction hangup];
            };
            
            if(tag == 1){//自己直接取消
                weakSelf.autoCallNext = NO;
                weakSelf.autoCallNexting = NO;
                if(weakSelf.cancelBlcok){
                    weakSelf.cancelBlcok(YES);
                }
            }else if (tag == 2){//对方超时未接
                if (self.autoNextBlcok && self.autoCallNext) {//自动匹配的话，就执行自动拨打下一单
                    self.autoCallNext = NO;
                    if (self.autoNextBlcok) {
                        self.autoNextBlcok(YES);
                    }
                }else{
                    weakSelf.autoCallNext = NO;
                    weakSelf.autoCallNexting = NO;
                    if(weakSelf.cancelBlcok){
                        weakSelf.cancelBlcok(YES);
                    }
                    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"订单已超时失效，请尝试其它店铺" message:nil cancleBtn:@"知道了"];
                    [alerView showXLAlertView];
                }
            }
         
        }];
    } fail:^(int code, NSString * _Nullable errMsg) {

        [NoticeQiaojjieTools showWithTitle:[NSString stringWithFormat:@"拨打失败，请稍后重试%d%@",code,errMsg]];
        if ([TUICallingStatusManager shareInstance].callStatus != TUICallStatusNone){
            [TUICallingAction hangup];
        };
        if(weakSelf.cancelBlcok){
            weakSelf.cancelBlcok(YES);
        }
    }];

}

- (void)regTencent{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"tentcent/userSig" Accept:@"application/vnd.shengxi.v5.5.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            NoticeByOfOrderModel *userSigM  = [NoticeByOfOrderModel mj_objectWithKeyValues:dict[@"data"]];
            [self regTencentWith:userSigM.user_sig];
        }else{
            [self regTencentWith:nil];
        }
    } fail:^(NSError * _Nullable error) {
        [self regTencentWith:nil];
    }];
}

- (void)regTencentWith:(NSString *)user_sig{
    __weak typeof(self) weakSelf = self;
    
    NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
    NoticeGetUserSig *userSig = [[NoticeGetUserSig alloc] init];
    TUILoginConfig *config = [[TUILoginConfig alloc] init];
    config.logLevel = TUI_LOG_NONE;
    if(user_sig){
        // 组件登录
        [TUILogin login:1400799902 //SDKAppID 1400799902
                 userID:userM.user_id // 请替换为您的 UserID
                userSig:user_sig // 您可以在控制台中计算一个 UserSig 并填在这个位置
                 config:config
                   succ:^{
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [weakSelf onReportToken:appdel.deviceToken];
            [[TUICallEngine createInstance] init:[TUILogin getSdkAppID] userId:[TUILogin getUserID] userSig:[TUILogin getUserSig] succ:^{
                DRLog(@"引擎设置成功");
            } fail:^(int code, NSString *errMsg) {
            }];
            DRLog(@"腾讯云登录成功");
        }
                   fail:^(int code, NSString *msg) {
            DRLog(@"腾讯云登录失败: %d, error: %@", code, msg);
        }];
        
    }else{
        // 组件登录
        [TUILogin login:1400799902 //SDKAppID
                 userID:userM.user_id // 请替换为您的 UserID
                userSig:[userSig getTencentUserSigWithIdentifier:userM.user_id] // 您可以在控制台中计算一个 UserSig 并填在这个位置
                 config:config
                   succ:^{
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [weakSelf onReportToken:appdel.deviceToken];
            DRLog(@"腾讯云登录成功");
        }
                   fail:^(int code, NSString *msg) {
            DRLog(@"腾讯云登录失败: %d, error: %@", code, msg);
        }];
    }
    
    [[TUICallEngine createInstance] addObserver:self];
    //自定义UI
    [[TUICallKit createInstance] enableCustomViewRoute:YES];
    self.selfUserId = [NoticeTools getuserId];
}

- (UIWindow *)callingWindow {
    if (!_callingWindow) {
        _callingWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _callingWindow.windowLevel = UIWindowLevelAlert - 1;
        _callingWindow.backgroundColor = [UIColor clearColor];
    }
    return _callingWindow;
}

- (void)onReportToken:(NSData *)deviceToken
{
    if (deviceToken) {
        V2TIMAPNSConfig *confg = [[V2TIMAPNSConfig alloc] init];
        // 企业证书 ID
        // 用户自己到苹果注册开发者证书，在开发者帐号中下载并生成证书(p12 文件)，将生成的 p12 文件传到腾讯证书管理控制台，
        // 控制台会自动生成一个证书 ID，将证书 ID 传入一下 busiId 参数中。
        //38113生产环境 38114开发环境
        confg.businessID = 38113;
        confg.token = deviceToken;
        [[V2TIMManager sharedInstance] setAPNS:confg succ:^{
             DRLog(@"%s, 推送证书设置成功", __func__);
        } fail:^(int code, NSString *msg) {
             DRLog(@"%s, 推送证书设置失败, %d, %@", __func__, code, msg);
        }];
    }
}

- (NoticeShopGetOrderTostView *)callView{
    if (!_callView) {
        _callView = [[NoticeShopGetOrderTostView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _callView.isAudioCalling = YES;
        __weak typeof(self) weakSelf = self;
        _callView.acceptBlock = ^(BOOL accept) {
            if(accept){
                [weakSelf accept];
            }else{
                [weakSelf repject:NO];
            }
        };
        
        _callView.endOpenBlock = ^(BOOL close) {
            [weakSelf repject:YES];
        };
    }
    return _callView;
}

//接听
- (void)accept{
    
    if (self.noReClick) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) { // 有使用麦克风的权限
                self.noReClick = YES;
                [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shopGoodsOrder/%@",weakSelf.orderModel.room_id] Accept:@"application/vnd.shengxi.v5.5.0+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                    if(success){
                        [[TUICallEngine createInstance] setSelfInfo:@"店主" avatar:@"" succ:^{
                        } fail:^(int code, NSString * _Nullable errMsg) {
                        }];
                        [TUICallingAction accept];
                    }else{
                        [TUICallingAction reject];
                    }
                    
                    [[NoticeTools getTopViewController] hideHUD];
                } fail:^(NSError * _Nullable error) {
                    [TUICallingAction reject];
                    [[NoticeTools getTopViewController] hideHUD];
                    self.noReClick = NO;
                }];
            }else { // 没有麦克风权限
                XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"recoder.kaiqire"] message:@"有麦克风权限才可以语音通话功能哦~" sureBtn:[NoticeTools getLocalStrWith:@"recoder.kaiqi"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
                alerView.resultIndex = ^(NSInteger index) {
                    if (index == 1) {
                        UIApplication *application = [UIApplication sharedApplication];
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if ([application canOpenURL:url]) {
                            if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                                if (@available(iOS 10.0, *)) {
                                    [application openURL:url options:@{} completionHandler:nil];
                                }
                            } else {
                                [application openURL:url options:@{} completionHandler:nil];
                            }
                        }
                    }
                };
                [alerView showXLAlertView];
            }
        });
    }];
}

//拒绝
- (void)repject:(BOOL)close{
    
    if (!self.orderModel.room_id || !self.orderModel) {
        if (close) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHMYWALLECT" object:nil];
        }
        [TUICallingAction reject];
        return;
    }
    
    [TUICallingAction reject];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:close?@"5": @"3" forKey:@"orderType"];
    [parm setObject:self.orderModel.room_id forKey:@"roomId"];
    [[DRNetWorking shareInstance] requestWithPatchPath:@"shopGoodsOrder" Accept:@"application/vnd.shengxi.v5.5.0+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            [[NoticeTools getTopViewController] showToastWithText:close?@"已拒绝，店铺已结束营业":@"已拒绝"];
            if (close) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHMYWALLECT" object:nil];
            }
            [TUICallingAction reject];
        }else{
            [TUICallingAction reject];
        }
    } fail:^(NSError * _Nullable error) {
        [TUICallingAction reject];
    }];
    [[TUICallingStatusManager shareInstance] clearAllStatus];
}

//获取等待的订单
- (void)getOrder{
    self.noReClick = NO;
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopGoodsOrder/select?type=2" Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            DRLog(@"当前进行中等待中的订单%@",dict);
            self.orderModel = [NoticeByOfOrderModel mj_objectWithKeyValues:dict[@"data"]];
            if(self.orderModel.goods_type.intValue == 2){
                UIViewController *viewController = [[UIViewController alloc] init];
                [viewController.view addSubview:self.callView];
                self.callingWindow.rootViewController = viewController;
                self.callingWindow.hidden = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self->_callingWindow != nil) {
                        [self.callingWindow t_makeKeyAndVisible];
                    }
                });
                return;
            }else{
                [self repject:NO];
            }
        }else{
            [self repject:NO];
        }

    } fail:^(NSError * _Nullable error) {
        [self repject:NO];

    }];
}

/**
 * 通话接通的回调(主叫和被叫都可以收到)
 *
 * @param roomId        此次通话的音视频房间 ID
 * @param callMediaType 通话的媒体类型，比如视频通话、语音通话
 * @param callRole      角色，枚举类型：主叫、被叫
 */
- (void)onCallBegin:(TUIRoomId *)roomId callMediaType:(TUICallMediaType)callMediaType callRole:(TUICallRole)callRole {
    [self clearCallWaitView];
    DRLog(@"接通电话%u",(unsigned int)roomId.intRoomId);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOPCANCELORDER" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOPHASJUBAOEDSELFJUBAO" object:nil];
    self.callingView = nil;
    NoticeCallView *callView = [[NoticeCallView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    self.callingView = callView;
    self.callingView.roomId = [NSString stringWithFormat:@"%u",(unsigned int)roomId.intRoomId];
    callView.fromUserId = self.fromUserId;
    callView.toUserId = self.toUserId;
    [callView showCallView];
    [[NoticeTools getTopViewController] hideHUD];
}

/**
 * 通话结束的回调(主叫和被叫都可以收到)
 *
 * @param roomId        此次通话的音视频房间 ID
 * @param callMediaType 通话的媒体类型，比如视频通话、语音通话
 * @param callRole      角色，枚举类型：主叫、被叫
 * @param totalTime     此次通话的时长
 */
- (void)onCallEnd:(TUIRoomId *)roomId callMediaType:(TUICallMediaType)callMediaType callRole:(TUICallRole)callRole totalTime:(float)totalTime {
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    DRLog(@"通话结束");
    self.autoCallNexting = NO;
    self.fromUserId = nil;
    self.toUserId = nil;
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    if(totalTime < 1){
        totalTime = 1;
    }
    [parm setObject:[NSString stringWithFormat:@"%d",(int)totalTime] forKey:@"second"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shopGoodsOrder/complete/0/%u",(unsigned int)roomId.intRoomId] Accept:@"application/vnd.shengxi.v5.5.0+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            DRLog(@"订单这设置为完成");
        }
    } fail:^(NSError * _Nullable error) {
    }]; 
    [[NoticeTools getTopViewController] hideHUD];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOPOVERCHATORDER" object:nil];
}


- (void)onCallReceived:(NSString *)callerId calleeIdList:(NSArray<NSString *> *)calleeIdList groupId:(NSString *)groupId callMediaType:(TUICallMediaType)callMediaType userData:(NSString *)userData{
    DRLog(@"收到%@的通话请求",callerId);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HASGETSHOPVOICECHANTTOTICE" object:nil];
    self.fromUserId = callerId;
    [self getOrder];
}

/**
 * 通话取消的回调
 *
 * @param callerId 取消用户ID
 */
- (void)onCallCancelled:(NSString *)callerId{
    DRLog(@"%@取消通话 自己%@",callerId,[NoticeTools getuserId]);
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [[NoticeTools getTopViewController] hideHUD];
    [self clearCallWaitView];
    
    if (!self.autoCallNexting) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOPCANCELORDER" object:nil];
    }
    if ([callerId isEqualToString:self.fromUserId]) {

        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"对方取消了订单" message:nil cancleBtn:@"好的，知道了"];
        [alerView showXLAlertView];
    }
    
    self.fromUserId = nil;
    self.toUserId = nil;
}

/**
 * xxxx 用户拒绝通话的回调
 *
 * @param userId 拒绝用户的 ID
 */
- (void)onUserReject:(NSString *)userId{
    DRLog(@"拒绝通话%@",userId);
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOPCANCELORDER" object:nil];
    self.fromUserId = nil;
    self.toUserId = nil;
    if (!self.autoCallNexting) {
        if(self.repjectBlcok){
            self.repjectBlcok(YES);
        }
    }else{
        self.autoCallNexting = NO;
        if (self.repjectautoNextBlcok) {
            self.repjectautoNextBlcok(YES);
        }
    }
}

/**
 * xxxx 用户不响应的回调
 *
 * @param userId 无响应用户的 ID
 */
- (void)onUserNoResponse:(NSString *)userId{
    DRLog(@"通话无响应");
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    self.fromUserId = nil;
    self.toUserId = nil;
    [self clearCallWaitView];
    if(!self.autoCallNexting){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOPNOACCEPECT" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOPCANCELORDER" object:nil];
    }
}

/**
 * xxxx 用户忙线的回调
 *
 * @param userId 忙线用户的 ID
 */
- (void)onUserLineBusy:(NSString *)userId{
    DRLog(@"用户忙线的回调");
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    self.fromUserId = nil;
    self.toUserId = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOPCANCELORDER" object:nil];
    [self clearCallWaitView];

}

//根据通话人的音量变化监听谁在说话
- (void)onUserVoiceVolumeChanged:(NSDictionary<NSString *, NSNumber *> *)volumeMap{
 
    NSArray *keyArray = volumeMap.allKeys;
    for (NSString *userId in keyArray) {
        if (userId) {
            if(self.fromUserId){//如果存在来电者id，则自己是店主
                if([userId isEqualToString:self.fromUserId]){//如果id是来电者的id，那么这个人是用户
                    [self.callingView setUserVolume:[volumeMap[userId] floatValue]];
                }else{
                    [self.callingView setShopVolume:[volumeMap[userId] floatValue]];
                }
            }else{
                if([userId isEqualToString:self.toUserId]){//被呼叫的人是店主
                    [self.callingView setShopVolume:[volumeMap[userId] floatValue]];
                }else{
                    [self.callingView setUserVolume:[volumeMap[userId] floatValue]];
                }
            }
        }
    }
    [self.callingView refreshStars];
}

- (void)clearCallWaitView{
    [self.callView removeFromSuperview];
    self.callingWindow.hidden = YES;
    self.callingWindow = nil;
}

@end
