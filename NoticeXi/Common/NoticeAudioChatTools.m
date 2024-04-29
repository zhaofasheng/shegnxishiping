//
//  NoticeAudioChatTools.m
//  NoticeXi
//
//  Created by li lei on 2023/3/28.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeAudioChatTools.h"
#import "NoticeXi-Swift.h"
#import "NoticeQiaojjieTools.h"
#import "UIWindow+TUICalling.h"
#import <NIMSDK/NIMSDK.h>
#import <NERtcCallKit/NERtcCallKit.h>
#import <NERtcSDK/NERtcSDK.h>
#import "NoticeYunXin.h"
#import <Bugly/Bugly.h>
static NSString *const yunxinAppKey = @"b168ffd044d3549bdd592e0ea696cd65";

@interface NoticeAudioChatTools()<NECallEngineDelegate>

@property(nonatomic, assign) UInt64 calleruid;//呼叫方的uid
@property (nonatomic, strong) NSString *currentRoomId;
@property (nonatomic, assign) NSInteger chatTime;//聊天时长

@end

@implementation NoticeAudioChatTools

{
    NSInteger loginCount;
}


- (void)callToUserId:(NSString *)userId roomId:(NSInteger)roomIdNum getOrderTime:(NSString *)getOrderTime nickName:(NSString *)nickName autoNext:(BOOL)autonext{
    //设置屏幕常亮
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];

    self.roomId = [NSString stringWithFormat:@"%ld",roomIdNum];
    self.toUserId = userId;
    __weak typeof(self) weakSelf = self;
    
    NECallParam *callParam = [[NECallParam alloc] initWithAccId:userId withCallType:NECallTypeAudio];
    callParam.pushConfig.pushContent = @"有一条新的语音电话";
    callParam.extraInfo = [NoticeTools getuserId];//自定义信息为拨打者的用户id
    callParam.rtcChannelName = self.roomId;
    [[NECallEngine sharedInstance] call:callParam completion:^(NSError * _Nullable error, NECallInfo * _Nullable callInfo) {
        if (!error) {
            weakSelf.autoCallNexting = NO;
            if (weakSelf.autoCallNext) {
                weakSelf.autoCallNexting = YES;
            }
            DRLog(@"云信拨打电话成功\n房间信息%@--%ld\n房间号%@",callInfo.rtcInfo.channelName,callInfo.rtcInfo.channelId,self.roomId);
            
            NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@给%@拨打电话成功\n房间号%@\n时间%@",[NoticeTools getuserId],userId,self.roomId,[SXTools getCurrentTime]] userInfo:nil];//数据上报
            [Bugly reportException:exception];
            
            [NoticeQiaojjieTools showWithJieDanTitle:nickName roomId:self.roomId time:getOrderTime?getOrderTime: @"120" creatTime:@"0" autoNext:autonext clickBlcok:^(NSInteger tag) {
                [weakSelf hanupyunxin];
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
        }else{
            NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@给%@拨打电话失败\n房间号%@\n时间%@\n原因%@",[NoticeTools getuserId],userId,self.roomId,[SXTools getCurrentTime],error.description] userInfo:nil];//数据上报
            [Bugly reportException:exception];
            
            [[NoticeTools getTopViewController] showToastWithText:[NSString stringWithFormat:@"拨打失败，请稍后重试%@",error.description]];
            if(weakSelf.cancelBlcok){
                weakSelf.cancelBlcok(YES);
            }
        }
    }];
}

- (void)regWangyiyun{
    //推荐在程序启动的时候初始化 NIMSDK 注册云信
    NSString *appKey        = yunxinAppKey;//云信分配的 appKey
    NIMSDKOption *option    = [NIMSDKOption optionWithAppKey:appKey];
    option.apnsCername      = @"testPush";//APNs 推送证书名 正式环境prPush 测试环境devPush
    [[NIMSDK sharedSDK] registerWithOption:option];
    [self setupSDK];
}


- (void)setupSDK {
    NESetupConfig *config = [[NESetupConfig alloc] initWithAppkey:yunxinAppKey];
    [[NECallEngine sharedInstance] setup:config];
    
    //    1.用户信息接口返回了云信账号密码的时候直接使用登录云信
    //    2.用户信息接口没返回的是，主动调用后端接口获取登录
    NoticeUserInfoModel *userInfo = [NoticeSaveModel getUserInfo];
    if (userInfo.user_id && userInfo.yunxin_token && userInfo.yunxin_token.length > 3) {
        DRLog(@"存在云信token直接登录");
        NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@存在云信token登录\n时间%@",[NoticeTools getuserId],[SXTools getCurrentTime]] userInfo:nil];//数据上报
        [Bugly reportException:exception];
        
        [self loginToYunxin:userInfo];
    }else{
        [self loginTiYunxin];
    }

}

- (void)loginToYunxin:(NoticeUserInfoModel *)userInfo{
    [NIMSDK.sharedSDK.loginManager login:userInfo.yunxin_id token:userInfo.yunxin_token completion:^(NSError * _Nullable error) {
        if(!error){
            self->loginCount = 0;
            DRLog(@"登录云信成功");
            NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@云信登录成功\n时间%@",[NoticeTools getuserId],[SXTools getCurrentTime]] userInfo:nil];//数据上报
            [Bugly reportException:exception];
        }else{
            NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@--%@云信登录失败\n时间%@\n原因%@",userInfo.yunxin_id,userInfo.yunxin_token,[SXTools getCurrentTime],error.description] userInfo:nil];//数据上报
            [Bugly reportException:exception];
            DRLog(@"%@====%@登录云信失败%@",userInfo.yunxin_id,userInfo.yunxin_token,error.description);
            if (self->loginCount < 5) {
                self->loginCount++;
                [self loginTiYunxin];
            }
        }
    }];
    [NECallEngine.sharedInstance addCallDelegate:self];
    //    [NECallEngine sharedInstance].engineDelegate = self;
    //
    //    NERtcEngine *coreEngine = [NERtcEngine sharedEngine];
    //    [coreEngine enableAudioVolumeIndication:YES interval:1000 vad:YES]; // 启用说话者音量提示,在 onRemoteAudioVolumeIndication 和 onRemoteAudioVolumeIndication 回调中每隔 1000ms 返回音量提示
}

//获取云信toekn
- (void)loginTiYunxin{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        if ([NoticeSaveModel getUserInfo]) {//已经登录
            self->loginCount++;
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/yxtoken",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
                if (success) {
                    if ([dict[@"data"] isEqual:[NSNull null]]) {
                        if (self->loginCount < 5) {
                           [self loginTiYunxin];
                        }
                        return ;
                    }
                    NoticeYunXin *yunxin = [NoticeYunXin mj_objectWithKeyValues:dict[@"data"]];
                    DRLog(@"云信token>>>>%@",yunxin.token);
                    NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@获取云信token接口\n时间%@\n获取的数据%@",[NoticeTools getuserId],[SXTools getCurrentTime],dict.description] userInfo:nil];//数据上报
                    [Bugly reportException:exception];
                    if (yunxin.yunxin_id && yunxin.token) {
                        self->loginCount = 0;
                        NoticeUserInfoModel *userInfo = [NoticeSaveModel getUserInfo];
                        userInfo.yunxin_id = yunxin.yunxin_id;
                        userInfo.yunxin_token = yunxin.token;
                        [NoticeSaveModel saveUserInfo:userInfo];
                        [self loginToYunxin:userInfo];
                    }else{
                        if (self->loginCount < 5) {
                            self->loginCount++;
                            [self loginTiYunxin];
                        }
                    }
                }else{
                    NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@获取云信token接口调用成功，但获取失败\n时间%@\n获取的数据%@",[NoticeTools getuserId],[SXTools getCurrentTime],dict.description] userInfo:nil];//数据上报
                    [Bugly reportException:exception];
                    DRLog(@"获取云信token失败%@",dict.description);
                    if (self->loginCount < 5) {
                        self->loginCount++;
                        [self loginTiYunxin];
                    }
                }
            } fail:^(NSError *error) {
                DRLog(@"获取云信接口token失败%@",error.description);
                NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@获取云信token接口调用失败败\n时间%@\n失败理由%@",[NoticeTools getuserId],[SXTools getCurrentTime],error.description] userInfo:nil];//数据上报
                [Bugly reportException:exception];
                if (self->loginCount < 5) {
                    self->loginCount++;
                    [self loginTiYunxin];
                }
            }];
        }
    });
}

- (void)regTencent{
    [self regWangyiyun];

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


- (NoticeShopGetOrderTostView *)callView{
    if (!_callView) {
        _callView = [[NoticeShopGetOrderTostView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _callView.isAudioCalling = YES;
        __weak typeof(self) weakSelf = self;
        _callView.acceptBlock = ^(BOOL accept) {
            if(accept){
                NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@点击接听按钮\n房间号%@\n时间%@",[NoticeTools getuserId],weakSelf.currentRoomId,[SXTools getCurrentTime]] userInfo:nil];//数据上报
                [Bugly reportException:exception];
                [weakSelf accept];
            }else{
                NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@点击拒接按钮\n房间号%@\n时间%@",[NoticeTools getuserId],weakSelf.currentRoomId,[SXTools getCurrentTime]] userInfo:nil];//数据上报
                [Bugly reportException:exception];
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
                        NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@点击接听按钮调用接听接口成功\n房间号%@\n时间%@",[NoticeTools getuserId],weakSelf.currentRoomId,[SXTools getCurrentTime]] userInfo:nil];//数据上报
                        [Bugly reportException:exception];
                        [weakSelf acceptCall];
                    }else{
                        NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@点击接听按钮调用接听接口失败\n房间号%@\n时间%@\n失败理由%@",[NoticeTools getuserId],weakSelf.currentRoomId,[SXTools getCurrentTime],dict.description] userInfo:nil];//数据上报
                        [Bugly reportException:exception];
                        [weakSelf hanupyunxin];
                    }
                    
                    [[NoticeTools getTopViewController] hideHUD];
                } fail:^(NSError * _Nullable error) {
                    NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@点击接听按钮调用接听接口请求失败\n房间号%@\n时间%@\n失败理由%@",[NoticeTools getuserId],weakSelf.currentRoomId,[SXTools getCurrentTime],error.description] userInfo:nil];//数据上报
                    [Bugly reportException:exception];
                    
                    [weakSelf hanupyunxin];
                    [[NoticeTools getTopViewController] hideHUD];
                    self.noReClick = NO;
                }];
            }else { // 没有麦克风权限
                NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@点击接听按钮没有麦克风权限\n房间号%@\n时间%@",[NoticeTools getuserId],weakSelf.currentRoomId,[SXTools getCurrentTime]] userInfo:nil];//数据上报
                [Bugly reportException:exception];
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
        [self hanupyunxin];
        return;
    }
    
    [self hanupyunxin];
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
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

//云信接听  当被叫 onInvited 回调发生，调用 accept 接听呼叫
- (void)acceptCall{
    __weak typeof(self) weakSelf = self;
    [[NECallEngine sharedInstance] accept:^(NSError * _Nullable error, NECallInfo * _Nullable callInfo) {
        if (!error) {
            DRLog(@"接听成功");
            NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@点击接听按钮接听成功\n房间号%@\n时间%@\n",[NoticeTools getuserId],weakSelf.currentRoomId,[SXTools getCurrentTime]] userInfo:nil];//数据上报
            [Bugly reportException:exception];
        }else{
            NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@点击接听按钮接听失败\n房间号%@\n时间%@\n理由%@",[NoticeTools getuserId],weakSelf.currentRoomId,[SXTools getCurrentTime],error.description] userInfo:nil];//数据上报
            [Bugly reportException:exception];
            [[NoticeTools getTopViewController] showToastWithText:[NSString stringWithFormat:@"接听失败%@",error.description]];
        }
    }];
}

//挂断云信电话
- (void)hanupyunxin{
    __weak typeof(self) weakSelf = self;
    NEHangupParam *hangupParam = [[NEHangupParam alloc] init];
    [[NECallEngine sharedInstance] hangup:hangupParam completion:^(NSError * _Nullable error) {
        if (!error) {
            NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@挂断成功\n房间号%@\n时间%@\n",[NoticeTools getuserId],weakSelf.currentRoomId,[SXTools getCurrentTime]] userInfo:nil];//数据上报
            [Bugly reportException:exception];
            DRLog(@"挂断云信电话");
        }else{
            NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@挂断失败\n房间号%@\n时间%@\n理由%@",[NoticeTools getuserId],weakSelf.currentRoomId,[SXTools getCurrentTime],error.description] userInfo:nil];//数据上报
            [Bugly reportException:exception];
            DRLog(@"挂断云信失败%@",error.description);
        }
    }];

}

//获取等待的订单
- (void)getOrder{
    __weak typeof(self) weakSelf = self;
    self.noReClick = NO;
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopGoodsOrder/select?type=2" Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            DRLog(@"当前进行中等待中的订单%@",dict);
       
            self.orderModel = [NoticeByOfOrderModel mj_objectWithKeyValues:dict[@"data"]];
            self.fromUserId = self.orderModel.user_id;
            
            NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@获取等待中的订单成功\n房间号%@\n时间%@\n电话来自%@",[NoticeTools getuserId],weakSelf.currentRoomId,[SXTools getCurrentTime],self.fromUserId] userInfo:nil];//数据上报
            [Bugly reportException:exception];
            
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
        NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@获取等待中的订单请求失败\n房间号%@\n时间%@\n理由%@",[NoticeTools getuserId],weakSelf.currentRoomId,[SXTools getCurrentTime],error.description] userInfo:nil];//数据上报
        [Bugly reportException:exception];
    }];
}

/// 通话建立的回调
/// @param info 通话建立回调信息
- (void)onCallConnected:(NECallInfo *)info{
    self.calleruid = info.calleeInfo.uid;
    [self clearCallWaitView];
    self.chatTime = 0;
    self.currentRoomId = info.rtcInfo.channelName;
    DRLog(@"接通电话房间号%@",info.rtcInfo.channelName);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOPCANCELORDER" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOPHASJUBAOEDSELFJUBAO" object:nil];
    self.callingView = nil;
    NoticeCallView *callView = [[NoticeCallView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    self.callingView = callView;
    __weak typeof(self) weakSelf = self;
    callView.chatTimeBlock = ^(NSInteger chatTime) {
        weakSelf.chatTime = chatTime;
    };
    //正式的时候打开这里
    self.callingView.roomId = self.currentRoomId;
    callView.fromUserId = self.fromUserId;
    callView.toUserId = self.toUserId;
    [callView showCallView];
    [[NoticeTools getTopViewController] hideHUD];
    
    NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@和%@通话建立成功\n房间号%@\n时间%@\n",[NoticeTools getuserId],self.fromUserId,info.rtcInfo.channelName,[SXTools getCurrentTime]] userInfo:nil];//数据上报
    [Bugly reportException:exception];
}

/// 通话结束
/// @param info 通话结束携带信息
- (void)onCallEnd:(NECallEndInfo *)info{
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];

    [self clearCallWaitView];
    
    DRLog(@"通话结束回调的当前通话房间号信息%@",self.currentRoomId);

    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOPOVERCHATORDER" object:nil];
    if (info.reasonCode == TerminalCodeTimeOut) {
        DRLog(@"超时");
        if(!self.autoCallNexting){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOPNOACCEPECT" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOPCANCELORDER" object:nil];
        }
        
        NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@和%@通话结束\n房间号%@\n时间%@\n理由:超时",[NoticeTools getuserId],self.fromUserId,self.currentRoomId,[SXTools getCurrentTime]] userInfo:nil];//数据上报
        [Bugly reportException:exception];
        
    }else if (info.reasonCode == TerminalCodeBusy){
        DRLog(@"用户占线");
        NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@和%@通话结束\n房间号%@\n时间%@\n理由:用户占线",[NoticeTools getuserId],self.fromUserId,self.currentRoomId,[SXTools getCurrentTime]] userInfo:nil];//数据上报
        [Bugly reportException:exception];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOPCANCELORDER" object:nil];
    }else if (info.reasonCode == TerminalCodeRtcInitError){
        NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@和%@通话结束\n房间号%@\n时间%@\n理由:rtc 初始化失败",[NoticeTools getuserId],self.fromUserId,self.currentRoomId,[SXTools getCurrentTime]] userInfo:nil];//数据上报
        [Bugly reportException:exception];
        DRLog(@"rtc 初始化失败");
    }else if (info.reasonCode == TerminalCodeJoinRtcError){
        DRLog(@"加入rtc失败");
    }else if (info.reasonCode == TerminalCodeCancelErrorParam){
        DRLog(@"cancel 取消参数错误");
    }else if (info.reasonCode == TerminalCodeCallFailed){
        DRLog(@"发起呼叫失败");
    }else if (info.reasonCode == TerminalCodeKicked){
        DRLog(@"TerminalCodeKicked");
    }else if (info.reasonCode == TerminalCodeEmptyUid){
        DRLog(@" uid 为空");
    }else if (info.reasonCode == TerminalRtcDisconnected){
        DRLog(@"Rtc 断连");
        NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@和%@通话结束\n房间号%@\n时间%@\n理由:Rtc 断连",[NoticeTools getuserId],self.fromUserId,self.currentRoomId,[SXTools getCurrentTime]] userInfo:nil];//数据上报
        [Bugly reportException:exception];
        [self orderFinish];
    }else if (info.reasonCode == TerminalCallerCancel){
        DRLog(@"取消呼叫");
    }else if (info.reasonCode == TerminalCalleeCancel){
        DRLog(@"呼叫被取消");
        [[NoticeTools getTopViewController] hideHUD];
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"对方取消了订单" message:nil cancleBtn:@"好的，知道了"];
        [alerView showXLAlertView];
        
        NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@和%@通话结束\n房间号%@\n时间%@\n理由:拨打的人取消了通话，也就是呼叫被取消",[NoticeTools getuserId],self.fromUserId,self.currentRoomId,[SXTools getCurrentTime]] userInfo:nil];//数据上报
        [Bugly reportException:exception];
    }else if (info.reasonCode == TerminalCalleeReject){
        DRLog(@"拒绝呼叫");
        NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@和%@通话结束\n房间号%@\n时间%@\n理由:拒绝呼叫",[NoticeTools getuserId],self.fromUserId,self.currentRoomId,[SXTools getCurrentTime]] userInfo:nil];//数据上报
        [Bugly reportException:exception];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOPCANCELORDER" object:nil];

    }else if (info.reasonCode == TerminalCallerRejcted){
        DRLog(@"呼叫被拒绝");
        NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@和%@通话结束\n房间号%@\n时间%@\n理由:呼叫被拒拒绝",[NoticeTools getuserId],self.fromUserId,self.currentRoomId,[SXTools getCurrentTime]] userInfo:nil];//数据上报
        [Bugly reportException:exception];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOPCANCELORDER" object:nil];
   
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
    }else if (info.reasonCode == TerminalBeHuangUp){
        DRLog(@"对方挂断了呼叫中的通话");
        NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@和%@通话结束\n房间号%@\n时间%@\n理由:对方挂断了呼叫中的通话",[NoticeTools getuserId],self.fromUserId,self.currentRoomId,[SXTools getCurrentTime]] userInfo:nil];//数据上报
        [Bugly reportException:exception];
        [self orderFinish];
    }else if (info.reasonCode == TerminalUserRtcDisconnected){
        DRLog(@"Rtc房间断开链接");
        NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@和%@通话结束\n房间号%@\n时间%@\n理由:Rtc房间断开链接",[NoticeTools getuserId],self.fromUserId,self.currentRoomId,[SXTools getCurrentTime]] userInfo:nil];//数据上报
        [Bugly reportException:exception];
    }else if (info.reasonCode == TerminalUserRtcLeave){
        DRLog(@"离开Rtc房间");
        NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@和%@通话结束\n房间号%@\n时间%@\n理由:离开Rtc房间",[NoticeTools getuserId],self.fromUserId,self.currentRoomId,[SXTools getCurrentTime]] userInfo:nil];//数据上报
        [Bugly reportException:exception];
    }else if (info.reasonCode == TerminalAcceptFail){
        DRLog(@"接听失败");
    }else if (info.reasonCode == TerminalHuangUp){
        DRLog(@"挂断通话中的电话");
        NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@和%@通话结束\n房间号%@\n时间%@\n理由:挂断通话中的电话",[NoticeTools getuserId],self.fromUserId,self.currentRoomId,[SXTools getCurrentTime]] userInfo:nil];//数据上报
        [Bugly reportException:exception];
        [self orderFinish];
    }
    
    self.autoCallNexting = NO;
    self.fromUserId = nil;
    self.toUserId = nil;
}

- (void)orderFinish{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    NSInteger totalTime = self.chatTime;
    if(totalTime < 1){
        totalTime = 1;
    }
    [parm setObject:[NSString stringWithFormat:@"%d",(int)totalTime] forKey:@"second"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shopGoodsOrder/complete/0/%@",self.currentRoomId] Accept:@"application/vnd.shengxi.v5.5.0+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            DRLog(@"订单这设置为完成");
            
            self.currentRoomId = nil;
        }
    } fail:^(NSError * _Nullable error) {
    }];
    [[NoticeTools getTopViewController] hideHUD];
}

//收到通话请求
- (void)onReceiveInvited:(NEInviteInfo *)info{

    NECallInfo *callinfo = [[NECallEngine sharedInstance] getCallInfo];
    self.currentRoomId = callinfo.rtcInfo.channelName;
    DRLog(@"收到%@的通话请求\n房间号%@",info.callerAccId,callinfo.rtcInfo.channelName);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HASGETSHOPVOICECHANTTOTICE" object:nil];
    self.fromUserId = info.extraInfo;
    NSException *exception = [NSException exceptionWithName:@"云信相关" reason:[NSString stringWithFormat:@"%@收到%@通话请求\n房间号%@\n时间%@\n",[NoticeTools getuserId],info.callerAccId,self.currentRoomId,[SXTools getCurrentTime]] userInfo:nil];//数据上报
    [Bugly reportException:exception];
    //正式需要打开这里，调试的时候注释了
    [self getOrder];

}

- (void)clearCallWaitView{
    [self.callView removeFromSuperview];
    self.callingWindow.hidden = YES;
    self.callingWindow = nil;
}

@end
